import RPi.GPIO as GPIO
import requests
GPIO.setmode(GPIO.BOARD)
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP)
interruptLink = 'http://192.168.0.103:5000/api/schedules/interrupt'
               
def pillInt():
    requests.put(url = interruptLink)

GPIO.add_event_detect(5, GPIO.FALLING, callback = pillInt, bouncetime = 300)