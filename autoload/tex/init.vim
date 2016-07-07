
function! tex#init#au ()
	augroup plg_tex
		au!
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.cld setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.dtx setf tex
		autocmd BufWinEnter,BufRead,BufNewFile,BufWrite *.ins setf tex
	augroup end
endfunction
