UsePlugin 'asyncomplete.vim'

" allow modifying the completeopt variable, or it will
" be overridden all the time
" おそらくこれを0にすることで勝手にインサートされることを防げる。
let g:asyncomplete_auto_completeopt = 0

" 自動で補完候補を表示する
let g:asyncomplete_auto_popup = 1

let g:asyncomplete_popup_delay = 200

" ポップアップが出ていた場合Enterが押されたときにポップアップを閉じる
" そうでない場合は改行を挿入する
inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

set completeopt=menuone,noinsert,noselect,preview
