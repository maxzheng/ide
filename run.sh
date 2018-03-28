#!/usr/bin/env bash

# 2nd home in Docker
H2=/home/mzheng
NAME=ide

# Remove existing
docker stop ide &> /dev/null
docker kill ide &> /dev/null
docker rm ide &> /dev/null
docker inspect ide &> /dev/null && echo 'Weird, container "ide" is still running after kill' && exit 1

docker run -d -p 2222:22 --rm --name $NAME \
    -v ~/workspace:$H2/workspace \
    -v ~/notes:$H2/notes \
    -v ~/.aws:$H2/.aws \
    -v ~/.config:$H2/.config \
    -v ~/.ccloud:$H2/.ccloud \
    -v ~/.gnupg:$H2/.gnupg \
    -v ~/.kioskconfig:$H2/.kioskconfig \
    -v ~/.pip:$H2/.pip \
    -v ~/.pypirc:$H2/.pypirc \
    -v ~/.ssh:$H2/.ssh \
    -v ~/.xonshrc:$H2/.xonshrc \
    maxzheng/ide

echo Running using container name \"$NAME\"
