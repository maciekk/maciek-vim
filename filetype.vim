if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
    autocmd BufRead,BufNewFile *.todo setfiletype todo
augroup END

