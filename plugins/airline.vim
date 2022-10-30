Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#ignore_bufadd_pat =
        \ '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler|\[No Name\]'

" Must define dictionary first if it does not exist,
" as indicated in `:he airline-customization`
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = ' |:'
let g:airline_symbols.linenr = ' ☰ :'
"let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.maxlinenr = ''
