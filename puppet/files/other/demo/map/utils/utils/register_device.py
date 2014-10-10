# install before using 
# sudo easy_install simplejson

import simplejson as json
import httplib, urllib
import csv
import sys
import time

import logging

# Params 4 generation
timestamp = 194896800
deltatime = 5
num_calls = 2
data_per_call = 2


# Set to 1 to force HTTPS 
SECURE = 0

# Your API Key
f = open('api_token.txt', 'r')
API_KEY = f.readline().replace('\n', '')
f.close()

# Configure basic Logging format
logging.basicConfig(level=logging.INFO,
    format='%(asctime)s %(levelname)-8s %(filename)s:%(lineno)-4d: %(message)s',
    datefmt='%m-%d %H:%M',
    )

# Import some tools to measure execution time -- NOT USED HERE
from timeit import Timer
from functools import partial
from datetime import tzinfo, timedelta, datetime #http://docs.python.org/library/datetime.html

def get_execution_time(function, numberOfExecTime, *args, **kwargs):
    """Return the execution time of a function in seconds."""
    return round(Timer(partial(function, *args, **kwargs))
                 .timeit(numberOfExecTime), 3)

# Create an "thng" class -- NOT USED HERE
class Thng(object):
	exposedAttributes = "name","description","product","tags"
	
	def __init__(self,name,description):
		self.name = name
		self.description = description


#---- Send requests to the engine and print responses	

# Print the response of the API
def print_response(response):
	logging.info(response['headers'])
	
	# pretty print response body if any
	if response['body'] != '':		
		logging.info("Response Content Body: \n")
		logging.info(response['body'])
	else:
		logging.info("No response body.")
	
# Sends a request to the EVRYTHNG Engine
def send_request(method, url, body='', headers='', username='', password=''):

	headers['Authorization'] = API_KEY 
	
	# Use HTTP or HTTPs Connection
	if SECURE:
		conn = httplib.HTTPSConnection(
			host="testbed.compose-project.eu",
			port=443,
		)
	else:
		logging.info("No Secure")		
		conn = httplib.HTTPConnection(		
			host="localhost",
      			port=8080,
		)
	
	# Build the HTTP(S) request with the body, headers, and ver
	conn.request(
		method=method,
		url=url,
		body=body,
		headers=headers
	)

	# Send the request
	logging.info("###  %s %s  ###" % (method,url))
	logging.info("Paylod: " + body)
	full_response = conn.getresponse()

	# Parse the response
	response={} # Parse the HTTP response
	response['body']=full_response.read()
	response['headers']=full_response.getheaders()
	response['status']=full_response.status
	response['reason']=full_response.reason
	conn.close()
	logging.info("###  %s %s  ###" % (response['status'],response['reason']))
	print_response(response)
	return response


#---- Implementation of a few endpoints in the engine 	

# Creates a thng
def create_thng(thngDocument):
	headers = {"Content-Type": "application/json"}
	response = send_request(
		method="POST",
		url="/",
		body=thngDocument,
		headers=headers
	)
	
	if response['status'] != 201:
		logging.error("oops, problem creating the thng. Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	


# Creates a subscription
def create_subscription(soId, streamId, subsDocument):
	headers = {"Content-Type": "application/json"}
	response = send_request(
		method="POST",
		url="/thngs/" + soId + "/streams/" + streamId + "/subscriptions",
		body=subsDocument,
		headers=headers
	)
	
	if response['status'] != 201:
		logging.error("oops, problem creating the subscription. Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	

def delete_thng(soId):
	headers = {"Content-Type": "application/json"}
	response = send_request(
		method="DELETE",
		url="/thngs/" + soId,
		headers=headers
	)
	
	if response['status'] != 200:
		logging.error("oops, problem deleting the thng . Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	

# Get the list of all the thngs of the user
def get_all_thngs():
	headers = {"Accept": "application/json"}
	response = send_request(
		method="GET",
		url="/",
		headers=headers
	)	
	
	if response['status'] != 200:
		logging.error("oops, problem getting all thngs. Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	


# Get a single thng
def get_thng(thngId):
	headers = {"Accept": "application/json"}
	send_request(
		method="GET",
		url="/thngs/%s" % thngId,
		headers=headers
	)

# Updates a thng
def update_thng(thngDocument,thngId):
	headers = {"Content-Type": "application/json"}
	send_request(
		method="PUT",
		url="/thngs/%s" % thngId,
		body=thngDocument,
		headers=headers
	)	

# Update sensor data /{soId}/streams/{streamId}/store.data
def updateSensorData(soId, streamId, data):
	headers = {"Content-Type": "application/json"}
	response = send_request(
		method="PUT",
		url="/thngs/%s/streams/%s/store.data" %(soId, streamId),
		body=data,
		headers=headers
	)	

	if response['status'] != 200:
		logging.error("oops, problem creating the subscription. Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	


f1 = open('so.json', 'r')
SO = json.load(f1)
f1.close()
print SO
response = create_thng(json.dumps(SO))
respy = json.loads(str(response['body']))
print '*****SO id: '+respy['id']
f1 = open('SO.id', 'w+')
f1.write(respy['id'])
f1.close()

f1 = open('so.json', 'r')
SO = json.load(f1)
f1.close()
print SO
response = create_thng(json.dumps(SO))
respy = json.loads(str(response['body']))
print '*****SO2 id: '+respy['id']
f1 = open('SO2.id', 'w+')
f1.write(respy['id'])
f1.close()

print 'END'
