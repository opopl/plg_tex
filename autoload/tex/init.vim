
function! tex#init#au ()

	augroup plg_tex
		au!
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.cld setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.dtx setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.ltx setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.ins setf tex
	augroup end
endfunction

function! tex#init#maps ()
	if exists("g:Tex_Leader")
		let s = "vnoremap <silent> ".g:Tex_Leader.'vb'
		let s.= " \<C-\\>\\<C-N>:call VEnclose('\\verb{', '}', '\\begin{verbatim}', '\\end{verbatim}')<CR>"
		exe s
		
		vnoremap <silent> `vb :call VEnclose('\verb\|', '\|', '\begin{verbatim}', '\end{verbatim}')<CR>
		vnoremap <silent> `url :call VEnclose('\url{', '}'  , '\url{', '}')<CR>
		vnoremap <silent> `ul  :call VEnclose('\underline{', '}'  , '\underline{', '}')<CR>

	endif
endfunction

function! tex#init#texmf ()

	let texmfdist  = tex#kpsewhich('--var-value=TEXMFDIST')
	let texmflocal = tex#kpsewhich('--var-value=TEXMFLOCAL')
	let texmfhome  = tex#kpsewhich('--var-value=TEXMFHOME')

  let texlive={
        \  'TEXMFDIST'  : texmfdist,
        \  'TEXMFLOCAL' : texmflocal,
        \  'TEXMFHOME'  : texmfhome,
        \  }
  call base#varset('tex_texlive',texlive)
  call base#pathset({ 
        \ 'texmfdist'  : texmfdist,
        \ 'texmflocal' : texmflocal,
        \ 'texmfhome'  : texmfhome,
        \   })

endfunction
