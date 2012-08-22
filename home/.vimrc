set nocompatible
set bs=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remove all existing autocommands
:autocmd!

" Load plugins
call pathogen#infect()

" Show incomplete commands
set showcmd

" Colors
syntax on
set t_Co=256 " Assume 256-color terminal
let g:CSApprox_attr_map = { "bold": "bold", "italic": "", "sp": "" }
colorscheme jcolor_dark

" Line numbers and ruler
set number ruler

" Text encoding and line endings
set encoding=utf-8
set ffs=unix,dos

" Tab settings
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
set cindent

" Columns and line wrapping
set wrap linebreak nolist textwidth=0 wrapmargin=0
set colorcolumn=80

" Backspace through everything in insert mode
set backspace=indent,eol,start

" Highlight current line
set cursorline

" Highlight search results
set hlsearch

" Search/replace applies to all occurrences on the line by default
set gdefault

" Custom status line (always shown)
set statusline=%(%F\ %y%m%r%h%w%)%=%([%l/%L,\ %c%V]\ %P%)
set laststatus=2

" Support for filetype-specific stuff
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

" No overly clever indentation by default
set nocindent autoindent nosmartindent

" One space after period
set nojoinspaces

" Folding
set foldmethod=syntax foldcolumn=4 foldnestmax=3

" Use the + register (which aliases to the system clipboard) by default
set clipboard=unnamedplus

" Strip trailing whitespace on save
fun! <SID>StripTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespace()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings usually overriden by plugins (but see .vim/after/ftplugin/)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wrap comments, but don't auto-continue comments otherwise
set formatoptions+=c formatoptions-=ro

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom commands and bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" jk move visually up and down on wrapped lines
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" Shift-up/down move the screen up/down
noremap <S-up> <C-Y>
noremap <S-down> <C-E>

" Allow certain capital commands
command W w
command Q q
command Wq wq
command WQ wq

" Y copies from cursor to EOL
noremap Y y$

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" When searching, keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

" Ctrl-a selects all text in current buffer
nnoremap <silent> <C-a> ggVG
vnoremap <silent> <C-a> ggVG

" Ctrl-jk moves the current line up or down
nnoremap <silent> <C-j> :m+<CR>
vnoremap <silent> <C-j> :m'>+<CR>gv
nnoremap <silent> <C-k> :m-2<CR>
vnoremap <silent> <C-k> :m-2<CR>gv

" F4 clears search highlight and recomputes syntax highlighting
noremap <silent> <F4> :let @/ = ""<CR>:syntax sync fromstart<CR>

" F7 enables auto-wrapping, F8 disables auto-wrapping
noremap <silent> <F7> :set fo+=a<CR>
noremap <silent> <F8> :set fo-=a<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" C#
autocmd FileType cs
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4

" Git - show diff in window split when committing
autocmd FileType gitcommit
  \ DiffGitCached | wincmd p

" Golang
augroup filetype
  au! BufRead,BufNewFile *.go set filetype=go
augroup END

" Haskell
autocmd FileType haskell
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4

" JSON
augroup filetype
  au! BufRead,BufNewFile *.json set filetype=javascript
augroup END

" LLVM
augroup filetype
  au! BufRead,BufNewFile *.ll set filetype=llvm
augroup END

" Protobuf
augroup filetype
  au! BufRead,BufNewFile *.proto set filetype=proto
augroup END

" Python
autocmd FileType python
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4

" SCons
augroup filetype
  au! BufRead,BufNewFile SCons* set filetype=python
augroup END

" LaTeX
let g:tex_flavor = "latex"
autocmd FileType tex
  \ setlocal spell spelllang=en_us
  \ fo+=t2

" Plain text
autocmd BufRead,BufNewFile *.txt
  \ setlocal spell spelllang=en_us
  \ fo+=ta2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environment-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" System header tags
set tags=./tags,../tags,../../tags,../../../tags,/opt/systags
