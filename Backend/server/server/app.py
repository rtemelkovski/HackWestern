import os
from flask.ext.sqlalchemy import SQLAlchemy
from logging import StreamHandler
from sys import stdout
from flask import Flask

db = SQLAlchemy()

def create_app():
    from api.occurances import occurances_api
    from api.schedules import schedules_api

    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ['DATABASE_URL']

    app.register_blueprint(occurances_api.blueprint, url_prefix='/api')
    app.register_blueprint(schedules_api.blueprint, url_prefix='/api')

    db.init_app(app)

    handler = StreamHandler(stdout)
    app.logger.addHandler(handler)
    return app
