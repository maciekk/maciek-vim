let maplocalleader = ","

" Sort the entries for day on which cursor resides.
map <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

" Mark entry as done.
map <buffer> <LocalLeader>d ^r_^

" Mark entry as cancelled.
map <buffer> <LocalLeader>c ^rx^
map <buffer> <LocalLeader>x ^rx^

" Mark entry as waiting / blocked.
map <buffer> <LocalLeader>w ^rw^

" Change priorities.
map <buffer> <LocalLeader>0 ^r0w
map <buffer> <LocalLeader>1 ^r1w
map <buffer> <LocalLeader>2 ^r2w
map <buffer> <LocalLeader>3 ^r3w

" Go to today's entry; if it is missing, create it.
function! GoToToday()
    let day = substitute(strftime("%e"), " ", "", "g")
    let headline = strftime("%a // %b ".day)
    call cursor(1,1)
    if search("^".headline."$", "c") == 0
        " Create fresh entry. We are already at top.
        call append(0, [headline, "    2 ", ""])
        call cursor(line(".") - 2, 1)
        startinsert!
    endif
endfunction

map <silent> <buffer> <LocalLeader>t :call GoToToday()<CR>

" Use '0' to go to first non-white char as well; easier to type.
noremap <buffer> 0 ^
