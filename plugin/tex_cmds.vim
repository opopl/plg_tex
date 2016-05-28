

command! -nargs=* -complete=custom,tex#complete#insert TEXINSERT 
  \ call tex#insert(<f-args>)

command! -nargs=* TXX
  \ call tex#init(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texdoc TEXDOC
  \ call tex#texdoc(<f-args>)
