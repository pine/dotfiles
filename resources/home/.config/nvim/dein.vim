" ~/.config/nvim/dein.vim

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

" Common
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/vimproc.vim')
call dein#add('editorconfig/editorconfig-vim')

" UI
call dein#add('tpope/vim-commentary')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('othree/eregex.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('vim-scripts/wombat256.vim')

" Syntax
call dein#add('vim-scripts/d.vim')
call dein#add('rhysd/vim-crystal')
call dein#add('keith/swift.vim')
call dein#add('rust-lang/rust.vim')
call dein#add('derekwyatt/vim-scala')
call dein#add('moznion/vim-cpanfile')
call dein#add('motemen/xslate-vim')
call dein#add('kchmck/vim-coffee-script')
call dein#add('JulesWang/css.vim')
call dein#add('isRuslan/vim-es6')
call dein#add('digitaltoad/vim-jade')
call dein#add('briancollins/vim-jst')
call dein#add('cakebaker/scss-syntax.vim')
call dein#add('leafgarland/typescript-vim')
call dein#add('groenewege/vim-less')
call dein#add('gkz/vim-ls')
call dein#add('dart-lang/dart-vim-plugin')
call dein#add('udalov/kotlin-vim')
call dein#add('vim-scripts/groovy.vim')
call dein#add('tfnico/vim-gradle')
call dein#add('elzr/vim-json')
call dein#add('cespare/vim-toml')
call dein#add('stephpy/vim-yaml')
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('gisphm/vim-gitignore')

call dein#end()

if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif
if dein#check_install()
  call dein#install()
endif

" vim: se et ts=4 sw=4 sts=4 ft=vim :
