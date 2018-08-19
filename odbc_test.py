import pyodbc
cnxn = pyodbc.connect('DRIVER={Vertica};SERVER=127.0.0.1;DATABASE=docker;UID=dbadmin;PWD=changeme')
cursor = cnxn.cursor()

cursor.execute("SELECT VERSION();")
for row in cursor.fetchall():
    print (row)
