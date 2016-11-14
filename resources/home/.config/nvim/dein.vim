" ~/.config/nvim/dein.vim

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

" vim: se et ts=4 sw=4 sts=4 ft=vim :
