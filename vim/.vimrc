" Fix paste behavior
set paste
set pastetoggle=<F2>

" Or better - modern approach
if has('gui_running') || has('nvim') || &term =~ 'xterm'
    set clipboard=unnamedplus
endif

" Disable auto-indent when pasting
nnoremap <leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>

:set number
