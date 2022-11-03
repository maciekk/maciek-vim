Plug 'scrooloose/nerdcommenter'

" DISABLED: prefer 'netrw' instead
" see:
"   http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/
"Plug 'scrooloose/nerdtree'
"let g:NERDTreeWinPos = "right"

" Needs to come before 'vim-devicons'.
" DISABLED: too much info, messes up [ ] in the NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'

let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusConcealBrackets = 0

Plug 'ryanoasis/vim-devicons'
" Needs nerdtree-patched font to be set (in terminal, or set guifont=*)
" For fantasque, on MacOS, did:
"   $ brew tap homebrew/cask-fonts
"   $ brew install --cask font-fantasque-sans-mono-nerd-font
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ''  " default is 2 spaces?
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1

