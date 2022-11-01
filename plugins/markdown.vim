" Markdown improvements
"Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'mmai/vim-markdown-wiki'

" This is needed only if don't also have `pandoc` package installed.
"augroup pandoc_syntax
"    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
"augroup END

let g:pandoc#syntax#conceal#use=1
let g:pandoc#syntax#conceal#urls=1
let g:pandoc#syntax#style#emphases=1
let g:pandoc#syntax#style#underline_special=1

let g:pandoc#folding#level=2
let g:pandoc#folding#fdc=0
