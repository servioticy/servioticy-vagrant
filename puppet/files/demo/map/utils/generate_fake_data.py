import simplejson as json
import httplib, urllib
import csv
import sys
import time
import random
from random import uniform, randrange
import logging
from timeit import Timer
from functools import partial
from datetime import tzinfo, timedelta, datetime #http://docs.python.org/library/datetime.html

deltatime = 5
ndata = 50

# Your API Key
f = open('api_token.txt', 'r')
API_KEY = f.readline().replace('\n', '')
f.close()
print API_KEY

# Configure basic Logging format
logging.basicConfig(level=logging.INFO,
    format='%(asctime)s %(levelname)-8s %(filename)s:%(lineno)-4d: %(message)s',
    datefmt='%m-%d %H:%M',
    )


	
def send_request(method, url, body='', headers='', username='', password=''):

	headers['Authorization'] = API_KEY 
	conn = httplib.HTTPConnection(		
		host="localhost",
      		port=8080,
	)
	conn.request(
		method=method,
		url=url,
		body=body,
		headers=headers
	)

	#logging.info("###  %s %s  ###" % (method,url))
	full_response = conn.getresponse()

	response={} # Parse the HTTP response
	response['body']=full_response.read()
	response['headers']=full_response.getheaders()
	response['status']=full_response.status
	response['reason']=full_response.reason
	conn.close()
	logging.info("###  %s %s  ###" % (response['status'],response['reason']))
	return response



def updateSensorData(soId, streamId, data):
	headers = {"Content-Type": "application/json"}
	response = send_request(
		method="PUT",
		url="/%s/streams/%s" %(soId, streamId),
		body=data,
		headers=headers
	)	

	if response['status'] != 202:
		logging.error("oops, problem posting data. Error: " + str(response['status']))
		logging.error(response['headers'])
		logging.error(response['body'])
	
	return response	

baseData = """
{
    "channels": {
        "location": {
		"current-value": "40.12,-71.34"
	},
        "temperature": {
		"current-value": 10
	} 
    },
    "lastUpdate": 1199192925
}
"""


def newlat():
  return uniform(43.35,37.37)

def newlon():
  return uniform(-8.2, -0.3)

def newtemp():
  return uniform(5,40)

f1 = open('SO.id', 'r')
soId = f1.readline().replace('\n', '')
print "ID: "+soId
f1.close()

f2 = open('SO2.id', 'r')
soId2 = f2.readline().replace('\n', '')
print "ID: "+soId2
f2.close()

tmstmp = time.mktime(datetime.now().timetuple())
for d in range(ndata):
    sample = json.loads(baseData)
    sample['channels']['location']['current-value'] =  str(newlat()) + "," + str(newlon())
    sample['channels']['temperature']['current-value'] = round(newtemp(),2)
    print tmstmp
    sample['lastUpdate'] = long(tmstmp)
    tmstmp = tmstmp + deltatime
    print sample
    updateSensorData(soId, 'data', json.dumps(sample))
    sample['channels']['location']['current-value'] =  str(newlat()) + "," + str(newlon())
    sample['channels']['temperature']['current-value'] = round(newtemp(),2)
    print tmstmp
    sample['lastUpdate'] = long(tmstmp)
    tmstmp = tmstmp + deltatime
    print sample
    updateSensorData(soId2, 'data', json.dumps(sample))
    #time.sleep(4)
    

print 'END'
