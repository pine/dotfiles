" ~/.config/nvim/completion.vim

" deoplete
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

" vim: se et ts=4 sw=4 sts=4 ft=vim :
