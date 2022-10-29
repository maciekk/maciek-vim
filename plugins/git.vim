" Git - use :G
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

let g:gitgutter_set_sign_backgrounds = 1
" vim-gitgutter used to do this by default:
highlight! link SignColumn LineNr

" turn off for now, until I figure out the background coloring
let g:gitgutter_enabled = 0

