" Turn off menu bar and toolbar
set guioptions-=m guioptions-=T

" Show the status line only when there are at least 2 windows, since otherwise
" the status line is redundant with the title bar
set laststatus=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand("~/.gvimrc_local"))
  source ~/.gvimrc_local
endif

if filereadable(expand("~/gvimrc_local"))
  source ~/gvimrc_local
endif
