#!/bin/bash
sudo docker create --name vsqltoolbox -it -p 8088:8088 -p 8888:8888 -v $HOME/notebook:/home/jovyan/work bryanherger/vertica-toolbox:latest bash
sudo docker start -i vsqltoolbox
sudo docker container rm vsqltoolbox

