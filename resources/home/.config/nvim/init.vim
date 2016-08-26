" ~/.config/nvim/init.vim

" ---------------------------------------------------------
" *** 一般設定 ***
" ---------------------------------------------------------

if &compatible
  set nocompatible
endif

set modeline    " モードライン有効
set modelines=5 " 前後 5 行


" ---------------------------------------------------------
" *** dein ***
" ---------------------------------------------------------

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml = '~/.dein.toml'
  let s:lazy_toml = '~/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  " call dein#save_state()
endif

if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif
if dein#check_install()
  call dein#install()
endif



" ---------------------------------------------------------
" *** ファイル関係 ***
" ---------------------------------------------------------

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
" *** deoplete ***
" ---------------------------------------------------------

let g:deoplete#sources = {}

" Use deoplete.
let g:deoplete#enable_at_startup=1

" Use smartcase.
let g:deoplete#enable_at_smart_case=1

" Set minimum syntax keyword length.
let g:deoplete#min_pattern_length=3

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? deoplete#close_popup() : "\<CR>"
endfunction

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h>  deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>   deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  deoplete#close_popup()
inoremap <expr><C-e>  deoplete#cancel_popup()

" For cursor moving in insert mode(Not recommended)
inoremap <expr><Left>  deoplete#close_popup() . "\<Left>"
inoremap <expr><Right> deoplete#close_popup() . "\<Right>"


" ---------------------------------------------------------
" *** NERDTree ***
" ---------------------------------------------------------

nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:NERDTreeIgnore=['\.clean$', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=0
let g:NERDTreeQuitOnOpen=0

let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=238
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=249
let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_guide_size=1


" ---------------------------------------------------------
" *** commentary ***
" ---------------------------------------------------------

nmap <C-k> <Plug>CommentaryLine
vmap <C-k> <Plug>Commentary


" ---------------------------------------------------------
" *** 関数定義 ***
" ---------------------------------------------------------

" ファイルタイプを返す
function! GetFileType()
    " Alphabet order
    let l:name = {
                \'c'         : 'C',
                \'coffee'    : 'CoffeeScript',
                \'cpp'       : 'C++',
                \'cpanfile'  : 'Perl',
                \'crystal'   : 'Crystal',
                \'css'       : 'CSS',
                \'elixir'    : 'Elixir',
                \'java'      : 'Java',
                \'javascript': 'JavaScript',
                \'json'      : 'JSON',
                \'kotlin'    : 'Kotlin',
                \'less'      : 'LESS',
                \'markdown'  : 'Markdown',
                \'perl'      : 'Perl',
                \'php'       : 'PHP',
                \'python'    : 'Python',
                \'ruby'      : 'Ruby',
                \'sql'       : 'SQL',
                \'swift'     : 'Swift',
                \'tex'       : 'TeX',
                \'text'      : 'Text',
                \'vim'       : 'Vim',
                \'xslate'    : 'Xslate',
                \}

    retu get(l:name, &ft, &ft)
endfunction

" 文字コードを返す
function! GetFileEncoding()
    let l:fenc = &fenc


    " fenc が設定されていない場合 enc を使用する
    if l:fenc == ''
        let l:fenc = &enc
    endif

    if l:fenc == 'cp932'
        return 'S'
    elseif l:fenc == 'iso-2022-jp'
        return 'J'
    elseif l:fenc == 'euc-jp'
        return 'E'
    elseif l:fenc == 'utf-8'
        return 'U'
    else
        return l:fenc
    endif
endfunction

" 改行コードを返す
function! GetFileFormat()
    if &ff == 'unix'
        return 'U'
    elseif &ff == 'dos'
        return 'D'
    else
        return 'M'
    endif
endfunction

" ステータスラインを生成する
function! GetStatusLine()
    let l:line = 'vim: se'

    if &et
        let l:line .= ' et'
    else
        let l:line .= ' noet'
    endif

    let l:line .= ' ts='.&ts
    let l:line .= ' sw='.&sw
    let l:line .= ' sts='.&sts

    if &ft != ''
        let l:line .= ' ft='.&ft
    endif

    let l:line .= ' :'

    return l:line
endfunction

" ステータスラインを自動挿入
nnoremap <Leader>s :execute 'normal a'.GetStatusLine()<CR>

" vim: se et ts=4 sw=4 sts=4 ft=vim :
