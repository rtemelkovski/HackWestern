# -*- coding: utf-8 -*-
from flask import Blueprint,request,jsonify
from flask_restful import Api, Resource
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
        schedules = Schedule.query
        return [schedule.toJSON() for schedule in schedules]

    @staticmethod
    def post():
        from app import db
        
        data = request.form
        schedule = Schedule(data['name'],data['start'],data['end'])
        db.session.add(schedule)
        db.session.commit()
        print(schedule.toJSON())

        times = ast.literal_eval(data['time'])
        dates = schedule.getActiveDates()
        dateTimes = []
        for date in dates:
            for time in times:
                dateTime = getDateTimeFromString(date,time)
                dateTimes.append(dateTime)

        saveObjs = []
        print(schedule.toJSON())
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
    def delete(schedule_id):
        from app import db
        schedule = Schedule.query.get_or_404(schedule_id)
        db.session.delete(schedule)
        db.session.commit()

        return None, 204
