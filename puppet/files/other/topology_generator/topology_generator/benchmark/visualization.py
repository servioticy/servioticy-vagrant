__author__ = 'alvaro'

import sys
import os

import networkx as nx
import pylab as p


def main():
    graphs = {}
    if os.path.isdir(sys.argv[1]):
        for file in os.listdir(sys.argv[1]):
            graphs[file] = nx.read_gml(sys.argv[1] + '/' + file)
    elif os.path.isfile(sys.argv[1]):
        graphs[sys.argv[1]] = nx.read_gml(sys.argv[1])

    if len(sys.argv) > 2:
        label = sys.argv[2]
        if len(sys.argv) > 3:
            label += ":" + sys.argv[3]
        for graph_key in graphs.keys():
            for i in range(len(graphs[graph_key].node)):
                current_label = graphs[graph_key].node[i]['label']
                if current_label == label:
                    G = nx.bfs_tree(graphs[graph_key], i)

                    node_colors = ['r'] * len(G.node)
                    node_colors[0] = 'b';
                    for node in G.node:
                        G.add_edges_from(nx.bfs_edges(graphs[graph_key], node))
                    p.figure(graph_key + " - " + label)
                    print(str(len(G.node)) + '\n')
                    nx.draw_spring(G, with_labels=True, node_color=node_colors)

    else:
        for graph_key in graphs.keys():
            node_colors = ['r'] * len(graphs[graph_key].node)
            in_degrees = graphs[graph_key].in_degree(graphs[graph_key])
            for n in graphs[graph_key].nodes():
                if in_degrees[n] == 0:
                    node_colors[n] = 'b'

            p.figure(graph_key)
            nx.draw_spring(graphs[graph_key], with_labels=True, node_color=node_colors)

    p.show()
    return


if __name__ == '__main__':
    main()