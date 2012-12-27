"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set bs=2

" Remove all existing autocommands
autocmd!

" Load plugins
call pathogen#infect()

" Allow use of local .vimrc/.exrc
set exrc secure

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Colors
syntax on
set t_Co=256 " Assume 256-color terminal
let g:CSApprox_attr_map = { "bold": "bold", "italic": "", "sp": "" }
colorscheme jcolor_dark

" Line numbers and ruler
set number ruler

" Highlight current line
set cursorline

" Highlight search results
set hlsearch

" Custom status line (always shown)
set statusline=%(%F\ %y%m%r%h%w%)%=%([%l/%L,\ %c%V]\ %P%)
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor behavior
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Text encoding and line endings
set encoding=utf-8
set ffs=unix,dos

" Careful file overwriting
set writebackup

" Backspace through everything in insert mode
set backspace=indent,eol,start

" Incremental search
set incsearch

" Search/replace applies to all occurrences on the line by default
set gdefault

" Columns and line wrapping
set wrap linebreak nolist textwidth=0 wrapmargin=0
set colorcolumn=80

" Tab settings
set tabstop=2 softtabstop=2 shiftwidth=2 smarttab
" Spaces instead of tabs
set expandtab

" No overly clever indentation by default
set nocindent autoindent nosmartindent

" Support for filetype-specific stuff
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

" One space after period
set nojoinspaces

" Use the + register (which aliases to the system clipboard) by default
set clipboard=unnamedplus

" Enable spellchecking
set spell spelllang=en_us

" Strip trailing whitespace on save
fun! <SID>StripTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
augroup autocleanup
  autocmd BufWritePre * :call <SID>StripTrailingWhitespace()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command-related settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show incomplete commands
set showcmd

" Longer command history
set history=1000

" Shell-like autocomplete
set wildmenu wildmode=list:longest

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
command! W w
command! Q q
command! Wq wq
command! WQ wq

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

" F9 infers indentation settings
:let g:detectindent_preferred_indent = 2
noremap <silent> <F9> :DetectIndent<CR>

" F12 prints document stats (notably word count)
noremap <silent> <F12> g<C-g>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings usually overriden by plugins (but see .vim/after/ftplugin/)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wrap comments; continue comments after Enter; do not continue comments from o
set formatoptions+=cr formatoptions-=o

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language-specific settings
" (that must be present before the syntax file is loaded)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" C/C++
" Higher minlines
let c_minlines=100
" Do not fold comments
let c_no_comment_fold=1
let c_no_if0_fold=1
" Do not highlight weird bracket nesting as an error (C++11 features)
let c_no_curly_error=1

" GLSL
augroup filetype
  au! BufNewFile,BufRead *.glsl\|*.vert\|*.frag setlocal filetype=glsl
augroup END

" Golang
augroup filetype
  au! BufRead,BufNewFile *.go setlocal filetype=go
augroup END

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

" SCons
augroup filetype
  au! BufRead,BufNewFile SCons* set filetype=python
augroup END

" Snippets
" Do not strip trailing whitespace on save
autocmd FileType snippet
  \ au! autocleanup

" TeX (LaTeX)
let g:tex_flavor = "latex"

" Plain text
autocmd BufRead,BufNewFile *.txt
  \ setlocal spell spelllang=en_us
  \ fo+=ta2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environment-specific settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" System header tags
set tags=./tags,../tags,../../tags,../../../tags,/opt/systags

