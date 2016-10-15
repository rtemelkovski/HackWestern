# -*- coding: utf-8 -*-
import datetime
from flask import json
from app import db

def getDateFromString(date):
	arr = date.split("-")
	return datetime.date(int(arr[0]),int(arr[1]),int(arr[2]))


class Schedule(db.Model):
	__tablename__ = 'pill_schedule'

	id = db.Column(db.Integer, primary_key=True,autoincrement=True)
	name = db.Column(db.String, nullable = False)
	start_date = db.Column(db.Date, nullable = False)
	end_date = db.Column(db.Date, nullable = False)

	def __init__(self,name,start,end):
		#self.created = None
		self.name = name
		self.start_date = getDateFromString(start)
		self.end_date = getDateFromString(end)

	def getActiveDates(self):
		diff = self.end_date - self.start_date
		returnResult = []
		for i in range(diff.days + 1):
			returnResult.append((self.start_date + datetime.timedelta(i)).isoformat())
		return returnResult

	def toJSON(self):
		return {
			"name": self.name,
			"start_date": self.start_date.isoformat(),
			"end_date": self.end_date.isoformat(),
			'id': self.id
		}