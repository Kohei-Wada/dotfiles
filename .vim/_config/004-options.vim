"vimが自動でファイルタイプを判定、$VIMRUNTIMEからプラグインを読み込むように設定する。
filetype plugin indent on

"起動時にメッセージを表示しない
set shortmess+=I

set fileencodings=utf-8,cp932

"タブの表示幅を4に設定
set tabstop=4

"タブを4つ分のスペースに変換する
set shiftwidth=4

"タブをスペースに変換
set expandtab

if v:version >= 900
    set backspace=indent,eol,start,nostop
endif

set encoding=utf-8

" コメントアウトされた行で改行改行した際に、更に自動でコメントアウトされるのを無効化する。
" 上のfiletype onにすることで、バッファを開いた際に`FileType`イベントが発生する。
" その際に、対応する言語ファイルが読み込まれると思われる。(/usr/share/vim/vim90/filetype.vim　など)
" その中で、`setlocal formatoptions-=cro`が実行されているため、改行での自動コメントアウトが無効化されている。
" 以下のコードはそれを上書きするためのもの。
augroup my_formatting
    autocmd!
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

set relativenumber
set nobackup
set nowb
set noswapfile
