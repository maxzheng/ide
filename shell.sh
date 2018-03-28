#!/usr/bin/env bash

docker exec -it ide bash -c "export COLUMNS=`tput cols`; export LINES=`tput lines`; exec bash"
