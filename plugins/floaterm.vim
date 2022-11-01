Plug 'voldikss/vim-floaterm'

let g:floaterm_keymap_new = '<Leader>tn'
let g:floaterm_keymap_toggle = '<Leader>tt'
let g:floaterm_keymap_kill = '<Leader>tk'

nnoremap   <silent>   <leader>tn    :FloatermNew<CR>
tnoremap   <silent>   <leader>tn    <C-\><C-n>:FloatermNew<CR>
nnoremap   <silent>   <leader>tt   :FloatermToggle<CR>
tnoremap   <silent>   <leader>tt   <C-\><C-n>:FloatermToggle<CR>
