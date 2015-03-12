set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
let colors_name = "jcolor_dark"

" background: #1f201f (cterm=234 #1c1c1c)
" background_highlight: #111111 (cterm=233 #121212)
" background_weak: #2e2e2e (cterm=236 #303030)
" background_veryweak: #3e3e3d (cterm=237 #3a3a3a)
" foreground: #cee0e4 (cterm=253 #dadada)
" foreground_deemph: #97a9ad (cterm=248 #a8a8a8)
" foreground_weak: #405055 (cterm=239 #4e4e4e)
" red: #fe6850 (cterm=203 #ff5f5f)
" orange: #e87b28 (cterm=166 #d75f00)
" yellow: #bbb924 (cterm=142 #afaf00)
" green: #49bc50 (cterm=77 #5fd75f)
" blue: #4ba5ff (cterm=75 #5fafff)
" purple: #dc82f6 (cterm=177 #d787ff)

hi Normal guibg=#1f201f guifg=#cee0e4 gui=NONE ctermbg=234 ctermfg=253 cterm=NONE

hi Comment guibg=NONE guifg=#97a9ad gui=NONE ctermbg=NONE ctermfg=248 cterm=NONE

hi Constant guibg=NONE guifg=#4ba5ff gui=NONE ctermbg=NONE ctermfg=75 cterm=NONE

hi Identifier guibg=NONE guifg=#cee0e4 gui=NONE ctermbg=NONE ctermfg=253 cterm=NONE

hi Statement guibg=NONE guifg=#49bc50 gui=NONE ctermbg=NONE ctermfg=77 cterm=NONE

hi PreProc guibg=NONE guifg=#dc82f6 gui=NONE ctermbg=NONE ctermfg=177 cterm=NONE

hi Type guibg=NONE guifg=#bbb924 gui=NONE ctermbg=NONE ctermfg=142 cterm=NONE

hi Special guibg=NONE guifg=#e87b28 gui=NONE ctermbg=NONE ctermfg=166 cterm=NONE

hi Underlined guibg=NONE guifg=NONE gui=underline ctermbg=NONE ctermfg=NONE cterm=underline

hi Ignore guibg=NONE guifg=NONE gui=NONE ctermbg=NONE ctermfg=NONE cterm=NONE

hi Error guibg=NONE guifg=#fe6850 gui=bold ctermbg=NONE ctermfg=203 cterm=bold

hi Todo guibg=NONE guifg=#97a9ad gui=bold ctermbg=NONE ctermfg=248 cterm=bold

hi StatusLine guibg=#e2dcce guifg=#000000 gui=NONE ctermbg=253 ctermfg=16 cterm=NONE
hi CursorLine guibg=#2e2e2e guifg=NONE gui=NONE ctermbg=236 ctermfg=NONE cterm=NONE
hi CursorColumn guibg=#2e2e2e guifg=NONE gui=NONE ctermbg=236 ctermfg=NONE cterm=NONE
hi Visual guibg=#3e3e3d guifg=NONE gui=NONE ctermbg=237 ctermfg=NONE cterm=NONE

hi LineNr guibg=#1f201f guifg=#97a9ad gui=NONE ctermbg=234 ctermfg=248 cterm=NONE
hi SignColumn guibg=#1f201f guifg=#97a9ad gui=NONE ctermbg=234 ctermfg=248 cterm=NONE
hi NonText guibg=NONE guifg=#97a9ad gui=NONE ctermbg=NONE ctermfg=248 cterm=NONE

hi ColorColumn guibg=#111111 guifg=NONE gui=NONE ctermbg=233 ctermfg=NONE cterm=NONE

hi MatchParen guibg=#3e3e3d guifg=NONE gui=NONE ctermbg=237 ctermfg=NONE cterm=NONE

hi Folded guibg=NONE guifg=NONE gui=italic ctermbg=NONE ctermfg=NONE cterm=italic
hi FoldColumn guibg=#1f201f guifg=#97a9ad gui=NONE ctermbg=234 ctermfg=248 cterm=NONE

hi SpellBad guibg=NONE guifg=NONE guisp=#fe6850 gui=undercurl ctermbg=NONE ctermfg=NONE cterm=underline
hi SpellCap guibg=NONE guifg=NONE guisp=#49bc50 gui=undercurl ctermbg=NONE ctermfg=NONE cterm=underline
hi SpellRare guibg=NONE guifg=NONE guisp=#bbb924 gui=undercurl ctermbg=NONE ctermfg=NONE cterm=underline
hi SpellLocal guibg=NONE guifg=NONE guisp=#dc82f6 gui=undercurl ctermbg=NONE ctermfg=NONE cterm=underline

hi Pmenu guibg=#111111 guifg=#97a9ad gui=NONE ctermbg=233 ctermfg=248 cterm=NONE
hi PmenuSel guibg=NONE guifg=NONE gui=underline ctermbg=NONE ctermfg=NONE gui=underline

hi SpecialKey guibg=NONE guifg=#405055 gui=NONE ctermbg=NONE ctermfg=239 cterm=NONE
hi Conceal guibg=NONE guifg=#405055 gui=NONE ctermbg=NONE ctermfg=239 cterm=NONE
