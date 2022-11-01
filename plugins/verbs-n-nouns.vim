" additional "verbs" & "nouns"
" based on 'Mastering the Vim Language' talk
"     https://www.youtube.com/watch?v=wlR5gYd6um0

" VERBS {{{1
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'inkarkat/vim-ReplaceWithRegister'
Plug 'christoomey/vim-titlecase'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-system-copy'

" NOUNS {{{1
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'  " needed by the textobj-line & textobj-entire
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'

" MISC {{{1
Plug 'tpope/vim-repeat'

" TWEAKS {{{1

" Markdown tweak
"   src: https://github.com/tpope/vim-surround/issues/15
let g:surround_{char2nr('*')} = "**\r**"

" vim:fdm=marker:nofen
