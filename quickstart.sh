#!/bin/bash
fabmanager create-admin --app superset --username admin --firstname admin --lastname admin --email admin@fab.org --password admin
superset runserver -d &
jupyter notebook &

