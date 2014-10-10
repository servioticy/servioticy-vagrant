import time

__author__ = 'alvaro'

import configparser
import json
import random
import networkx as nx
#import pylab as p

import httplib2


class Setup:
    def __init__(self, config_path):
        self.topologies = []
        self.config = configparser.ConfigParser()
        self.initial_streams = []

        self.config.read(config_path)

        random.seed()

        num_topologies = round(eval(self.config['TOPOLOGIES']['Topologies']))
        if num_topologies < 1:
            num_topologies = 1
        for i in range(num_topologies):
            self.topologies.append(Topology(config_path))
            self.initial_streams += self.topologies[-1].initial_streams
        return

    def write_initial_streams(self, out_path):
        # Store the initial streams in the out_path
        f = open(out_path, 'w')
        f.write(json.dumps(self.initial_streams))
        f.close()
        return


class Topology:
    def __init__(self, config_path):
        self.config = configparser.ConfigParser()
        self.initial_streams = []
        self.streams = []
        self.so_graph = nx.DiGraph()
        self.stream_graph = nx.DiGraph()
        self.channel_graph = nx.DiGraph()

        self.config.read(config_path)

        num_sos = round(eval(self.config['TOPOLOGIES']['SOs']))
        if num_sos < 0:
            num_sos = 0
        self.put_initial_so()
        for i in range(num_sos):
            self.put_so()
        return

    def put_initial_so(self):
        streams = []
        num_initial_streams = round(eval(self.config['TOPOLOGIES']['InitialStreams']))
        if num_initial_streams < 1:
            num_initial_streams = 1

        json_file = open('./jsons/initial_so.json')
        json_so = json.load(json_file)
        json_file.close()

        for i in range(num_initial_streams):
            json_stream = self.make_stream()

            json_so['streams']['stream' + str(i)] = json_stream
            streams += ['stream' + str(i)]

        response, content = self.request('', 'POST', json.dumps(json_so))
        if int(response['status']) >= 300:
            print(content + '\n')
            return []
        json_content = json.loads(content)
        so_id = json_content['id']

        self.so_graph.add_node(so_id)

        for stream in streams:
            self.initial_streams += [[so_id, stream]]
            self.streams += [[so_id, stream]]

            self.stream_graph.add_node(so_id + ":" + stream)

        return

    def put_so(self):
        initial_stream_ids = []
        stream_ids = []
        initial_streams = []
        streams = []
        num_streams = round(eval(self.config['TOPOLOGIES']['Streams']))
        if num_streams < 0:
            num_streams = 0

        json_file = open('./jsons/so.json')
        json_so = json.load(json_file)
        json_file.close()

        # Aliases

        json_so['aliases'] = self.make_aliases()

        # Streams
        for i in range(num_streams):
            json_stream = self.make_stream()

            json_so['streams']['stream' + str(i)] = json_stream
            initial_stream_ids += ['stream' + str(i)]

        # Groups
        json_so['groups'] = self.make_groups()

        # CStreams
        input_sets, cstreams = self.make_cstreams(initial_stream_ids, json_so['groups'])
        json_so['streams'] = dict(
            list(json_so['streams'].items()) + list(cstreams.items()))
        response, content = self.request('', 'POST', json.dumps(json_so))
        if int(response['status']) >= 300:
            print(content + '\n')
            return [], []
        json_content = json.loads(content)
        so_id = json_content['id']

        self.so_graph.add_node(so_id)
        for initial_stream_id in initial_stream_ids:
            self.initial_streams += [[so_id, initial_stream_id]]
            self.stream_graph.add_node(so_id + ":" + initial_stream_id)
        for stream_id in json_so['streams'].keys():
            self.streams += [[so_id, stream_id]]
            self.stream_graph.add_node(so_id + ":" + stream_id)

        for k in json_so['groups'].keys():
            for soid in json_so['groups'][k]["soIds"]:
                self.so_graph.add_edge(soid, so_id)

        for k in input_sets.keys():
            self.stream_graph.add_node(so_id + ":" + k)
            for group_ids in input_sets[k]['groups']:
                for group_id in group_ids:
                    for group in json_so['groups'][group_id]:
                        for soId in json_so['groups'][group_id]["soIds"]:
                            self.stream_graph.add_edge(soId + ":" + json_so['groups'][group_id]["stream"],
                                                       so_id + ":" + k)

            for stream_ids in input_sets[k]['streams']:
                for stream_id in stream_ids:
                    self.stream_graph.add_edge(so_id + ":" + stream_id, so_id + ":" + k)


        return

    def make_stream(self):
        num_channels = 1  # round(eval(self.config['TOPOLOGIES']['Channels']))
        if num_channels < 1:
            num_channels = 1
        json_file = open('./jsons/initial_stream.json')
        json_stream = json.load(json_file)
        json_file.close()
        json_file = open('./jsons/initial_channel.json')
        json_channel = json.load(json_file)
        json_file.close()

        for i in range(num_channels):
            json_stream['channels']['channel' + str(i)] = json_channel

        return json_stream

    def make_aliases(self):
        json_file = open('./jsons/aliases.json')
        json_aliases = json.load(json_file)
        json_file.close()
        return json_aliases


    def make_groups(self):
        num_groups = round(eval(self.config['TOPOLOGIES']['MaxGroups']))
        member_distribution = self.config['TOPOLOGIES']['MemberDistribution']
        available_streams = self.streams
        groups = {}
        if num_groups < 1:
            num_groups = 1
        if member_distribution == 'deterministic':
            return self.make_groups_det()

        for i in range(num_groups):
            not_found = True
            if len(available_streams) == 0:
                break
            while not_found:
                sel_stream = eval(member_distribution)
                # if sel_stream < 0 or sel_stream >= len(prev_streams):
                #     continue
                if sel_stream < 0:
                    sel_stream = 0
                elif sel_stream > 1:
                    sel_stream = len(available_streams) - 1
                else:
                    sel_stream = round(sel_stream * (len(available_streams) - 1))
                groups['group' + str(i)] = {}
                groups['group' + str(i)]['soIds'] = [available_streams[sel_stream][0]]
                groups['group' + str(i)]['stream'] = available_streams[sel_stream][1]
                available_streams.pop(sel_stream)
                not_found = False
        return groups


    def make_groups_det(self):
        num_groups = round(eval(self.config['TOPOLOGIES']['MaxGroups']))
        available_streams = self.streams
        groups = {}
        if num_groups < 1:
            num_groups = 1
        for i in range(num_groups):
            if len(available_streams) == 0:
                break
            sel_stream = i % (len(available_streams))
            groups['group' + str(i)] = {}
            groups['group' + str(i)]['soIds'] = [available_streams[sel_stream][0]]
            groups['group' + str(i)]['stream'] = available_streams[sel_stream][1]
            available_streams.pop(sel_stream)

        return groups


    def make_cstreams(self, init_streams, groups):
        num_cstreams = round(eval(self.config['TOPOLOGIES']['CompositeStreams']))
        cstreams = {}
        input_sets = {}
        if num_cstreams < 1:
            num_cstreams = 1
        stream_ids = []
        group_ids = []

        stream_ids += init_streams

        for key in groups.keys():
            group_ids += [key]

        group_distribution = self.config['TOPOLOGIES']['GroupDistribution']
        stream_distribution = self.config['TOPOLOGIES']['StreamRefsDistribution']

        for i in range(num_cstreams):
            group_set = []
            stream_set = []
            stream_ids += ['cstream' + str(
                i)]  # If this is generated in another for i in range(num_cstreams) outside, it would generate cycles.
            ratio = round(len(group_ids) / num_cstreams)
            if ratio < 1:
                ratio = 1
            if group_distribution == 'deterministic':
                group_set = group_ids[i * ratio:] + group_ids[:i * ratio]
            else:
                group_set = group_ids

            if stream_distribution == 'deterministic':
                stream_set = stream_ids[i * ratio:] + stream_ids[:i * ratio]
            else:
                stream_set = stream_ids

            input_sets['cstream' + str(i)], cstreams['cstream' + str(i)] = self.make_cstream(group_set, stream_set)

        return input_sets, cstreams


    def make_cstream(self, group_subset, stream_subset):
        input_sets, json_channels = self.make_channels(group_subset, stream_subset)

        pre_ms = round(eval(self.config['TOPOLOGIES']['PreFilterMS']))
        post_ms = round(eval(self.config['TOPOLOGIES']['PostFilterMS']))
        pre_prob = round(eval(self.config['TOPOLOGIES']['PreFilterProb']))
        post_prob = round(eval(self.config['TOPOLOGIES']['PostFilterProb']))

        if pre_ms < 0:
            pre_ms = 0
        if post_ms < 0:
            post_ms = 0

        json_file = open('./jsons/stream.json')
        json_cstream = json.load(json_file)
        json_file.close()

        json_cstream['pre-filter'] = '@presleep-filter@' + str(pre_ms) + '@postsleep-filter@'
        if pre_prob < 1:
            pre_prob = 1
        json_cstream['pre-filter'] += '{$.lastUpdate} %' + str(pre_prob) + '==(' + str(pre_prob) + ' - 1)'

        json_cstream['post-filter'] = '@presleep-filter@' + str(post_ms) + '@postsleep-filter@'
        if post_prob < 1:
            post_prob = 1
        json_cstream['post-filter'] += '({$.lastUpdate}+1) %' + str(post_prob) + '==(' + str(post_prob) + ' - 1)'

        json_cstream['channels'] = json_channels

        return input_sets, json_cstream


    def make_channels(self, group_subset, stream_subset):
        channels = {}
        num_channels = round(eval(self.config['TOPOLOGIES']['Channels']))
        if num_channels < 1:
            num_channels = 1
        group_distribution = self.config['TOPOLOGIES']['GroupDistribution']
        group_operands = self.config['TOPOLOGIES']['GroupOperands']
        stream_distribution = self.config['TOPOLOGIES']['StreamRefsDistribution']
        stream_operands = self.config['TOPOLOGIES']['StreamOperands']

        group_sets = self.distribute_operands(group_subset, num_channels, group_operands, group_distribution)
        stream_sets = self.distribute_operands(stream_subset, num_channels, stream_operands, stream_distribution)

        input_sets = {"groups": group_sets, "streams": stream_sets}

        for i in range(num_channels):
            channels['channel' + str(i)] = self.make_channel(group_sets[i] + stream_sets[i])

        return input_sets, channels


    def distribute_operands_det(self, operands, num_sets, num_members):
        operand_sets = []
        j = 0
        for i in range(num_sets):
            nm = round(eval(num_members))
            if nm > len(operands):
                nm = len(operands)
            elif nm < 1:
                nm = 1
            operand_sets.append((operands + operands)[j:j + nm])
            j = (j + nm) % len(operands)
        return operand_sets


    def distribute_operands(self, operands, num_sets, num_members, distribution):
        if distribution == 'deterministic':
            return self.distribute_operands_det(operands, num_sets, num_members)
        operand_sets = []
        for i in range(num_sets):
            operand_sets.append([])
            nm = round(eval(num_members))

            if nm < 1:
                nm = 1
            for j in range(nm):
                not_found = True
                while not_found:
                    sel_operand = round(eval(distribution))
                    # if sel_operand < 0 or sel_operand >= len(operands):
                    #     continue
                    if sel_operand < 0:
                        sel_operand = 0
                    elif sel_operand > 1:
                        sel_operand = len(operands) - 1
                    else:
                        sel_operand = round(sel_operand * (len(operands) - 1))
                    operand_sets[i] += [operands[sel_operand]]
                    not_found = False
        return operand_sets


    def make_channel(self, operands):
        ms = round(eval(self.config['TOPOLOGIES']['CurrentValueMS']))
        if ms < 0:
            ms = 0
        json_file = open('./jsons/channel.json')
        json_channel = json.load(json_file)
        json_file.close()

        json_channel['current-value'] = '@presleep-cv@' + str(ms) + '@postsleep-cv@' + '0'
        for operand in operands:
            json_channel['current-value'] += '+{$' + operand + '.channels.channel0.current-value}'

        return json_channel

    def request(self, partial_url, method, body):
        time.sleep(0.5)
        headers = {
            'Authorization': self.config['API']['AuthToken'],
            'Content-Type': 'application/json; charset=UTF-8'
        }
        h = httplib2.Http()
        response, content = h.request(
            self.config['API']['BaseAddress'] + partial_url,
            method,
            body,
            headers)
        return response, content.decode('utf-8')


def main():
    setup = Setup('../benchmark.ini')
    setup.write_initial_streams(setup.config['TOPOLOGIES']['InitialStreamsFile'])

    for i in range(len(setup.topologies)):
        nx.write_gml(setup.topologies[i].so_graph,
                     setup.config['TOPOLOGIES']['GraphsDir'] + 'so_graph_' + str(i) + '.gml')
        nx.write_gml(setup.topologies[i].stream_graph,
                     setup.config['TOPOLOGIES']['GraphsDir'] + 'stream_graph_' + str(i) + '.gml')
    #p.show()
    return


if __name__ == '__main__':
    main()
