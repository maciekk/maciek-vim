if exists("b:current_syntax")
    finish
endif

" NOTE: issue ":highlight" command to see the available highlight groups
" (color combos one can use).

syntax match gtdHeading "\v^\S+"
highlight link gtdHeading Title

syntax match gtdStatusBlocked "\v\s*BLOCKED\s"
syntax match gtdStatusWIP "\v\s*WIP\s"
syntax match gtdStatusNext "\v\s*NEXT\s"
syntax match gtdStatusDone "\v\s*DONE\s"
highlight link gtdStatusBlocked Comment
highlight link gtdStatusWIP Character
highlight link gtdStatusNext Character
highlight link gtdStatusDone Function

syntax match gtdDoneLine "\v(\s*DONE\s)\@=.*$" contains=gtdStatusDone
highlight link gtdDoneLine Comment

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
