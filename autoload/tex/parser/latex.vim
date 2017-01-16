
function! tex#parser#latex#patterns ()

 let pats = { 
		 	\	'latex_error' : '^\(.*\):\(\d\+\): LaTeX Error:\(.*\)',
		 	\	'error'       : '^\(.*\):\(\d\+\): ',
			\}

 call base#varset('tex_parser_latex_patterns',pats)
 return pats
	
endfunction
