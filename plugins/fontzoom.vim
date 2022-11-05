let g:fontzoom_no_default_key_mappings=1

Plug 'thinca/vim-fontzoom'

silent! nmap <unique> <silent> <leader>z= <Plug>(fontzoom-larger)
silent! nmap <unique> <silent> <leader>z- <Plug>(fontzoom-smaller)
silent! nmap <unique> <silent> <C-ScrollWheelUp> <Plug>(fontzoom-larger)
silent! nmap <unique> <silent> <C-ScrollWheelDown> <Plug>(fontzoom-smaller)
