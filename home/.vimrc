"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialization
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
set bs=2

" Remove all existing autocommands
autocmd!

" tmux <C-left>, <C-right> compatibility
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" CamelCaseMotion: use capital W/B/E for CCM W/B/E
map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e
" see https://github.com/bkad/CamelCaseMotion/issues/10
nmap cW cE
nmap c2W c2E
nmap c3W c3E
nmap c4W c4E
nmap c5W c5E
nmap c6W c6E
nmap c7W c7E
nmap c8W c8E
nmap c9W c9E
" see https://github.com/bkad/CamelCaseMotion/issues/17
map iW <Plug>CamelCaseMotion_ie
map aW <Plug>CamelCaseMotion_iw

" Invoke .vimrc_plugins to load plugins
let vimrc_plugins = ''
if !empty($VIMRC_PLUGINS)
  let vimrc_plugins = $VIMRC_PLUGINS
elseif filereadable(expand('~/.vimrc_plugins'))
  let vimrc_plugins = '~/.vimrc_plugins'
elseif filereadable(expand('~/vimrc_plugins'))
  let vimrc_plugins = '~/vimrc_plugins'
endif
if !empty(vimrc_plugins)
  execute "source " . vimrc_plugins
endif

" CtrlP: use ag if available
if executable("ag")
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .hg
      \ --ignore .svn
      \ --ignore .DS_Store
      \ --ignore "**/*.o"
      \ --ignore "**/*.pyc"
      \ --ignore "**/*.so"
      \ -g ""'
endif

" CtrlP: no file limit
let g:ctrlp_max_files = 0

" Syntastic: run syntax checks on open
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic: enable error signs
let g:syntastic_enable_signs = 1

" UltiSnips: keybindings that don't conflict with YCM
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsListSnippets = "<C-e>"

" YouCompleteMe: don't confirm .ycm_extra_conf.py files
let g:ycm_confirm_extra_conf = 0

" YouCompleteMe: disable YCM diagnostics in the sign column
let g:ycm_enable_diagnostic_signs = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Colors
syntax on
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

" Show leading whitespace
set lcs=tab:┊\  list

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editor behavior
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Text encoding and line endings
set encoding=utf-8
set ffs=unix,dos

" Careful file overwriting
set writebackup

" Shorten delay after ESC
set timeout timeoutlen=500

" Backspace through everything in insert mode
set backspace=indent,eol,start

" Incremental search
set incsearch

" Search/replace applies to all occurrences on the line by default
set gdefault

" Columns and line wrapping
set wrap linebreak textwidth=0 wrapmargin=0
set colorcolumn=80

" Render hard tabs as 8 spaces ...
set tabstop=8
" ... but use 2 spaces for indentation
set softtabstop=2 shiftwidth=2 expandtab smarttab

" No overly clever indentation by default
set nocindent autoindent nosmartindent

" Support for filetype-specific stuff
filetype plugin indent on
set omnifunc=syntaxcomplete#Complete

" Do not open preview window for completions
set completeopt=menuone

" Automatically close quickfix window if it is the last window
augroup quickfixclose
  au!
  au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

" One space after period
set nojoinspaces

if has("gui_running")
  " Hide scrollbars
  set guioptions-=r
  set guioptions-=L
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command-related settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show incomplete commands
set showcmd

" Longer command history
set history=1000

" Shell-like autocomplete
set wildmenu wildmode=list:longest

" Don't autocomplete certain file extensions
set wildignore+=*.swp,*.o,*.so

" Use ag instead of grep if available
if executable("ag")
  set grepprg=ag\ --nocolor\ --nogroup
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom commands and bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set the leader key to ',', but map space to it, so that the spacebar gets
" used in practice, but the ',' is visible.
let mapleader = ','
map <Space> ,

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

" <Leader>// pulls up grep; <Leader>/w greps the word under the cursor
command! -nargs=+ -complete=file -bar Grepcw silent! grep! <args>|cwindow|redraw!
nnoremap <Leader>// :Grepcw<Space>
nnoremap <Leader>/w :Grepcw <cword><CR>

" <Leader>.w goes to the definition of the identifier under the cursor, or to
" the declaration if the definition is unavailable
nnoremap <Leader>.w :YcmCompleter GoTo<CR>

" F2 uses 2 spaces for indentation
" F3 uses 8-space tabs for indentation
noremap <F2> :set tabstop=2 softtabstop=2 shiftwidth=2 expandtab<CR>
noremap <F3> :set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab<CR>

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

" F12 shows document stats (notably word count)
noremap <silent> <F12> g<C-g>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language-specific settings
" (that must be present before the syntax file is loaded)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wrap comments; continue comments after Enter; do not continue comments from o
" This must be in an autocmd to override ftplugin settings
" This isn't language-specific, but it clears the filetype autocmd group so it
" needs to precede all of the following
augroup filetype
  au!
  au FileType * setlocal formatoptions+=cr formatoptions-=o
augroup END

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
  au BufNewFile,BufRead *.glsl\|*.vert\|*.frag setlocal filetype=glsl
augroup END

" Golang
augroup filetype
  au BufRead,BufNewFile *.go setlocal filetype=go
augroup END

" JSON
augroup filetype
  au BufRead,BufNewFile *.json setlocal filetype=javascript
augroup END

" LLVM
augroup filetype
  au BufRead,BufNewFile *.ll setlocal filetype=llvm
augroup END

" Markdown
augroup filetype
  au BufRead,BufNewFile *.md setlocal filetype=markdown
augroup END

" Protobuf
augroup filetype
  au BufRead,BufNewFile *.proto setlocal filetype=proto
augroup END

" Rust
augroup filetype
  au BufRead,BufNewFile *.rs setlocal filetype=rust
augroup END

" SCons
augroup filetype
  au BufRead,BufNewFile SCons* setlocal filetype=python
augroup END

" TeX (LaTeX)
let g:tex_flavor = "latex"

" Plain text
au BufRead,BufNewFile *.txt setlocal spell spelllang=en_us

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let vimrc_local = ''
if !empty($VIMRC_LOCAL)
  let vimrc_local = $VIMRC_LOCAL
elseif filereadable(expand('~/.vimrc_local'))
  let vimrc_local = '~/.vimrc_local'
elseif filereadable(expand('~/vimrc_local'))
  let vimrc_local = '~/vimrc_local'
endif
if !empty(vimrc_local)
  execute "source " . vimrc_local
endif

