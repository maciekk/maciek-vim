if exists("b:current_syntax")
    finish
endif

syntax match gtdHeading "\v^\S+"
highlight link gtdHeading Title

syntax match gtdStatusWIP "\v\s*WIP\s"
syntax match gtdStatusBlocked "\v\s*BLOCKED\s"
syntax match gtdStatusDone "\v\s*DONE\s"
highlight link gtdStatusWIP Character
highlight link gtdStatusBlocked Comment
highlight link gtdStatusDone Function

syntax match gtdPriority "\v\[[A-C]\]"
highlight link gtdPriority Error

syntax match gtdContext "\v\@\S+"
syntax match gtdProject "\v\s#\S+"
highlight link gtdContext Number
highlight link gtdProject Define

let b:current_syntax = "gtd"
