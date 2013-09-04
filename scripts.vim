if did_filetype()	" filetype already set..
  finish		" ..don't do these checks
endif
if expand("%:p:h") =~ '^.*/GTD/'
  setfiletype gtd
endif
