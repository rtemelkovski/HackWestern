#!/usr/bin/python3

import requests
from datetime import datetime, timedelta




defaultSource = 'http://192.168.0.103:5000/api/schedules?action=default'

jsonReply = requests.get(url = defaultSource).json()
firstItem= jsonReply[0]

print(firstItem.occurance)

#currTime = datetime.now()
#print(currTime + timedelta(minutes=5))
# for entry in jsonReply:
    # for event in entry['events']:
        # # print(event['occurance'])
        # print(event['occurance'])
        # print(datetime.now())
        



