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

syntax match gtdHighPriority "\[A\]"
syntax match gtdMediumPriority "\[B\]"
syntax match gtdLowPriority "\[C\]"
highlight link gtdHighPriority ErrorMsg
highlight link gtdMediumPriority Error
highlight link gtdLowPriority Comment

syntax match gtdContext "\v\@\S+"
syntax match gtdProject "\v\s#\S+"
highlight link gtdContext Number
highlight link gtdProject Define

let b:current_syntax = "gtd"
