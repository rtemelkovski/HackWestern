#!/usr/bin/python3

import requests
from datetime import datetime, timedelta,time

def getDiff(t1,t2):
	t1_ms = (t1.hour*60*60 + t1.minute*60 + t1.second)*1000 + t1.microsecond
	t2_ms = (t2.hour*60*60 + t2.minute*60 + t2.second)*1000 + t2.microsecond

	delta_ms = max([t1_ms, t2_ms]) - min([t1_ms, t2_ms])
	return delta_ms


defaultSource = 'http://192.168.0.103:5000/api/schedules?action=default'
preNotificationLink = 'http://192.168.0.103:5000/api/schedules/notification'
postNotificationLink = 'http://192.168.0.103:5000/api/schedules/notification'

jsonReply = requests.get(url = defaultSource).json()
firstItem= jsonReply[0]
print(firstItem)

datetimeArr2 = firstItem['occurance'].split('T')[0].split('-')
datetimeArr = firstItem['occurance'].split('T')[1].split(':')
timeInst = datetime(int(datetimeArr2[0].encode('utf-8')),int(datetimeArr2[1].encode('utf-8')),int(datetimeArr2[2].encode('utf-8')),int(datetimeArr[0].encode('utf-8')),int(datetimeArr[1].encode('utf-8')),int(datetimeArr[2].encode('utf-8')))

currTime = datetime.now()
thirtyMinsFuture = (currTime + timedelta(minutes=30))
fiveMinsPast = (currTime - timedelta(minutes=5))

if currTime < timeInst and timeInst < thirtyMinsFuture:
	print('here')
	requests.put(url = postNotificationLink+ '/' + str(firstItem['id']) +'?action=post')

if timeInst < currTime and timeInst > fiveMinsPast:
	print('here')
	requests.put(url = preNotificationLink+'/' + str(firstItem['id']) +'?action=pre')

# for entry in jsonReply:
    # for event in entry['events']:
        # # print(event['occurance'])
        # print(event['occurance'])
        # print(datetime.now())
        


