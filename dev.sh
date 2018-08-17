#!/bin/bash
sudo docker create -u root --name vsqltoolbox -it -p 8088:8088 -p 8888:8888 -v $HOME/notebook:/home/jovyan/work -v /home/bryan/opt/vertica:/opt/vertica bryanherger/vertica-toolbox:latest bash
sudo docker cp /etc/odbc.ini vsqltoolbox:/etc/odbc.ini
sudo docker start -i vsqltoolbox
sudo docker container rm vsqltoolbox

