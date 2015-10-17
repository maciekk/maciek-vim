" Vim filetype plugin for Getting Things Done
" Last Change:	2000 Oct 15
" Maintainer:	Maciej Kalisiak <maciej.kalisiak@gmail.com>
" License:	This file is placed in the public domain.
"
" TODO:
" - 0/have fn to filter :map listing to only those lines that match a regexp
" - 0/on <Leader>h or <Leader>?, show quickfix window with cheatsheet of
"   most useful GTD bindings (:cexp or setqflist()), or all Gtd.* fns
" - 1/key bind to show JUST the NOW section? "narrowing" to avoid noise, for
"   ease of execution; use :NarrowRegion, requires the plugin
" - 2/move task to same place as last time; want to be able to bounce on a key
"   to repetitively move a set of tasks. See if can use tpope/vim-repeat
" - 2/WIP - use <Plug> within plugin, and push out actual key bindings to user's vimrc
" - 2/switch "BLOCKED" status to "WAIT"?
" - 2/better keybinding for switching to "BLOCKED"
" - 3/add "NEXT" status?
" - 3/make into proper Vim plugin (:he write-plugin)
" - 3/make into separate Github project too, so can use w/Vundle
" - 3/try unittests; Vader seems best? (https://github.com/junegunn/vader.vim)
" - 3/comply with http://google.github.io/styleguide/vimscriptguide.xml

" skip if already loaded. {{{1
if exists("b:did_gtd_ftplugin")
  "finish
endif
let b:did_gtd_ftplugin = 1

" helper functions {{{1

" Returns true if the specified 'line' contains a task.
func! s:GtdLineIsTask(line)
    " Find first non-blank character on line.
    let first_nonblank = match(getline(a:line), '\S')

    " Line is NOT task if it is whitespace-only, or it is a section name.
    if first_nonblank == -1 || first_nonblank == 0
        return 0
    else
        return 1
    endif
endfunc

" Returns line number of specified 'section'. Returns 0 if section not found.
func! s:GtdFindSection(section)
    return search('^'.a:section.'$', 'cnw')
endfunc

" Return the status of the task on current line.
func! s:GtdTaskStatus()
    let first_word = matchlist(getline('.'), '\v\s+(\S+)')[1]
    if match(first_word, '\v^WIP|BLOCKED|DONE$') > -1
        return first_word
    endif
    return ''
endfunc

" Open fold under cursor, but only IF there is one.
"
" Primarily used to avoid E490 errors.
" Based on: http://stackoverflow.com/questions/5850103/try-catch-in-vimscript
func! s:GtdMaybeOpenFold()
    try | foldopen! | catch | | endtry
endfunc

" cursor motion funcs {{{1
func! s:JumpTo(sec_name)
    norm! 0gg
    if search('^' . a:sec_name . '$', 'c')
        " Section WAS found; advance to first task in it.
        norm! jzM
        call s:GtdMaybeOpenFold()
    endif
endfunc

" task move functions {{{1
func! <SID>MoveTo(sec_name)
    let cur_line = line('.')
    let dest_line = s:GtdFindSection(a:sec_name)
    if dest_line == 0
        throw 'Could not find section named '.a:sec_name
    endif

    exec 'move '.dest_line

    " Move cursor to 'next item', so can continue moving tasks.
    if dest_line < cur_line
        " We moved the prior task earlier, so next task is STILL on next line.
        " Had we moved it below, next task would have been automatically moved
        " up to CURRENT line.
        let cur_line += 1
    endif
    call cursor(cur_line, 0)

    silent call s:GtdMaybeOpenFold()
endfunc

" Move up task under cursor so that it is first in current section.
func! s:MoveToFirst()
    let curline = line('.')
    let section_start = search('^\S', 'bcnW')

    " Do nothing if not on a task line.
    if match(getline('.'), '\S') == -1
        return
    endif
    if curline == section_start
        return
    endif

    " Do nothing if already first item.
    if curline == section_start + 1
        return
    endif

    " Do the move.
    exec curline.' move '.section_start

    " Move cursor to item that was next after the moved one.
    call cursor(curline+1, 0)

    call s:GtdMaybeOpenFold()
endfunc

" Move all DONE items to bottom of file.
func! s:GtdCleanUpDone()
    " Establish (non-DONE) task to which we will move cursor after the clean
    " up.
    " regexp based on:
    "   http://vim.wikia.com/wiki/Search_for_lines_not_containing_pattern#Using_the_:v_command
    call search('\v^((\s+DONE.*)@!.)*$', 'bcW')
    mark '
    0,/^DONE$/g/^\s*DONE\s/m/^DONE$/
    nohls
    normal ''
    call s:GtdMaybeOpenFold()
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

" Remove any status strings in current line.
func! s:GtdRemoveStatus()
    " First try the easy ones.
    s/^\(\s*\)\(WIP\|BLOCKED\) /\1/e

    " Now try DONE, with the timestamp.
    s/^\(\s*\)\(DONE \d\+\.\d\+\.\d\+-\d\+:\d\+\) /\1/e
endfunc

" Change status of task on current line.
func! s:GtdChangeStatus(status)
    " Do nothing if not on a task line.
    if !s:GtdLineIsTask('.')
        return
    endif
    " Do nothing if task already has requested status.
    if a:status == s:GtdTaskStatus()
        return
    endif
    call s:GtdRemoveStatus()
    if a:status == ''
        return
    endif
    let save_cursor = getcurpos()
    if a:status == 'DONE'
        " Extend it with a timestamp.
        let status_str = a:status.' '.strftime("%y.%m.%d-%H:%M")
    else
        let status_str = a:status
    endif
    " Now add the status.
    exec 's/^\(\s*\)\(.*\)/\1'.status_str.' \2/'
    call setpos('.', save_cursor)
endfunc

func! s:GtdChangePrio(prio)
    if !s:GtdLineIsTask('.')
        return
    endif
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

" Remove status from task, if it has one, else remove prio.
" This is useful for removing both: simply call execute function twice.
func! s:GtdRemoveStatusThenPrio()
    if '' == s:GtdTaskStatus()
        call s:GtdChangePrio('')
    else
        call s:GtdRemoveStatus()
    endif
endfunc

" option settings {{{1
setlocal shiftwidth=2
setlocal textwidth=999
setlocal autoindent

" bindings {{{1
"
" NOTES:
" - <buffer> not needed for ftplugins? (already local?)
" - users can remap these in ~/.vimrc, which will prevent mappings here from
"   being applied

" priority-based sorting (from todo.vim type)
if !hasmapto('<Plug>(GtdSortByPrio)')
  nmap <silent><unique> <LocalLeader>s <Plug>(GtdSortByPrio)
endif
nnoremap <Plug>(GtdSortByPrio)
            \ vipoj:sort /\S/r<CR>

if !hasmapto('<Plug>(GtdJumpToNow)')
  nmap <silent><unique> <LocalLeader>jn <Plug>(GtdJumpToNow)
endif
if !hasmapto('<Plug>(GtdJumpToToday)')
  nmap <silent><unique> <LocalLeader>jt  <Plug>(GtdJumpToToday)
endif
if !hasmapto('<Plug>(GtdJumpToInbox)')
  nmap <silent><unique> <LocalLeader>ji  <Plug>(GtdJumpToInbox)
endif
if !hasmapto('<Plug>(GtdJumpToBacklog)')
  nmap <silent><unique> <LocalLeader>jb  <Plug>(GtdJumpToBacklog)
endif
if !hasmapto('<Plug>(GtdJumpToSomeday)')
  nmap <silent><unique> <LocalLeader>js  <Plug>(GtdJumpToSomeday)
endif
if !hasmapto('<Plug>(GtdJumpToDone)')
  nmap <silent><unique> <LocalLeader>jd  <Plug>(GtdJumpToDone)
endif

nnoremap <Plug>(GtdJumpToNow)
            \ :call <SID>JumpTo("NOW")<CR>
nnoremap <Plug>(GtdJumpToToday)
            \ :call <SID>JumpTo("TODAY")<CR>
nnoremap <Plug>(GtdJumpToInbox)
            \ :call <SID>JumpTo("INBOX")<CR>
nnoremap <Plug>(GtdJumpToBacklog)
            \ :call <SID>JumpTo("BACKLOG")<CR>
nnoremap <Plug>(GtdJumpToSomeday)
            \ :call <SID>JumpTo("SOMEDAY")<CR>
nnoremap <Plug>(GtdJumpToDone)
            \ :call <SID>JumpTo("DONE")<CR>

if !hasmapto('<Plug>(GtdMoveToNow)')
  nmap <silent><unique> <LocalLeader>mn <Plug>(GtdMoveToNow)
endif
if !hasmapto('<Plug>(GtdMoveToToday)')
  nmap <silent><unique> <LocalLeader>mt  <Plug>(GtdMoveToToday)
endif
if !hasmapto('<Plug>(GtdMoveToInbox)')
  nmap <silent><unique> <LocalLeader>mi  <Plug>(GtdMoveToInbox)
endif
if !hasmapto('<Plug>(GtdMoveToBacklog)')
  nmap <silent><unique> <LocalLeader>mb  <Plug>(GtdMoveToBacklog)
endif
if !hasmapto('<Plug>(GtdMoveToSomeday)')
  nmap <silent><unique> <LocalLeader>ms  <Plug>(GtdMoveToSomeday)
endif
if !hasmapto('<Plug>(GtdMoveToDone)')
  nmap <silent><unique> <LocalLeader>md  <Plug>(GtdMoveToDone)
endif
if !hasmapto('<Plug>(GtdMoveToFirst)')
  nmap <silent><unique> <LocalLeader>m1  <Plug>(GtdMoveToFirst)
endif

nnoremap <Plug>(GtdMoveToNow)
            \ :call <SID>MoveTo("NOW")<CR>
nnoremap <Plug>(GtdMoveToToday)
            \ :call <SID>MoveTo("TODAY")<CR>
nnoremap <Plug>(GtdMoveToInbox)
            \ :call <SID>MoveTo("INBOX")<CR>
nnoremap <Plug>(GtdMoveToBacklog)
            \ :call <SID>MoveTo("BACKLOG")<CR>
nnoremap <Plug>(GtdMoveToSomeday)
            \ :call <SID>MoveTo("SOMEDAY")<CR>
nnoremap <Plug>(GtdMoveToDone)
            \ :call <SID>MoveTo("DONE")<CR>
nnoremap <Plug>(GtdMoveToFirst)
            \ :call <SID>MoveToFirst()<CR>

" TODO: update the rest of these mappnigs to use <Plug>

nnoremap <buffer><silent> <LocalLeader>a :call <SID>GtdChangePrio('A')<CR>
nnoremap <buffer><silent> <LocalLeader>b :call <SID>GtdChangePrio('B')<CR>
nnoremap <buffer><silent> <LocalLeader>c :call <SID>GtdChangePrio('C')<CR>
nnoremap <buffer><silent> <LocalLeader><space> 
            \:call <SID>GtdRemoveStatusThenPrio()<CR>

nnoremap <buffer><silent> <LocalLeader>w :call <SID>GtdChangeStatus('WIP')<CR>
nnoremap <buffer><silent> <LocalLeader>z :call <SID>GtdChangeStatus('BLOCKED')<CR>
nnoremap <buffer><silent> <LocalLeader>d :call <SID>GtdChangeStatus('DONE')<CR>

nnoremap <buffer><silent> <LocalLeader>D :call <SID>GtdCleanUpDone()<CR>

nnoremap <buffer><silent> <LocalLeader>s :call GtdSortSection()<CR>

" Close all sections, and reopen only the current one.
nnoremap <buffer><silent> z. zMzv

" TODO: why do folds keep closing without the 'zv'?
nnoremap <buffer><silent> <D-Up> :m -2<CR>:norm! zv<CR>
nnoremap <buffer><silent> <D-Down> :m +1<CR>:norm! zv<CR>

" {{{1 abbreviations

" On-the-fly priority entry
iabbrev AA [A]
iabbrev BB [B]
iabbrev CC [C]

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

" {{{1 vim:fdm=marker:
" }}}
