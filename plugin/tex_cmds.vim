
"""tex_cmds

command! -nargs=* -complete=custom,tex#complete#insert TEXINSERT 
  \ call tex#insert(<f-args>)

"command! -nargs=* -complete=custom,tex#complete#texact TEXACT 
  "\ call tex#act(<f-args>)

command! -nargs=* -range -complete=custom,tex#complete#texact TEXACT
	\	call tex#act(<line1>,<line2>,<f-args>)

command! -nargs=*  -complete=custom,tex#complete#textableact TexTable
	\	call tex#table#act(<f-args>)

command! -nargs=* TXX
  \ call tex#init(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texshow TEXSHOW
  \ call tex#show(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texrun TEXRUN
  \ call tex#run(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texdoc TEXDOC
  \ call tex#texdoc(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texht TEXHT
  \ call tex#texht(<f-args>)

command! -nargs=* -complete=custom,tex#complete#texmf TEXMF
  \ call tex#texmf#action(<f-args>)

"command! -nargs=* -range -complete=custom,txtmy#complete#venclose 
command! -nargs=* -range
	\ TexVisualLoadLines call tex#visual#load_lines(<line1>,<line2>,<f-args>)
