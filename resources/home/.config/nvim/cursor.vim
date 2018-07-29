" ~/.config/nvim/plugins_easymotion.vim

" Cursor
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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


" EasyMotion
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:EasyMotion_do_mapping = 0

nmap <Leader>f <Plug>(easymotion-s)
nmap f <Plug>(easymotion-overwin-f2)

" vim: se et ts=2 sw=2 sts=2 ft=vim :
