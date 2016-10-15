import RPi.GPIO as GPIO
import time
import sqlite3
import datetime
GPIO.setmode(GPIO.BOARD)
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def pillsRemoved():
    c.execute("SELECT occurance_time FROM pill_occurance WHERE schedule_id = '%s'" ) #Today call
    today_schedule_info = c.fetchall()
    current_time = strftime("%H:%M").split(":")
    curr_hour = int(current_time[0])
    curr_min = int(current_time[1])
    if curr_hour == 0:
        c.execute("SELECT occurance_time FROM pill_occurance WHERE schedule_id = '%s'" ) #Yesterday call only last date
        yesterday_last_pill = c.fetchone()
        yesterday_last_pill_time = yesterday_last_pill[0].split(":")
        yesterday_hour = int(yesterday_last_pill_time[0])
        yesterday_min = int(yesterday_last_pill_time[1])
        if (yesterday_hour == 23) && ((curr_min + 60 - yesterday_min) <= 30) && yesterday_last_pill[1] == False:
            #Send message saying that one is good
            #return/clear interrupt
    #NOT an else if or an else

    #execute regular checks
    #Should just be able to get the NEXT and the Previous time, based on current 
            
    #check first one of tomorrow
    if curr_hour == 23:
        c.execute("SELECT occurance_time FROM pill_occurance WHERE schedule_id = '%s'" ) #Tomorrow call only first day
        tomorrow_first_pill = c.fetchone()
        tomorrow_first_pill_time = tomorrow_first_pill[0].split(":")
        tomorrow_hour = int(yesterday_schedule_time[0])
        tomorrow_min = int(yesterday_schedule_time[1])
        if (tomorrow_hour == 0) && ((tomorrow_min + 60 - yesterday_min) <= 30) && tomorrow_first_pill[1] == False:
            #Send message saying that one is good
            #return/clear interruptd
            
            
    

GPIO.add_event_detect(5, GPIO.FALLING, callback = pillsPlaced, bouncetime = 300)

database_file = 'X' #Enter database file location here
connection = sqlite3.connect(database_file)
c = connection.cursor()
starttime=time.time()
while True:
    c.execute("SELECT occurance_time FROM pill_occurance WHERE schedule_id = '%s'" ) #fix
    pill_schedule_info = c.fetchall()
    current_time = strftime("%H:%M")
    for index in len(pill_schedule_info):
        if (pill_timing[0] == current_time) && pill_timing[1] == False:
            #Notify with hardware using LED
    time.sleep(60 - ((time.time() - starttime) % 60.0));
            
    
    
