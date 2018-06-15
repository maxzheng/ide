#!/usr/bin/env bash

set -x

docker cp ide:/home/$USER/.bashrc user/.bashrc
docker cp ide:/home/$USER/.vimrc user/.vimrc
docker cp ide:/home/$USER/.vim/python.vim user/.vim/python.vim

git diff
