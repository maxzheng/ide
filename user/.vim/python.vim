if exists('g:loaded_python')
  finish
endif
let g:loaded_python = 1

if !has("python3")
    echo "vim has to be compiled with +python3 to run this"
    finish
endif

py3 << CODE
from pathlib import Path

import vim


def run():
    vim.command('write')
    if Path(vim.current.buffer.name).name.startswith('test_'):
        vim.command(f'!wst test -n 0 {vim.current.buffer.name}')
    else:
        vim.command(f'!python3 {vim.current.buffer.name}')

CODE

autocmd FileType python nmap r :py3 run()<CR>
