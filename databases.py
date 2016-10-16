#!/usr/bin/python3
import RPi.GPIO as GPIO
import requests
from datetime import datetime, timedelta,time

def getDiff(t1,t2):
	t1_ms = (t1.hour*60*60 + t1.minute*60 + t1.second)*1000 + t1.microsecond
	t2_ms = (t2.hour*60*60 + t2.minute*60 + t2.second)*1000 + t2.microsecond

	delta_ms = max([t1_ms, t2_ms]) - min([t1_ms, t2_ms])
	return delta_ms

interruptLink = 'http://192.168.0.103:5000/api/schedules/interrupt'

gpHighO = False
def pillInt():
    print('take pill')
    if gpHighO:
    	GPIO.output(6,GPIO.LOW)
    #requests.put(url = interruptLink)

GPIO.setmode(GPIO.BCM)
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(6, GPIO.OUT)
GPIO.output(6,GPIO.LOW)
interruptLink = 'http://192.168.0.103:5000/api/schedules/interrupt'
GPIO.add_event_detect(5, GPIO.FALLING, callback = pillInt, bouncetime = 300)

defaultSource = 'http://192.168.0.103:5000/api/schedules?action=default'
preNotificationLink = 'http://192.168.0.103:5000/api/schedules/notification'
postNotificationLink = 'http://192.168.0.103:5000/api/schedules/notification'

starttime = time.time()
while True:
	jsonReply = requests.get(url = defaultSource).json()
	firstItem= jsonReply[0]

	datetimeArr2 = firstItem['occurance'].split('T')[0].split('-')
	datetimeArr = firstItem['occurance'].split('T')[1].split(':')
	timeInst = datetime(int(datetimeArr2[0].encode('utf-8')),int(datetimeArr2[1].encode('utf-8')),int(datetimeArr2[2].encode('utf-8')),int(datetimeArr[0].encode('utf-8')),int(datetimeArr[1].encode('utf-8')),int(datetimeArr[2].encode('utf-8')))

	currTime = datetime.now()
	thirtyMinsFuture = (currTime + timedelta(minutes=30))
	fiveMinsPast = (currTime - timedelta(minutes=5))

	# something is remaining valid for the next 30 mins, send notification
	if currTime < timeInst and timeInst < thirtyMinsFuture and not firstItem.post_notification_sent:
		print('30 mins left')
		#requests.put(url = postNotificationLink+ '/' + str(firstItem['id']) +'?action=post')
	# this is setting is missed
	if timeInst > thirtyMinsFuture:
		print('missed pill')
		GPIO.output(6,GPIO.LOW)
		gpHighO = False
		#requests.put(url = postNotificationLink+ '/' + str(firstItem['id']) +'?action=missed')
	# upcoming event in 5 mins
	if timeInst < currTime and timeInst > fiveMinsPast and not firstItem.pre_notification_sent:
		print('in 5 mins')
		GPIO.output(6,GPIO.HIGH)
		gpHighO = True
		#requests.put(url = preNotificationLink+'/' + str(firstItem['id']) +'?action=pre')
	time.sleep(60 - ((time.time() - starttime) % 60.0))

# for entry in jsonReply:
    # for event in entry['events']:
        # # print(event['occurance'])
        # print(event['occurance'])
        # print(datetime.now())
        



