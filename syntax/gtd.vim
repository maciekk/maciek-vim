if exists("b:current_syntax")
    finish
endif

syntax match gtdHeading "\v^\S+$"
syntax match gtdPriority "\v^\s+\S+"

highlight link gtdHeading Function
highlight link gtdPriority Comment

let b:current_syntax = "gtd"
