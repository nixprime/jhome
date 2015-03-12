let g:airline#themes#jcolor_dark#palette = {}

let s:N1 = [ '#000000' , '#e2dcce' , 16  , 253 , 'NONE' ]
let s:N2 = [ '#cee0e4' , '#3e3e3d' , 253 , 237 , 'NONE' ]
let s:N3 = [ '#97a9ad' , '#2e2e2e' , 248 , 236 , 'NONE' ]
let g:airline#themes#jcolor_dark#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#jcolor_dark#palette.normal_modified = {
      \ 'airline_c': [ '#97a9ad' , '#2e2e2e' , 248 , 236 , 'italic' ] ,
      \ }

let s:I1 = [ '#000000' , '#4ba5ff' , 16  , 75  , 'NONE' ]
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#jcolor_dark#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#jcolor_dark#palette.insert_modified = copy(g:airline#themes#jcolor_dark#palette.normal_modified)

let s:R1 = [ '#000000' , '#fe6850' , 16  , 203 , 'NONE' ]
let s:R2 = s:I2
let s:R3 = s:I3
let g:airline#themes#jcolor_dark#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#jcolor_dark#palette.replace_modified = copy(g:airline#themes#jcolor_dark#palette.insert_modified)

let s:V1 = [ '#000000' , '#bbb924' , 16  , 142 , 'NONE' ]
let s:V2 = s:N2
let s:V3 = s:N3
let g:airline#themes#jcolor_dark#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#jcolor_dark#palette.visual_modified = copy(g:airline#themes#jcolor_dark#palette.normal_modified)

let s:IA1 = [ '#cee0e4' , '#3e3e3d' , 253 , 237 , 'NONE' ]
let s:IA2 = [ '#97a9ad' , '#2e2e2e' , 248 , 236 , 'NONE' ]
let s:IA3 = [ '#405055' , '#1f201f' , 239 , 234 , 'NONE' ]
let g:airline#themes#jcolor_dark#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#jcolor_dark#palette.inactive_modified = copy(g:airline#themes#jcolor_dark#palette.normal_modified)

let g:airline#themes#jcolor_dark#palette.accents = {
      \ 'red': [ '#fe6850' , '' , 203 , '' ]
      \ }

