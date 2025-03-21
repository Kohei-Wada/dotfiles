UsePlugin 'vim-lsp'

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  " カーソルが関数の上にある時gdで定義にジャンプ
  nmap <buffer> gd <plug>(lsp-definition)

  " カーソルが関数の上にある時gkで定義をプレビュー
  nmap <buffer> gk <plug>(lsp-hover)

  " カーソルが関数の上にある時<leader>rでリネーム
  nmap <buffer> <leader>r <plug>(lsp-rename)

  " <leader>fでフォーマット
  nmap <buffer> <leader>f <plug>(lsp-document-format)

  " visualモードで選択した範囲をフォーマット
  xmap <buffer> <leader>f <plug>(lsp-document-range-format)

  " 補完候補が表示されているときのバインドを変更
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"

  nmap <buffer> gs <plug>(lsp-document-symbol-search)

  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)

  "ポップアップ内でスクロールするための設定
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')


" エラーや警告などの診断情報を表示する
let g:lsp_diagnostics_enabled = 1

" カーソル位置の診断情報をエコー領域に表示する
let g:lsp_diagnostics_echo_cursor = 1

" カーソル位置の診断情報をサイン列に表示する
let g:lsp_hightlight_diagnostics_under_cursor = 0

" 診断情報に基づいてテキストのハイライトを行うかどうかを設定
let g:lsp_hilights_enabled = 1

" 診断メッセージを実際のテキストの横に表示するかどうかを設定
let g:lsp_diagnostics_virtual_text_enabled = 0

let g:lsp_text_edit_enabled = 1
