" ~/.config/nvim/NERDTree.vim

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
let g:indent_guides_guide_size=1


" vim: se et ts=4 sw=4 sts=4 ft=vim :
