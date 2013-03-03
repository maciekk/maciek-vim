" Vim syntax file
" Language: Maciej's TODO files
" Maintainer: Maciej Kalisiak
" Latest Revision: 1 March 2013

if exists("b:current_syntax")
  finish
endif

syn keyword todoEffort * ** ***

"syn region todoDayBlock start="^\S" end="^\s*$" fold transparent contains todoEffort todoPriority

syn match todoPriority "^\s\S"

let b:current_syntax = "todo"

hi def link todoEffort     Comment
hi def link todoPriority   Statement

