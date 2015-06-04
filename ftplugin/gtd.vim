" Getting Things Done file type.
" Maciej Kalisiak <mkalisiak@gmail.com>
"
" TODO:
" - insert compact timestamp on transition to "DONE"
" - don't use "zo" on jump to section; sometimes not in section (e.g., section
"   has 1 item, and cursor ends just after it
" - on item move, use marks instead of saved pos, for greater accuracy
"   (problem with one-off, depending on whether moved item before or after
"   cursor)
" - switch "BLOCKED" to "WAIT"?
" - better keybinding for switching to "BLOCKED"
" - add "NEXT" status?
" - make into proper Vim plugin (:he write-plugin)
" - make into separate Github project too, so can use w/Vundle
" - try unittests; Vader seems best? (https://github.com/junegunn/vader.vim)
" - change 'foldtext' to reflect # of items in that list
" - special syntax colouring for #MIT?
" - comply with http://google.github.io/styleguide/vimscriptguide.xml

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
    norm! 0gg
    if search('^' . a:sec_name . '$', 'c')
        " Section WAS found; advance to first task in it.
        norm! jzMzo
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

" Task move functions {{{1
func! s:GtdMoveTo(sec_name)
    " Save starting location.
    let save_cursor = getcurpos()

    " First, find line number of where to move the line to.
    call cursor(1,1)
    let dest = search('^'.a:sec_name.'$', 'c')
    if dest == 0
        throw 'Could not find section named '.a:sec_name
    endif

    " Now do the move.
    call setpos('.', save_cursor)
    echo 'Moving line to: '.dest
    exec 'm '.dest

    " Bring back cursor to starting point, in case want to move more items.
    let save_cursor[1] += 1
    call setpos('.', save_cursor)
    norm! zo
endfunc

func! GtdMoveToNow()
    call s:GtdMoveTo(s:sec_now)
endfunc

func! GtdMoveToToday()
    call s:GtdMoveTo(s:sec_today)
endfunc

func! GtdMoveToInbox()
    call s:GtdMoveTo(s:sec_inbox)
endfunc

func! GtdMoveToBacklog()
    call s:GtdMoveTo(s:sec_backlog)
endfunc

func! GtdMoveToDone()
    call s:GtdMoveTo(s:sec_done)
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
nnoremap <silent> <buffer> <LocalLeader>s vipoj:sort /\S/r<CR>

nnoremap <buffer><silent> <LocalLeader>jn :call GtdJumpToNow()<CR>
nnoremap <buffer><silent> <LocalLeader>jt :call GtdJumpToToday()<CR>
nnoremap <buffer><silent> <LocalLeader>ji :call GtdJumpToInbox()<CR>
nnoremap <buffer><silent> <LocalLeader>jb :call GtdJumpToBacklog()<CR>
nnoremap <buffer><silent> <LocalLeader>jd :call GtdJumpToDone()<CR>

nnoremap <buffer><silent> <LocalLeader>mn :call GtdMoveToNow()<CR>
nnoremap <buffer><silent> <LocalLeader>mt :call GtdMoveToToday()<CR>
nnoremap <buffer><silent> <LocalLeader>mi :call GtdMoveToInbox()<CR>
nnoremap <buffer><silent> <LocalLeader>mb :call GtdMoveToBacklog()<CR>
nnoremap <buffer><silent> <LocalLeader>md :call GtdMoveToDone()<CR>

nnoremap <buffer> <LocalLeader>a :call <SID>GtdChangePrio('A')<CR>
nnoremap <buffer> <LocalLeader>b :call <SID>GtdChangePrio('B')<CR>
nnoremap <buffer> <LocalLeader>c :call <SID>GtdChangePrio('C')<CR>
nnoremap <buffer> <LocalLeader><space> :call <SID>GtdChangePrio('')<CR>

nnoremap <buffer> <LocalLeader>w :call <SID>GtdChangeStatus('WIP')<CR>
nnoremap <buffer> <LocalLeader>B :call <SID>GtdChangeStatus('BLOCKED')<CR>
nnoremap <buffer> <LocalLeader>d :call <SID>GtdChangeStatus('DONE')<CR>

nnoremap <buffer> <LocalLeader>D :0,/^DONE$/g/^\s*DONE\s/m/^DONE$/<CR>

nnoremap <buffer><silent> <LocalLeader>s :call GtdSortSection()<CR>

" TODO: why do folds keep closing withou the 'zv'?
nnoremap <buffer> <D-Up> :m -2<CR>:norm! zv<CR>
nnoremap <buffer> <D-Down> :m +1<CR>:norm! zv<CR>

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
