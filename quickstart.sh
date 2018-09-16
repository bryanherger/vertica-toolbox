#!/bin/bash
if [ "$1" != "" ]; then
	gosu root nano /etc/odbc.ini
	fi
fabmanager create-admin --app superset --username admin --firstname admin --lastname admin --email admin@fab.org --password admin
superset runserver -d &
jupyter notebook &

