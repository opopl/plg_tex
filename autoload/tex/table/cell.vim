

function! tex#table#cell#strip_tex_code (code)
	let code = a:code

	let code = substitute(code,'\\textbf{\(.*\)}','\1','g')
	return code

endfunction
