

fun! tex#texmf#files(...)
		let texlive = base#varget('tex_texlive',{})

		for dir in dirs
			" code
		endfor

endf

function! tex#texmf#action (...)
	let act = get(a:000,0,'')
	
endfunction
