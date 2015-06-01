" Getting Things Done file type.
" Maciej Kalisiak <mkalisiak@gmail.com>
"
" TODO:
" - switch to using '' for regexs, to avoid extra escaping
" - add "NEXT" status?
" - make into proper Vim plugin
" - make into separate Github project too, so can use w/Vundle
" - try unittests; Vader seems best? (https://github.com/junegunn/vader.vim)
" - change 'foldtext' to reflect # of items in that list
" - special syntax colouring for #MIT?

" skip if already loaded. {{{1
if exists("b:did_gtd_ftplugin")
  "finish
endif
let b:did_gtd_ftplugin = 1

" section names {{{1
let s:sec_now = "NOW"
let s:sec_today = "TODAY"
let s:sec_inbox = "INBOX"
let s:sec_backlog = "BACKLOG"
let s:sec_done = "DONE"

" motion funcs {{{1
func! s:GtdJumpTo(sec_name)
    norm 0gg
    if search('^' . a:sec_name . '$', 'c')
        " Section WAS found; advance to first task in it.
        norm jzMzo
    endif
endfunc

func! GtdJumpToNow()
    call s:GtdJumpTo(s:sec_now)
endfunc

func! GtdJumpToToday()
    call s:GtdJumpTo(s:sec_today)
endfunc

func! GtdJumpToInbox()
    call s:GtdJumpTo(s:sec_inbox)
endfunc

func! GtdJumpToBacklog()
    call s:GtdJumpTo(s:sec_backlog)
endfunc

func! GtdJumpToDone()
    call s:GtdJumpTo(s:sec_done)
endfunc

" Return line number of section head, or 0 if not found.
func! GtdFindSection(section)
  return search('^' . a:section . '$', 'wn')
endfunc

" sorting {{{1
"
" Order:
" - primary key is status, in this order: BLOCKED, WIP, [none], DONE
" - secondary key is prio, in this order: A, B, [none], C
"   (absence of priority is equivalent to B)
func! GtdSortSection()
    let section_extent = s:GtdSectionExtens()
    let content = getline(section_extent[0], section_extent[1])
    call sort(content, 's:GtdSortFn')
    " TODO: only setline() if content changed.
    call setline(section_extent[0], content)
endfunc

" Return [start, end] line numbers of current section.
" Does NOT include the section heading, only actual tasks.
func! s:GtdSectionExtens()
    let hit = search('^\S', 'bcnW')
    if hit == 0
        throw 'Invalid section: no leading section title.'
    endif
    let start = hit + 1

    let hit = search('^$', 'cnW')
    if hit == 0
        " No blank line before EOF; 
        let end = line('$')
    else
        let end = hit - 1
    return [start, end]
endfunc

" Task sort function.
func! s:GtdSortFn(i1, i2)
    let status_prio1 = s:GtdGetStatusPrio(a:i1)
    let status_prio2 = s:GtdGetStatusPrio(a:i2)

    " Convert to numeric, for ease of sorting.
    let status_pos1 = s:GtdStatusSortPosition(status_prio1[0])
    let status_pos2 = s:GtdStatusSortPosition(status_prio2[0])
    let prio_pos1 = s:GtdPrioSortPosition(status_prio1[1])
    let prio_pos2 = s:GtdPrioSortPosition(status_prio2[1])

    if status_pos1 < status_pos2
        return -1
    elseif status_pos1 > status_pos2
        return +1
    else
        if prio_pos1 < prio_pos2
            return -1
        elseif prio_pos1 > prio_pos2
            return +1
        endif
    endif

    " Status & Prio must be matching.
    return 0
endfunc

" Extract the status and priority elements of the task.
func! s:GtdGetStatusPrio(line)
    let status_prio = matchlist(a:line, '\s*\(WIP\|BLOCKED\|DONE\)\?\s\(\[[A-C]\]\)\?')
    if empty(status_prio)
        " If no hits on any groups, matchlist() returns a plain '[]'
        let status_prio = ['', '']
    else
        " Discard the 0th element (whole match).
        let status_prio = status_prio[1:2]
    endif
    if !empty(status_prio[1])
        " Extract just the letter, and drop the square brackets.
        let status_prio[1] = status_prio[1][1]
    endif
    return status_prio
endfunc

func! s:GtdStatusSortPosition(status)
    if a:status == 'BLOCKED'
        return 0
    elseif a:status == 'WIP'
        return 1
    elseif a:status == ''
        return 2
    elseif a:status == 'DONE'
        return 3
    else
        throw 'UNKNOWN_STATUS: '.a:status
    endif
endfunc

func! s:GtdPrioSortPosition(prio)
    if a:prio == 'A'
        return 0
    elseif a:prio == 'B'
        return 1
    elseif a:prio == ''
        return 2
    elseif a:prio == 'C'
        return 3
    else
        throw 'UNKNOWN_PRIORITY: '.a:prio
    endif
endfunc

" change priority or status {{{1

" Change status of task on current line.
func! s:GtdChangeStatus(status)
    let save_cursor = getcurpos()
    " First, remove any status present. Ignore if not present.
    s/^\(\s*\)\(DONE\|WIP\|BLOCKED\) /\1/e
    " Now add the status.
    exec 's/^\(\s*\)\(.*\)/\1'.a:status.' \2/'
    call setpos('.', save_cursor)
endfunc

func! s:GtdChangePrio(prio)
    let save_cursor = getcurpos()
    let prio_str = ''
    if !empty(a:prio)
        let prio_str = '['.a:prio.'] '
    endif
    " First, remove any prio present. Ignore if not present.
    s/^\(\s*\)\(DONE\|WIP\|BLOCKED\)\? \[[A-C]\] /\1\2 /e
    " Now add the prio.
    exec 's/^\(\s*\)\(DONE\|WIP\|BLOCKED\)\? /\1\2 '.prio_str.'/'
    call setpos('.', save_cursor)
endfunc

" option settings {{{1
setlocal shiftwidth=2
setlocal textwidth=999
setlocal autoindent

" bindings {{{1

" priority-based sorting (from todo.vim type)
map <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

map <buffer><silent> <LocalLeader>jn :call GtdJumpToNow()<CR>
map <buffer><silent> <LocalLeader>jt :call GtdJumpToToday()<CR>
map <buffer><silent> <LocalLeader>ji :call GtdJumpToInbox()<CR>
map <buffer><silent> <LocalLeader>jb :call GtdJumpToBacklog()<CR>
map <buffer><silent> <LocalLeader>jd :call GtdJumpToDone()<CR>

map <buffer> <LocalLeader>a :call <SID>GtdChangePrio('A')<CR>
map <buffer> <LocalLeader>b :call <SID>GtdChangePrio('B')<CR>
map <buffer> <LocalLeader>c :call <SID>GtdChangePrio('C')<CR>
map <buffer> <LocalLeader><space> :call <SID>GtdChangePrio('')<CR>

map <buffer> <LocalLeader>w :call <SID>GtdChangeStatus('WIP')<CR>
map <buffer> <LocalLeader>B :call <SID>GtdChangeStatus('BLOCKED')<CR>
map <buffer> <LocalLeader>d :call <SID>GtdChangeStatus('DONE')<CR>

map <buffer> <LocalLeader>D :0,/^DONE$/g/^\s*DONE\s/m/^DONE$/<CR>

map <buffer><silent> <LocalLeader>s :call GtdSortSection()<CR>

" HACK: unmap corpdoc macro
silent! unmap <buffer> <LocalLeader>df

" better indentation-based folding {{{1
setlocal fdm=expr
setlocal foldexpr=s:GetGtdFold(v:lnum)

" Based on ideas from
" http://learnvimscriptthehardway.stevelosh.com/chapters/49.html
" TODO: this is dead code?
func! s:IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunc

func! s:NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1
    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif
        let current += 1
    endwhile
    return -2
endfunc

" TODO: this is dead code?
func! s:GetGtdFold(lnum)
    " Blank lines have indent of NEXT line.
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = s:IndentLevel(a:lnum)
    let next_indent = s:IndentLevel(s:NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunc

" }}}
" vim:fdm=marker
