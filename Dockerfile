# extended from https://github.com/jupyter/docker-stacks/datascience-notebook
FROM jupyter/datascience-notebook

LABEL maintainer="Bryan Herger <bherger@users.sf.net>"

USER $NB_UID

# setup Jupyter and related Python packages
RUN pip install --upgrade setuptools pip
RUN pip install plotly # Plotly graphing library
RUN pip install dash # The core dash backend
RUN pip install dash-renderer # The dash front-end
RUN pip install dash-html-components # HTML components
RUN pip install dash-core-components # Supercharged components
RUN pip install vertica-python numpy pandas psycopg2-binary pyarrow sqlalchemy sqlalchemy-vertica-python # packages for SQLAlchemy
# add Vertica-ML-Python
RUN mkdir -p /home/jovyan/vertica-example
ADD example /home/jovyan/vertica-example/
ADD README.md /home/jovyan/
# RUN mkdir -p /home/jovyan/datasets
# ADD datasets /home/jovyan/datasets/
RUN mkdir -p /opt/conda/lib/python3.6/site-packages/vertica_ml_python
ADD vertica_ml_python /opt/conda/lib/python3.6/site-packages/vertica_ml_python/

# set "changeme" as Jupyter password (avoids having to collect the token)
# RUN jupyter notebook --generate-config
RUN echo c.NotebookApp.password = u\'sha1:5f0645e79ad1:0cb5b7f88fd7fda0ed96691c1336d0d13b2852a4\' >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# setup Superset and client drivers
# prerequisites
USER root
RUN apt-get update -y && apt-get install -y build-essential libssl-dev libffi-dev python3-dev libsasl2-dev libldap2-dev
RUN apt-get install -y vim less postgresql-client redis-tools
# install odb and dependencies (unixODBC and drivers and security libs for Vertica)
RUN apt-get install -y unixodbc unixodbc-bin unixodbc-dev odbc-postgresql libssl1.0.0 libssl1.0-dev
# get Vertica client drivers
RUN cd / && wget https://my.vertica.com/client_drivers/9.1.x/9.1.1-0/vertica-client-9.1.1-0.x86_64.tar.gz && tar xzvf vertica-client-9.1.1-0.x86_64.tar.gz && rm vertica*gz
# copy odbcinst.ini
COPY odbcinst.ini /etc/odbcinst.ini
# install pyodbc
RUN pip install pyodbc
# done with root stuff
USER $NB_UID
# install
RUN pip install superset
# RUN fabmanager create-admin --app superset
RUN superset db upgrade
RUN superset load_examples
RUN superset init

# export Jupyter and Superset listening ports
EXPOSE 8088
EXPOSE 8888

# this probably needs to be in the launch script
#RUN superset runserver -d
# (moved to quickstart.sh)
COPY quickstart.sh /home/jovyan/quickstart.sh
# install odb and dependencies (unixODBC and drivers)
COPY odb64luo /home/jovyan
COPY odbc_test.py /home/jovyan


