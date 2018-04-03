source $VIMRUNTIME/defaults.vim

" ==============================================================================
" Personal Customizations
" ==============================================================================
" Good defaults for all files
set hlsearch expandtab tabstop=4 shiftwidth=4 softtabstop=4 showtabline=2 ignorecase smartcase textwidth=140

" Keep an undo file (undo changes after closing)
if has('persistent_undo')
    set undofile
endif

" Easier to page up/down
map f <PageDown>
map b <PageUp>

" Go to file in a new tab
nmap gg <c-w>gf

" Cycle thru tabs using tab
nmap <S-tab> :tabprevious<cr>
nmap <tab> :tabnext<cr>

" Cycle thru errors
nmap e :lnext<CR>
nmap E :lfirst<CR>
set errorformat=%f:%l:%m

" Not sure if needed: nmap <C-o> <C-t>
" Open tag in a new tab
nmap <C-p> <C-w><C-]><C-w>T
set tags=~/workspace/.tags

" Add macro to insert pdb
let @d='oimport pdb; pdb.set_trace()'

" ------------------------------------------------------------------------------

" ==============================================================================
" Auto Commands
" ==============================================================================

" Show trailing whitepace and spaces before a tab
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
:autocmd Syntax * syn match ExtraWhitespace /\s\+\%#\@<!$/ containedin=ALL

augroup bash
  autocmd!
  autocmd FileType sh map r :w <bar> !bash %<CR>
  autocmd FileType sh setlocal sw=2 sts=2 ts=2
augroup END

autocmd FileType python map r :w <bar> !python3 %<CR>
autocmd FileType html setlocal ts=2 sw=2 sts=2
autocmd FileType tf setlocal ts=2 sw=2 sts=2
autocmd FileType yaml setlocal ts=2 sw=2 sts=2
autocmd FileType crontab setlocal nobackup nowritebackup
autocmd BufRead,BufNewFile .xonshrc setlocal filetype=python
autocmd BufRead,BufNewFile Vagrantfile setlocal filetype=ruby ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile Jenkinsfile setlocal filetype=groovy
" ------------------------------------------------------------------------------

" ==============================================================================
" Auto-completion
" ==============================================================================
set completeopt-=preview

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" ------------------------------------------------------------------------------

" ==============================================================================
" Code style check
" https://github.com/vim-syntastic/syntastic
" ==============================================================================
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers = ['python', 'flake8']
let g:syntastic_python_python_exec = 'python3'
" ------------------------------------------------------------------------------


" ==============================================================================
" Load Plugins
" https://github.com/junegunn/vim-plug
" ==============================================================================
call plug#begin('~/.vim/plugged')

" Code completion
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Code style check
Plug 'vim-syntastic/syntastic'

call plug#end()
" ------------------------------------------------------------------------------
