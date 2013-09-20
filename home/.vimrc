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

" tmux <C-left>, <C-right> compatibility
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Colors
syntax on
" set t_Co=256 " Assume 256-color terminal
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

" F6 strips trailing whitespace
fun! StripTrailingWhitespace()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
noremap <silent> <F6> :call StripTrailingWhitespace()<CR>

" F7 enables auto-wrapping, F8 disables auto-wrapping
noremap <silent> <F7> :set fo+=a<CR>
noremap <silent> <F8> :set fo-=a<CR>

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
  au! BufRead,BufNewFile *.json setlocal filetype=javascript
augroup END

" LLVM
augroup filetype
  au! BufRead,BufNewFile *.ll setlocal filetype=llvm
augroup END

" Markdown
augroup filetype
  au! BufRead,BufNewFile *.md setlocal filetype=markdown
augroup END

" Protobuf
augroup filetype
  au! BufRead,BufNewFile *.proto setlocal filetype=proto
augroup END

" SCons
augroup filetype
  au! BufRead,BufNewFile SCons* setlocal filetype=python
augroup END

" TeX (LaTeX)
let g:tex_flavor = "latex"

" Plain text
autocmd BufRead,BufNewFile *.txt
  \ setlocal spell spelllang=en_us

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" DelimitMate: enable space and newline expansion
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" Syntastic: run syntax checks on open
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic: enable error signs
let g:syntastic_enable_signs = 1

" UltiSnips: rebind keys stolen by YCM
let g:UltiSnipsExpandTrigger = "<C-Tab>"
let g:UltiSnipsListSnippets = "<C-M-Tab>"
let g:UltiSnipsJumpForwardTrigger = "<C-Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<C-S-Tab>"

" YouCompleteMe: don't confirm .ycm_extra_conf.py files
let g:ycm_confirm_extra_conf = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif
