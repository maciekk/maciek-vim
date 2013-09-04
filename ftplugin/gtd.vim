" Getting Things Done file type.

" Only do this when not done yet for this buffer. {{{1
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

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

" priority-based sorting (from todo.vim type) {{{1
map <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

" other settings {{{1
setlocal shiftwidth=2
setlocal textwidth=999

" }}}1
" vim:fdm=marker
