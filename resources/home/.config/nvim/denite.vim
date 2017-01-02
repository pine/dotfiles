" ~/.config/nvim/unite.vim

if executable('ag')
	" Change file_rec command.
	call denite#custom#var('file_rec', 'command',
		\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
	      \ [ '.git/', '.ropeproject/', '__pycache__/',
	      \   'venv/', '*.min.*', 'node_modules/'])

" ---------------------------------------------------------

" Define alias
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
  \ ['git', 'ls-files', '-co', '--exclude-standard'])

nnoremap [denite] <Nop>
nmap <Space>u [denite]
" nnoremap [denite]f :<C-u>Denite file_rec/git<CR>
nnoremap [denite]f :<C-u>Denite file_rec<CR>
nnoremap [denite]m :<C-u>Denite file_mru<CR>
nnoremap [denite]l :<C-u>Denite line<CR>
nnoremap [denite]a :<C-u>Denite grep<CR>

" vim: se et ts=2 sw=2 sts=2 ft=vim :
