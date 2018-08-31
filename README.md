# vertica-toolbox
A Docker image collecting Jupyter Notebook, Superset, and other applications for Vertica users.

The overall goal is to provide a Docker image that enables Jupyter notebook with Python 3 and Vertica Python driver, plus a number of useful toolsets, popular data science libraries, and visualization add-ons.  Users could then install and run the Docker image for easy setup of a Jupyter notebook environment on top of Vertica.

Current image contents include:
- Jupyter Notebook
- Python 3 engine (using conda package management)
- Common data science libraries for Python: pandas, matplotlib, scipy, seaborn, scikit-learn, scikit-image, sympy, cython, patsy, statsmodel, cloudpickle, dill, numba, bokeh, vincent, beautifulsoup, xlrd
- Vertica client: vertica-python
- Visualization: plot.ly, Dash, Superset
- Machine learning with Vertica-ML-Python

Some example notebooks are included to demonstrate Vertica connectivity, functions, and visualizations in Python.

Open an issue here if you find any bugs or would like to suggest any additional features.

### Docker Cloud build

https://cloud.docker.com/swarm/bryanherger/repository/docker/bryanherger/vertica-toolbox/general

### Running the image

I typically test and run as follows:

```bash
sudo docker create --name vsqltoolbox -it -p 8088:8088 -p 8888:8888 -v $HOME/notebook:/home/jovyan/work bryanherger/vertica-toolbox:latest bash
sudo docker start -i vsqltoolbox
```

Once the image starts, run "nohup ./quickstart.sh &" to start the services. This exposes Superset on port 8088 and Jupyter on port 8888.

The default password for Jupyter is "changeme"

The default login for Superset is "admin"/"admin"

### Connecting to Vertica in Python scripts

Two methods are supported in Jupyter notebooks and Python script files run in the image.  You can use the vertica-python native driver:

```python
import vertica_python
# fill in your database info here
conn_info = {'host': '10.0.2.15', 
             'port' : 5433, 
             'user': 'dbadmin', 
             'password':'changeme', 
             'database': 'VMart', 
             'read_timeout': 600, 'unicode_error': 'strict', 'ssl': False, 'connection_timeout': 5}
# quick connection test
with vertica_python.connect(**conn_info) as connection:
    cur = connection.cursor()
    cur.execute("SELECT VERSION();")
    for row in cur.iterate():
        print(row)
```

The official ODBC driver and a /etc/odbcinst.ini are packaged in the image.  You can use pyodbc as follows:

```python
import pyodbc
cnxn = pyodbc.connect('DRIVER={Vertica};SERVER=127.0.0.1;DATABASE=docker;UID=dbadmin;PWD=changeme')
cursor = cnxn.cursor()

cursor.execute("SELECT VERSION();")
for row in cursor.fetchall():
    print (row)
```

### Connecting to Vertica in Superset

Add Vertica as a database in Data Sources.  Here is an example SQLAlchemy URI connection string:

vertica+vertica_python://dbadmin:changeme@192.168.1.245:5433/docker


