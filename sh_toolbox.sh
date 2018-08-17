#!/bin/bash
sudo docker run -it --rm -p 8088:8088 -p 8888:8888 -v $HOME/notebook:/home/jovyan/work bryanherger/vertica-toolbox bash

