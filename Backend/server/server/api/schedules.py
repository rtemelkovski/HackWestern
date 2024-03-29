# -*- coding: utf-8 -*-
from flask import Blueprint,request,jsonify
from flask_restful import Api, Resource
from sqlalchemy import and_,desc
from models import Schedule,Occurance
import ast
import datetime

schedules_api = Api(Blueprint('schedules_api', __name__)) # pylint: disable=invalid-name

def getDateTimeFromString(date,time):
    arr = date.split("-")
    tarr = time.split(':')
    return datetime.datetime(int(arr[0]),int(arr[1]),int(arr[2]),int(tarr[0]),int(tarr[1]),int(tarr[2]))

@schedules_api.resource('/schedules')
class SchedulesAPI(Resource):
    @staticmethod
    def get():
        returnResult = []
        currTime = datetime.datetime.now()
        if request.args['action'] == 'taken':
            returnResult = Occurance.query.filter(and_(Occurance.pill_taken == 1, Occurance.pill_missed == 0,Occurance.occurance_time > currTime)).order_by(Occurance.occurance_time)
        elif request.args['action'] == 'missed':
            returnResult = Occurance.query.filter(and_(Occurance.pill_taken == 0, Occurance.pill_missed == 1,Occurance.occurance_time > currTime)).order_by(Occurance.occurance_time)
        elif request.args['action'] == 'default':
            returnResult = Occurance.query.filter(and_(Occurance.pill_taken == 0, Occurance.pill_missed == 0,Occurance.occurance_time > currTime)).order_by(Occurance.occurance_time)
        elif request.args['action'] == 'all':
            returnResult = Occurance.query.order_by(desc(Occurance.occurance_time))
        resp = []
        for r in returnResult:
            resp.append(r.toJSON())
        return resp


    @staticmethod
    def post():
        from app import db
        
        data = request.get_json()
        schedule = Schedule(data['name'],data['start'],data['end'])
        db.session.add(schedule)
        db.session.commit()

        times = []
        for time in data['time']:
            times.append(str(time))
        dates = schedule.getActiveDates()
        dateTimes = []
        for date in dates:
            for time in times:
                dateTime = getDateTimeFromString(date,time)
                dateTimes.append(dateTime)

        saveObjs = []
        for dateTime in dateTimes:
            newOccurence = Occurance(dateTime,schedule.id)
            db.session.add(newOccurence)
            db.session.commit()
            saveObjs.append(newOccurence.toJSON())

        return {
            "item" : schedule.toJSON(),
            "events" : saveObjs
        }

@schedules_api.resource('/schedules/<int:schedule_id>')
class ScheduleAPI(Resource):
    @staticmethod
    def get(schedule_id):
        returnResult = []
        schedules = [Schedule.query.get_or_404(schedule_id)]
        schedules = [schedule.toJSON() for schedule in schedules]
        current_time = datetime.datetime.utcnow()
        for pill_item in schedules:
            occurance_items = []
            if request.args['action'] == 'taken':
                occurance_items = Occurance.query.filter(and_(Occurance.schedule_id == pill_item['id'],Occurance.pill_taken == True, Occurance.pill_missed == False)).order_by(Occurance.occurance_time).all()
            elif request.args['action'] == 'missed':
                occurance_items = Occurance.query.filter(and_(Occurance.schedule_id == pill_item['id'],Occurance.pill_taken == False, Occurance.pill_missed == True)).order_by(Occurance.occurance_time).all()
            elif request.args['action'] == 'default':
                occurance_items = Occurance.query.filter(and_(Occurance.schedule_id == pill_item['id'],Occurance.pill_taken == False, Occurance.pill_missed == False)).order_by(Occurance.occurance_time).all()
            elif request.args['action'] == 'all':
                occurance_items = Occurance.query.filter(and_(Occurance.schedule_id == pill_item['id'])).order_by(Occurance.occurance_time).all()
            occuranceJson = []
            for occurance in occurance_items:
                occuranceJson.append(occurance.toJSON())

            return {
                "item" : pill_item,
                "events" : occuranceJson
            }


    @staticmethod
    def delete(schedule_id):
        from app import db
        schedule = Schedule.query.get_or_404(schedule_id)
        db.session.delete(schedule)
        db.session.commit()

        return None, 204

@schedules_api.resource('/schedules/notification/<int:occurance_id>')
class ScheduleNotificationAPI(Resource):
    @staticmethod
    def put(occurance_id):
        from app import db
        occurance = Occurance.query.get_or_404(occurance_id)
        if request.args['action'] == 'pre':
            occurance.pre_notification_sent = True
        elif request.args['action'] == 'post':
            occurance.post_notification_sent = True
        elif request.args['action'] == 'missed':
            occurance.pill_missed = True
        db.session.add(occurance)
        db.session.commit()

        return None, 204

@schedules_api.resource('/schedules/interrupt')
class ScheduleInterruptAPI(Resource):
    @staticmethod
    def put():
        from app import db
        occurances = Occurance.query.filter(Occurance.pill_taken == False).order_by(Occurance.occurance_time).all()
        if len(occurances) == 0:
            return None, 204

        mostUpcoming = occurances[0]
        mostUpcoming.pill_taken = True
        print(mostUpcoming.toJSON())
        db.session.add(mostUpcoming)
        db.session.commit()

        return None, 204

@schedules_api.resource('/schedule/<int:schedule_id>')
class SingleScheduleAPI(Resource):
    @staticmethod
    def get(schedule_id):
        from app import db
        schedule = Schedule.query.get_or_404(schedule_id)
        return schedule.toJSON()

@schedules_api.resource('/schedule/all')
class AllSchedulesAPI(Resource):
    @staticmethod
    def get():
        from app import db
        schedules = Schedule.query
        return [schedule.id for schedule in schedules]
        

