#!/usr/bin/env bash

set -x

docker cp ide:/home/$USER/.bashrc user/.bashrc
docker cp ide:/home/$USER/.inputrc user/.inputrc
docker cp ide:/home/$USER/.gitignore user/.gitignore
docker cp ide:/home/$USER/.vimrc user/.vimrc
docker cp ide:/home/$USER/.vim/python.vim user/.vim/python.vim
docker cp ide:/home/$USER/bin/ user/

(set +x
# Strip out last few lines added by Dockerfile
lines=`cat user/.bashrc | wc -l`
let lines=lines-5
head -n $lines user/.bashrc > /tmp/.bashrc
mv /tmp/.bashrc user/.bashrc
) 2> /dev/null

git diff
