
if has('gui_gtk2')
    ":set guifont=Luxi\ Mono\ 12
    "set guifont=Lucida\ Sans\ Typewriter\ 10
    "set guifont=LucidaTypewriter\ 9
    "set guifont=Deja\ Vu\ Sans\ Mono\ 10
    "set guifont=Liberation\ Mono\ 11
    set guifont=Input\ Mono\ 12
elseif has('x11')
    " Also for GTK 1 & GTK 3
    "set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
    set guifont=Input\ Mono\ 12
elseif has('gui_win32')
    "set guifont=Lucida_Console:h10:cANSI
    "set guifont=ProggyCleanTT:h12:cANSI
    "set guifont=Crisp:h12:cANSI
    "set guifont=Inconsolata:h12
    "set guifont=gohufont-14
    " source: https://github.com/belluzj/fantasque-sans
    "set guifont=Fantasque_Sans_Mono:h13
    set guifont=FantasqueSansMono_Nerd_Font_Mon:h16:cANSI:qDRAFT
elseif has('gui_macvim')
    "set guifont=Inconsolata:h18
    "set guifont=Osaka-Mono:h20
    "set guifont=PT\ Mono:h18
    "set guifont=Cousine:h18
    "set guifont=CourierNewPSMT:h17
    set guifont=FantasqueSansMonoNerdFontCompleteM-Regular:h18
endif

set guioptions=gc
" adjust cursor blink
set guicursor+=a:blinkon100-blinkoff100-blinkwait500

set lines=50
set columns=160
