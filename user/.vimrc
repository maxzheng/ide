set nocompatible

set shell=/bin/bash

filetype plugin indent on
syntax on

set backspace=2
set smartindent hlsearch tabstop=4 shiftwidth=4 expandtab softtabstop=4 showtabline=2 ignorecase smartcase
set tw=140

set tags=~/workspace/.tags

set makeprg=python-syntax-check\ %
set errorformat=%f:%l:%m

map f <PageDown>
map b <PageUp>

nmap c :w <bar> make<CR>

nmap e :lnext<CR>
nmap E :lfirst<CR>

nmap <C-o> <C-t>
nmap <C-p> <C-w><C-]><C-w>T

nmap <S-tab> :tabprevious<cr>
nmap <tab> :tabnext<cr>

nmap gg <c-w>gf

autocmd filetype crontab setlocal nobackup nowritebackup

" Copied from http://tools.corp.linkedin.com/docs/python/misc/editors.html#python-editors
" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
:autocmd Syntax * syn match ExtraWhitespace /\s\+\%#\@<!$/ containedin=ALL


au BufNewFile,BufRead .xonshrc set filetype=python
augroup python
  autocmd!

  autocmd FileType python map r :w <bar> !python3 %<CR>
  "autocmd FileType python set cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python setlocal shiftwidth=4 softtabstop=4 "smarttab

  let python_space_errors = 1
  setlocal nospell
augroup END

augroup bash
  autocmd FileType sh map r :w <bar> !bash %<CR>
  autocmd FileType sh setlocal shiftwidth=2 softtabstop=2 tabstop=2 shiftwidth=2
augroup END

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

execute pathogen#infect()

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 1

let g:syntastic_python_checkers = ['python', 'flake8']

set completeopt-=preview

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"

endfunction

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

autocmd BufRead Vagrantfile setlocal ts=2 sw=2 sts=2
au FileType html setlocal ts=2 sw=2 sts=2
au FileType tf setlocal ts=2 sw=2 sts=2
au FileType yaml setlocal ts=2 sw=2 sts=2

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

augroup jenkin
  au!
  au BufRead,BufNewFile Jenkinsfile set filetype=groovy
augroup END

let g:syntastic_python_python_exec = 'python3'
let @d='oimport pdb; pdb.set_rkbtrace()'
