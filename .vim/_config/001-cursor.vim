"cursorの左右移動で行末から次の行頭への移動が可能
set whichwrap=b,s,h,l,<,>,[,],~ 

let &t_ti .= "\e[1 q"
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"
let &t_te .= "\e[0 q"
