UsePlugin 'ctrlp.vim'

" ctrlpから出るとき，ステータスラインの表示をoffにする
function! CtrlPEnter()
    set laststatus=0
endfunction

" ctrlpから出るとき，ステータスラインの表示をonにする
function! CtrlPLeave()
    set laststatus=2
endfunction

" ctrlpバッファに入る時と出るときに使用する関数を定義します。
let g:ctrlp_buffer_func = {
    \ 'enter': 'CtrlPEnter',
    \ 'exit': 'CtrlPLeave',
\ }

" 検索の際に200[ms]のウェイトを入れる（１文字入力の度に検索結果がコロコロ変わるのが気に入らないため
let g:ctrlp_lazy_update = 200

" 検索結果の表示ウィンドウの設定，10件分を表示（それ以上になってもスクロールされる）
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:50'

" 隠しファイルを表示
let g:ctrlp_show_hidden = 1

" .gitignoreに記述されているファイルを検索対象から除外
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" 検索してほしくないファイルやディレクトリを除外
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|o)$',
    \ 'link': 'some_bad_symbolic_links'
    \ }
