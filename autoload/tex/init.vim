
function! tex#init#au ()

	augroup plg_tex
		au!
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.cld setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.dtx setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.ltx setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.ins setf tex
	augroup end
endfunction

function! tex#init#texmf ()

	let texmfdist  = tex#kpsewhich('--var-value=TEXMFDIST')
	let texmflocal = tex#kpsewhich('--var-value=TEXMFLOCAL')

  let texlive={
        \  'TEXMFDIST'  : texmfdist,
        \  'TEXMFLOCAL' : texmflocal,
        \  }
  call base#varset('tex_texlive',texlive)
  call base#pathset({ 
        \ 'texmfdist'  : texmfdist,
        \ 'texmflocal' : texmflocal,
        \   })

endfunction
