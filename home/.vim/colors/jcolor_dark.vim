set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "jcolor_dark"

" background: #1f201f
" background_highlight: #111111
" background_weak: #2e2e2e
" background_veryweak: #3e3e3d
" foreground: #cee0e4
" foreground_deemph: #97a9ad
" red: #fe6850
" orange: #e87b28
" yellow: #bbb924
" green: #49bc50
" blue: #4ba5ff
" purple: #dc82f6

hi Normal guibg=#1f201f guifg=#cee0e4 gui=NONE

hi Comment guibg=NONE guifg=#97a9ad gui=NONE

hi Constant guibg=NONE guifg=#4ba5ff gui=NONE

hi Identifier guibg=NONE guifg=#cee0e4 gui=NONE

hi Statement guibg=NONE guifg=#49bc50 gui=NONE

hi PreProc guibg=NONE guifg=#dc82f6 gui=NONE

hi Type guibg=NONE guifg=#bbb924 gui=NONE

hi Special guibg=NONE guifg=#e87b28 gui=NONE

hi Underlined guibg=NONE guifg=#cee0e4 gui=NONE

hi Ignore guibg=NONE guifg=NONE gui=NONE

hi Error guibg=NONE guifg=#fe6850 gui=Bold

hi Todo guibg=NONE guifg=#97a9ad gui=Bold

hi StatusLine guibg=#e2dcce guifg=#000000 gui=NONE
hi CursorLine guibg=#2e2e2e guifg=NONE gui=NONE
hi CursorColumn guibg=#2e2e2e guifg=NONE gui=NONE
hi Visual guibg=#3e3e3d guifg=NONE gui=NONE

hi LineNr guibg=#1f201f guifg=#97a9ad gui=NONE
hi SignColumn guibg=#1f201f guifg=#97a9ad gui=NONE
hi NonText guibg=NONE guifg=#97a9ad gui=NONE

hi ColorColumn guibg=#111111 guifg=NONE gui=NONE

hi MatchParen guibg=#3e3e3d guifg=NONE gui=NONE

hi Folded guibg=NONE guifg=NONE gui=Italic
hi FoldColumn guibg=#1f201f guifg=#97a9ad gui=NONE

hi SpellBad guibg=NONE guifg=NONE guisp=#fe6850 gui=Undercurl
hi SpellCap guibg=NONE guifg=NONE guisp=#49bc50 gui=Undercurl
hi SpellRare guibg=NONE guifg=NONE guisp=#bbb924 gui=Undercurl
hi SpellLocal guibg=NONE guifg=NONE guisp=#dc82f6 gui=Undercurl
