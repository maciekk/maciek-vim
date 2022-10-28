" Maciej's Vim setup
"
" Version controlled here:
"   https://github.com/maciekk/vimrc

" Vundle setup {{{1
set nocompatible               " be iMproved

" Ultimately want "filetype off" for Vundle here, but this on-then-off hack is
" to fix an annoying issue:
"   http://tooky.co.uk/2010/04/08/there-was-a-problem-with-the-editor-vi-git-on-mac-os-x.html
filetype on
filetype off                   " required!

if has ('win32')
    let $MYVIMDIR="~/vimfiles"
    let vundlepath='~/vimfiles/bundle'
else
    let $MYVIMDIR="~/.vim"
    let vundlepath='~/.vim/bundle'
endif
set runtimepath+=$MYVIMDIR

let &runtimepath.=','.$MYVIMDIR.'/bundle/Vundle.vim'
call vundle#begin(vundlepath)

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" bundles {{{1
"
" Main bindings to remember/use:
" - \be : BufferExplorer
" - <C-p> : CtrlP
" - \mt | \mf : Tabman
" - :Note : note taking
"Plugin 'bufexplorer.zip'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
" needs nerdtree-patched font to be set (in terminal, or set guifont=*)
" For fantasque, on MacOS, did:
"   $ brew tap homebrew/cask-fonts
"   $ brew install --cask font-fantasque-sans-mono-nerd-font
Plugin 'ryanoasis/vim-devicons'  " requires nerdtree fonts

"Plugin 'chrisbra/NrrwRgn'

" undo trees
"Plugin 'sjl/gundo.vim'   " obsolete
"Plugin 'simnalamburt/vim-mundo'   " gundo fork++; requires Python
Plugin 'mbbill/undotree'

" Powerline & similar
"Plugin 'Lokaltog/vim-powerline'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" matchit - use the one that comes with Vim; switch to external if want recent
packadd! matchit
"Plugin 'matchit.zip'

" rainbow parentheses, various choices
"Plugin 'kien/rainbow_parentheses.vim'
Plugin 'frazrepo/vim-rainbow'

" snippets
"Plugin 'SirVer/ultisnips'
"Plugin 'acustodioo/vim-snippets'

" HTML
Plugin 'mattn/emmet-vim'

" Git - use :G
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" a utility library for other scripts
"Plugin 'L9'

" Outliners
"Plugin 'insanum/votl'
"Plugin 'VimOutliner'
"Plugin 'TVO--The-Vim-Outliner'
"Plugin 'vim-scripts/VOoM'

" Wiki & tools
Plugin 'vimwiki'
"Plugin 'utl.vim'

" Go support
"Plugin 'fatih/vim-go'

" learn more about these
"Plugin 'FuzzyFinder'
"Plugin 'thinca/vim-fontzoom'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-notes'

" suggested by YouCompleteMe (corp)
"Plugin 'scrooloose/syntastic'

" Markdown improvements
"Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'mmai/vim-markdown-wiki'

" to try
"Plugin 'xolox/vim-session'
"Plugin 'techlivezheng/vim-plugin-minibufexpl'
"Plugin 'taglist.vim'  " superseded by 'tagbar'?

" Org mode in Vim
"https://github.com/hsitz/VimOrganizer
"Plugin 'jceb/vim-orgmode'

" no longer used
"Plugin 'freitass/todo.txt-vim'
"Plugin 'majutsushi/tagbar'
"Plugin 'kien/tabman.vim'

" color schemes -- good source: http://vimcolorschemes.com
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'sainnhe/everforest'
Plugin 'morhetz/gruvbox'
Plugin 'dracula/vim'
Plugin 'lifepillar/vim-solarized8'
Plugin 'altercation/vim-colors-solarized'
Plugin 'endel/vim-github-colorscheme'
Plugin 'nelstrom/vim-mac-classic-theme'
Plugin 'yuttie/inkstained-vim'
Plugin 'romgrk/github-light.vim'
Plugin 'noah/vim256-color'
"Plugin 'flazz/vim-colorschemes'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" or
" filetype plugin on          " to not use the indentation settings set by plugins

" settings {{{1
set backspace=indent,eol,start
set cmdheight=1
set diffopt+=vertical
set directory=~/tmp,/var/tmp/,/tmp,.
set encoding=utf-8
set expandtab
set foldlevelstart=0
set hidden
set history=999
set laststatus=2
set list
set listchars=tab:»·,trail:·,extends:»,precedes:«
set matchpairs+=<:>
set modeline
set number
set ruler
set scrolloff=1
set shiftwidth=4
set shortmess+=I
set showcmd
set showmatch
set showmode
set splitbelow
set splitright
set viminfo='100,<50,s10,h,%
set wildmenu
set wildmode=list:longest,full
set wildoptions=fuzzy,pum

" This is at least where the words are on OS X.
set dictionary=/usr/share/dict/words

" search settings {{{2
set ignorecase
set infercase
set smartcase
set nowrapscan
set hlsearch
set incsearch
" hit C-l to run :noh AND redraw screen (h/t "Pratical Vim")
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" soft breaks {{{2
set textwidth=78
set formatoptions=tcq2n
set autoindent

set nowrap
" uncomment for wrapping; might need to turn off 'list'
"set wrap
"set wrapmargin=2
"set showbreak=â¦
"set linebreak

" backup {{{2
set backup
set backupcopy=yes
set backupdir=~/bak,~/tmp,.,/tmp

" mappings {{{1
command! W :w  " in case we didn't let go of Shift fast enough
map <C-s> :w<CR>
imap <C-s> <C-o>:w<CR>

" Swap keys for filtered/unfiltered history scroll.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

map ,fb :FufBuffer<CR>
map ,fd :FufDir<CR>
map ,ff :FufFile<CR>

" Mapping to repeat last search using global command, and bring up quickfix.
" Purloined from:
"   http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/
nmap g/ :vimgrep /<C-R>//j %<CR>\|:cw<CR>

" package setup {{{1
" Rainbow Parentheses {{{2
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0

"" TODO: Temporary
"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

" rainbow improved {{{2
"
"au FileType c,cpp,objc,objcpp call rainbow#load()
"let g:rainbow_active = 1
"
" or just use :RainbowToggle to turn it on

" Vimwiki {{{2
" NOTE: set / override g:vimwiki_list in local.vim
let g:vimwiki_list = [{'path': '~/Google Drive/vim/wiki/'}]
let g:vimwiki_folding = 'expr'

" Powerline {{{2
let g:Powerline_symbols = 'compatible'

" airline {{{2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Must define dictionary first if it does not exist,
" as indicated in `:he airline-customization`
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = ' |:'
let g:airline_symbols.linenr = ' ☰ :'
"let g:airline_symbols.maxlinenr = '☰ '
let g:airline_symbols.maxlinenr = ''

" CtrlP {{{2
let g:ctrlp_cmd = 'CtrlPBuffer'

" Notes {{{2
:let g:notes_directories = ['~/Google Drive/Notes']

" NarrowRegion {{{2
let g:nrrw_rgn_rel_min = 10
let g:nrrw_rgn_rel_max = 80
let g:nrrw_rgn_incr = 99

" pandoc {{{2
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

" misc {{{2
let g:gitgutter_set_sign_backgrounds = 1
" vim-gitgutter used to do this by default:
highlight! link SignColumn LineNr

" turn off for now, until I figure out the background coloring
let g:gitgutter_enabled = 0

" local configs {{{1
if has('win32') || has('win64') || has('win16')
    let local_settings = $HOME . 'vimfiles/LOCAL/local.vim'
else
    let local_settings = $HOME . '/.vim/LOCAL/local.vim'
endif

if filereadable(local_settings)
    exec ':source ' . local_settings
endif

" cosmetics {{{1
colorscheme BusyBee
"colorscheme molokai
"colorscheme fine_blue
"colorscheme pyte
syntax enable

" misc {{{1

source $MYVIMDIR/abbreviations.vim

" TODO: is this needed?
"runtime macros/matchit.vim

" One is bound to use the LocalLeader more often (it is specific to the
" buffer/file), so it should use the easier-to-reach character.
let mapleader = "\\"
let maplocalleader = ","

" Esc alternative (easy on Dvorak)
inoremap hh <Esc>

" todo.txt additional bindings
augroup todotxtgroup
    autocmd!
    autocmd BufNewFile,BufRead,BufEnter todo.txt so $MYVIMDIR/todo-extra.vim
augroup END

" Markdown bindings
" Source: https://github.com/tpope/vim-surround/issues/15
let g:surround_{char2nr('*')} = "**\r**"

" Quick edit & similar
nnoremap <Leader>ev :vsplit ~/.vim/vimrc<cr>
nnoremap <Leader>sv :source $MYVIMRC<cr>
nnoremap <Leader>g :e ~/Google\ Drive/GTD/gtd.txt<cr>
nnoremap <Leader>es :vsplit ~/secure/scratch.txt<cr>

" other
autocmd Filetype gtd setlocal fdm=indent

"hi ColorColumn guibg=#330000 ctermbg=Black

" Stolen from:
"   https://youtu.be/aHm36-na4-4?list=PLdyMeP7HZ2xYPEilzjwqK6LDKOrGFtowI
"   (4:04 timepoint)
"set nocolorcolumn
"call matchadd('ColorColumn', '\%81v', 100)

" From:
"  http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Do not reveal Conceals items if in normal mode.
set cocu=n

" }}}1
" vim:fdm=marker:
