#!/bin/bash
# Startup script: create DB tables, then start gunicorn

python3 -c "
from app import create_app
from models import db
app = create_app('production')
with app.app_context():
    db.create_all()
    print('Database tables ready.')
"

exec gunicorn --bind 0.0.0.0:5000 --workers 2 --threads 4 'app:create_app("production")'
