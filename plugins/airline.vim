Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_powerline_fonts = 1

" Must define dictionary first if it does not exist,
" as indicated in `:he airline-customization`
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = ' |:'
let g:airline_symbols.linenr = ' ☰ :'
"let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.maxlinenr = ''

" Tabline settings
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#current_first = 1
let g:airline#extensions#tabline#ignore_bufadd_pat =
        \ '!|defx|gundo|nerd_tree|startify|tagbar|term://|undotree|vimfiler|\[No Name\]'
"let g:airline#extensions#tabline#tabs_label = fnamemodify(getcwd(), ':~')
let g:airline#extensions#tabline#show_close_button = 0

