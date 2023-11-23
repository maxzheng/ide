if exists('g:loaded_python')
  finish
endif
let g:loaded_python = 1

if !has("python3")
    echo "vim has to be compiled with +python3 to run this"
    finish
endif

py3 << CODE
import os
from pathlib import Path

import vim


def run():
    vim.command('write')
    if Path(vim.current.buffer.name).name.startswith('test_'):
        vim.command('!wst test -vv -n 0 {}'.format(vim.current.buffer.name))
    else:
        if os.environ.get('VIM_RUN_COMMAND'):
            vim.command('!{}'.format(os.environ['VIM_RUN_COMMAND']))
        else:
            vim.command('!python3 {}'.format(vim.current.buffer.name))

CODE

autocmd FileType python nmap r :py3 run()<CR>
