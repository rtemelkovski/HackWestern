import RPi.GPIO as GPIO
import requests
GPIO.setmode(GPIO.BCM)
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(6, GPIO.OUT)
GPIO.output(6,GPIO.LOW)
interruptLink = 'http://192.168.0.103:5000/api/schedules/interrupt'
               
def pillInt():
    requests.put(url = interruptLink)

#GPIO.output(6,GPIO.LOW) - LED off
#GPIO.output(6,GPIO.HIGH) - LED on

GPIO.add_event_detect(5, GPIO.FALLING, callback = pillInt, bouncetime = 300)