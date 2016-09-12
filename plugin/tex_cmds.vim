

command! -nargs=* -complete=custom,tex#complete#insert TEXINSERT 
  \ call tex#insert(<f-args>)

command! -nargs=* TXX
  \ call tex#init(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texshow TEXSHOW
  \ call tex#show(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texrun TEXRUN
  \ call tex#run(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texdoc TEXDOC
  \ call tex#texdoc(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texmf TEXMF
  \ call tex#texmf#action(<f-args>)
