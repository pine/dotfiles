" ~/.config/nvim/_common.vim

" ---------------------------------------------------------
" *** ファイル関係 ***
" ---------------------------------------------------------

set modeline    " モードライン有効
set modelines=5 " 前後 5 行

" ファイルタイプ関係の設定
syntax enable
filetype plugin indent on

" 文字コード関係の設定
set fileformats=unix,dos,mac " ファイルフォーマット
set termencoding=utf-8       " 端末のエンコード
set ambiwidth=double         " 全角文字を2文字として扱う

" 自動判定するエンコード一覧
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,latin1

" バッファ切り替え
set autowrite " 自動保存
set hidden    " 保存していないバッファの切り替えを有効


" ---------------------------------------------------------
" *** UI ***
" ---------------------------------------------------------

" 行番号を有効にする
set number

" カーソル位置の強調
set cursorline
set cursorcolumn

" モードライン
set laststatus=2 " ステータスラインを表示
set statusline=%<%f\ %m%r%{&ft==''?'':'['.GetFileType().']'}[%{GetFileEncoding()}][%{GetFileFormat()}]%=%lL,%c%VC%8P " ステータスラインのフォーマット

set showcmd   " コマンドを表示
set showmatch " 対応する括弧を表示

" カラースキーマ設定
colorscheme wombat256mod


" ---------------------------------------------------------
" *** 移動 ***
" ---------------------------------------------------------

" マウスを封じる
set mouse=h

" 左右の矢印キーでバッファを移動できるようにする
nnoremap <Left> <Esc>:bp<CR>
nnoremap <Right> <Esc>:bn<CR>

" カーソル移動を表示行で移動する
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k

" カレントウィンドウを移動
nnoremap tt <C-w>w

" 矢印キーで入力されないように変更
noremap ^[OA <up>
inoremap ^[OB <down>
inoremap ^[OC <right>
inoremap ^[OD <left>

" ctags
nnoremap <C-]> g<C-]>

" ---------------------------------------------------------
" *** インデント ***
" ---------------------------------------------------------

set autoindent " 自動インデント
set expandtab " タブを空白に展開
set tabstop=4 " タブを展開する幅
set softtabstop=4
set shiftwidth=4 " タブ幅

" 空行でインデントを維持
nnoremap o oX<C-h>
nnoremap O OX<C-h>
inoremap <CR> <CR>X<C-h>

" インデントをずらす
vnoremap <silent> > >gv
vnoremap <silent> < <gv


" ---------------------------------------------------------
" *** 削除・置換 ***
" ---------------------------------------------------------

" レジスタに入れずに一文字削除
nnoremap x "_x

" 単語を置換するコマンド
" カーソルの位置によらずに単語全体を変更
nnoremap ck lbcw
nnoremap dk lbdw

" Backspace キーを効くようにする
set backspace=indent,eol,start


" ---------------------------------------------------------
" *** 検索関係 ***
" ---------------------------------------------------------

set hlsearch " 検索語句をハイライト表示

" 検索語句のハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>


" ---------------------------------------------------------
" *** commentary ***
" ---------------------------------------------------------

nmap <C-k> <Plug>CommentaryLine
vmap <C-k> <Plug>Commentary


" ステータスラインを自動挿入
nnoremap <Leader>s :execute 'normal a'.GetStatusLine()<CR>


" vim: se et ts=4 sw=4 sts=4 ft=vim :
