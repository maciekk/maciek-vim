" Vim syntax file
" Language: Maciej's TODO files
" Maintainer: Maciej Kalisiak
" Latest Revision: 1 March 2013

if exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=*

syn keyword todoEffort * ** *** ****

syn region todoDayBlock matchgroup=Type start="^\w\+.*$" end="^\s*$" fold transparent contains=todoPriority,todoEffort

syn match todoComment  "^\s*#.*$"
syn match todoPriority "^\s\+\S"

hi def link todoComment    Comment
hi def link todoPriority   Function
hi def link todoEffort	   Statement

let b:current_syntax = "todo"

