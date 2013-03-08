let maplocalleader = ","

" Sort the entries for day on which cursor resides.
map <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

" Mark entry as done.
map <buffer> <LocalLeader>d ^r_^

" Mark entry as cancelled.
map <buffer> <LocalLeader>c ^rx^
map <buffer> <LocalLeader>x ^rx^

" Go to today's entry; if it is missing, create it.
function! GoToToday()
    let day = substitute(strftime("%e"), " ", "", "g")
    let headline = strftime("%a // %b ".day)
    call cursor(1,1)
    if search("^".headline."$", "c") == 0
        " Create fresh entry. We are already at top.
        call append(0, [headline, "    * ", ""])
        call cursor(line(".") - 2, 1)
        startinsert!
    endif
endfunction

map <buffer> <LocalLeader>t :call GoToToday()<CR>

