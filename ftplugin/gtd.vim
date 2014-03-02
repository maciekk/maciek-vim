" Getting Things Done file type.

" Only do this when not done yet for this buffer. {{{1
if exists("b:did_gtd_ftplugin")
  "finish
endif
let b:did_gtd_ftplugin = 1

" better indentation-based folding {{{1
setlocal fdm=expr
setlocal foldexpr=GetGtdFold(v:lnum)

" Based on ideas from
" http://learnvimscriptthehardway.stevelosh.com/chapters/49.html
function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! GetGtdFold(lnum)
    " Blank lines have indent of NEXT line.
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = IndentLevel(a:lnum)
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction

function! NormalizeFile()
    " remove any multiple blank lines
    g/^$/,/./-j
    " remove trailing whitespace
    silent g/\s\+$/s///e
endfunction

function! GtdMarkDone(lnum)
  normal 0wr.
  m/^DONE$/<CR>
  call cursor(a:lnum, 2)
endfunction

function! GtdMoveToNow(lnum)
  m?^@now$?<CR>
  call cursor(a:lnum, 2)
endfunction

function! GtdMoveToBlocked(lnum)
  m?^@blocked$?<CR>
  call cursor(a:lnum, 2)
endfunction

function! GtdMoveToZ(lnum)
  m'z<CR>
  call cursor(a:lnum, 2)
endfunction

" priority-based sorting (from todo.vim type) {{{1
map <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

" mark item as DONE
map <buffer> <LocalLeader>d :call GtdMarkDone(line("."))<CR>
" move item up to @now
map <buffer> <LocalLeader>n :call GtdMoveToNow(line("."))<CR>
" move item up to @blocked
map <buffer> <LocalLeader>b :call GtdMoveToBlocked(line("."))<CR>
" move item to mark `z
map <buffer> <LocalLeader>. :call GtdMoveToZ(line("."))<CR>
" HACK: unmap corpdoc macro
silent! unmap <buffer> <LocalLeader>df

" other settings {{{1
setlocal shiftwidth=2
setlocal textwidth=999
setlocal autoindent

" }}}1
" vim:fdm=marker
