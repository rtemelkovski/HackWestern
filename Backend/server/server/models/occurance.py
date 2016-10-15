# -*- coding: utf-8 -*-
from datetime import datetime

from app import db

class Occurance(db.Model):
	__tablename__ = 'pill_occurance'

	id = db.Column(db.Integer, primary_key=True,autoincrement= True)
	occurance_time = db.Column(db.DateTime, nullable = False)
	pill_taken = db.Column(db.Boolean, nullable = False, default = False)
	pill_missed = db.Column(db.Boolean, nullable = False, default = False)
	schedule_id = db.Column(db.Integer, nullable = False)
	pre_notification_sent = db.Column(db.Boolean, default = False)
	post_notification_sent = db.Column(db.Boolean, default = False)

	def __init__(self,occurance,id):
		self.occurance_time = occurance
		self.schedule_id = id
		self.pill_taken = False
		self.pill_missed = False
		self.pre_notification_sent = False
		self.post_notification_sent = False

	def toJSON(self):
		return {
			"occurance": self.occurance_time.isoformat(),
			"schedule_id": self.schedule_id,
			"pill_taken" : self.pill_taken,
			"pill_missed" : self.pill_missed,
			'id': self.id,
			"pre_notification_sent" : self.pre_notification_sent,
			"post_notification_sent" : self.post_notification_sent
		}