" additional "verbs" & "nouns"
" based on 'Mastering the Vim Language' talk
"     https://www.youtube.com/watch?v=wlR5gYd6um0

" verbs {{{1
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'inkarkat/vim-ReplaceWithRegister'
Plugin 'christoomey/vim-titlecase'
Plugin 'christoomey/vim-sort-motion'
Plugin 'christoomey/vim-system-copy'

" nouns {{{1
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'kana/vim-textobj-user'  " needed by the textobj-line & textobj-entire
Plugin 'kana/vim-textobj-line'
Plugin 'kana/vim-textobj-entire'

" misc {{{1
Plugin 'tpope/vim-repeat'

" tweaks {{{1

" Markdown tweak
"   src: https://github.com/tpope/vim-surround/issues/15
let g:surround_{char2nr('*')} = "**\r**"

" vim:fdm=marker
