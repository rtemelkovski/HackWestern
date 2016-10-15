# -*- coding: utf-8 -*-
from flask import Blueprint,request
from flask_restful import Api, Resource
from models import Occurance

occurances_api = Api(Blueprint('occurances_api', __name__)) # pylint: disable=invalid-name

@occurances_api.resource('/occurances')
class OccurancesApi(Resource):
    @staticmethod
    def get():
        occurances = Occurance.query
        return [{
            'id': occurance.id,
            'created': occurance.created.isoformat() + 'Z'
        } for occurance in occurances]

    @staticmethod
    def post():
        from app import db

        occurance = Occurance()
        db.session.add(occurance)
        db.session.commit()

        return {
            'id': new_kitten.id,
            'created': new_kitten.created.isoformat() + 'Z'
        }

@occurances_api.resource('/occurances/<int:kitten_id>')
class OccuranceAPI(Resource):
    @staticmethod
    def delete(kitten_id):
        from app import db
        occurance = Occurance.query.get_or_404(kitten_id)
        db.session.delete(occurance)
        db.session.commit()

        return None, 204
