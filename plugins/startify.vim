" fancy startup page
Plug 'mhinz/vim-startify'
let g:startify_lists = [
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
let g:startify_bookmarks = [ {'c': '~/.vim/vimrc'}, '~/.bashrc' ]
let g:startify_files_number = 8
let g:ascii = [
	\ ' _    ___         ',
	\ '| |  / (_)___ ___ ',
	\ '| | / / / __ `__ \',
	\ '| |/ / / / / / / /',
	\ '|___/_/_/ /_/ /_/ ',
	\ '                  '
    \]
let g:startify_custom_header =
      \ 'startify#pad(g:ascii + startify#fortune#quote())'
