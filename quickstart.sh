#!/bin/bash
if [ "$1" != "" ]; then
	gosu root nano /etc/odbc.ini
	fi
fabmanager create-admin --app superset --username admin --firstname admin --lastname admin --email admin@fab.org --password admin
superset runserver -d &
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/CN=localhost' -keyout mykey.key -out mycert.pem
jupyter notebook --certfile mycert.pem --keyfile mykey.key &

