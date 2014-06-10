if exists("b:current_syntax")
    finish
endif

syntax match gtdHeading "\v^\S+.*"
syntax match gtdPriority "\v^\s+\S+"
syntax match gtdContext "\v\@\S+"
syntax match gtdProject "\v\s\+\S+"

highlight link gtdHeading Function
highlight link gtdPriority Comment
highlight link gtdContext String
highlight link gtdProject Number

let b:current_syntax = "gtd"
