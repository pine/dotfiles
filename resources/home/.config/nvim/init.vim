" ~/.config/nvim/init.vim

" ---------------------------------------------------------
" *** 一般設定 ***
" ---------------------------------------------------------

if &compatible
  set nocompatible
endif


" ---------------------------------------------------------
" *** 変数定義 ***
" ---------------------------------------------------------

let $VIM_CONF_PATH = $HOME . '/.config/nvim'


" ---------------------------------------------------------
" *** 外部ファイル ***
" ---------------------------------------------------------

source $VIM_CONF_PATH/dein.vim

source $VIM_CONF_PATH/_function.vim
source $VIM_CONF_PATH/_common.vim

source $VIM_CONF_PATH/denite.vim
" source $VIM_CONF_PATH/deoplete.vim
source $VIM_CONF_PATH/NERDTree.vim


" vim: se et ts=4 sw=4 sts=4 ft=vim :
