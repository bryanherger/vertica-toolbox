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
RUN pip install xgboost # more libraries not in the base install
# install custom build of vertica-python
RUN pip install --pre pytz python-dateutil
RUN cd /tmp && git clone https://github.com/bryanherger/vertica-python && cd vertica-python && python3 setup.py install
# uncomment when the patch is tested and accepted
# RUN pip install vertica-python
RUN pip install numpy pandas psycopg2-binary pyarrow sqlalchemy sqlalchemy-vertica-python ipython-sql vertica-sqlalchemy # packages for SQL Magic and SQLAlchemy
# add Vertica-ML-Python
RUN mkdir -p /home/jovyan/vertica-example
ADD example /home/jovyan/vertica-example/
ADD README.md /home/jovyan/
# RUN mkdir -p /home/jovyan/datasets
# ADD datasets /home/jovyan/datasets/
RUN mkdir -p /opt/conda/lib/python3.6/site-packages/vertica_ml_python
ADD vertica_ml_python /opt/conda/lib/python3.6/site-packages/vertica_ml_python/

#patch a sqlalchemy-vertica issue (yes, I KNOW I should submit a pull request)
COPY base.py /opt/conda/lib/python3.6/site-packages/sqlalchemy_vertica/base.py

# set "changeme" as Jupyter password (avoids having to collect the token)
# RUN jupyter notebook --generate-config
RUN echo c.NotebookApp.password = u\'sha1:033bf8c51e01:da1926b2dea2cd531e2e43d98b415970c4104894\' >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# setup Superset and client drivers
# prerequisites
USER root
RUN apt-get update -y && apt-get install -y build-essential libssl-dev libffi-dev python3-dev libsasl2-dev libldap2-dev
RUN apt-get install -y vim less postgresql-client redis-tools
# install odb and dependencies (unixODBC and drivers and security libs for Vertica)
RUN apt-get install -y unixodbc unixodbc-bin unixodbc-dev odbc-postgresql libssl1.0.0 libssl1.0-dev
# get Vertica client drivers
RUN cd / && wget --no-check-certificate https://www.vertica.com/client_drivers/9.1.x/9.1.1-0/vertica-client-9.1.1-0.x86_64.tar.gz && tar xzvf vertica*gz && rm vertica*gz
# copy odbcinst.ini
COPY odbcinst.ini /etc/odbcinst.ini
# install pyodbc
RUN pip install pyodbc
# add gosu and sample odbc.ini
RUN wget -O /usr/bin/gosu https://github.com/tianon/gosu/releases/download/1.1/gosu && chmod +sx /usr/bin/gosu
COPY odbc.ini /etc/odbc.ini
# install yarnpkg https://yarnpkg.com/en/docs/install#debian-stable
RUN apt-get install -y gnupg2
RUN cd /tmp && wget -O /tmp/yarn.key https://dl.yarnpkg.com/debian/pubkey.gpg && apt-key add /tmp/yarn.key && echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends yarn
# done with root stuff
USER $NB_UID
# install Superset and console-log dependency (probably should file a bug for that)
RUN pip install superset console-log
# assuming $SUPERSET_HOME as the root of the repo
#RUN pip install console-log
#RUN cd /home/jovyan && SUPERSET_HOME=/home/jovyan/incubator-superset && \
#git clone https://github.com/apache/incubator-superset.git && \
#cd $SUPERSET_HOME/superset/assets && \
#yarn && \
#yarn run build && \
#cd $SUPERSET_HOME && \
#python setup.py install
# RUN fabmanager create-admin --app superset
#RUN superset db upgrade
#RUN superset load_examples
#RUN superset init

#EXPOSE 8088
EXPOSE 8888

# this probably needs to be in the launch script
#RUN superset runserver -d
# (moved to quickstart.sh)
COPY quickstart.sh /home/jovyan/quickstart.sh
# install odb and dependencies (unixODBC and drivers)
COPY odb64luo /home/jovyan
COPY odbc_test.py /home/jovyan


