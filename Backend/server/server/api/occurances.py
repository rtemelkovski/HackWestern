# -*- coding: utf-8 -*-
from flask import Blueprint,request
from flask_restful import Api, Resource
from models import Occurance

occurances_api = Api(Blueprint('occurances_api', __name__)) # pylint: disable=invalid-name

@occurances_api.resource('/occurances/<int:occurance_id>')
class OccuranceAPI(Resource):
    @staticmethod
    def put(occurance_id):
        from app import db
        occurance = Occurance.query.get_or_404(occurance_id)
        if request.args['action'] == 'taken':
            occurance.pill_taken = True
        else:
            occurance.pill_missed = True
        db.session.add(occurance)
        db.session.commit()

        return None, 204
