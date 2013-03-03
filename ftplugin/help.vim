" source: Hacking Vim book
"
" Move between subject-type hyperlinks.
nmap <buffer> s /\|\S\+\|<CR>
nmap <buffer> S ?\|\S\+\|<CR>
" Move between object-type hyperlinks.
nmap <buffer> o /'[a-z]\{2,\}'<CR>
nmap <buffer> O ?'[a-z]\{2,\}'<CR>
