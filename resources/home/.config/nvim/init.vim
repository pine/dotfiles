" ~/.config/nvim/init.vim

if &compatible
  set nocompatible
endif


" Import external config
" -----------------------------------------------------------------------------

let $VIM_CONF_PATH = $HOME.'/.config/nvim'

source $VIM_CONF_PATH/plugins.vim
source $VIM_CONF_PATH/functions.vim
source $VIM_CONF_PATH/common.vim

source $VIM_CONF_PATH/completion.vim
source $VIM_CONF_PATH/cursor.vim
source $VIM_CONF_PATH/grep.vim

" vim: se et ts=2 sw=2 sts=2 ft=vim :
