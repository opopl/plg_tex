
function! tex#table#cells ()
	let t = { 
		\	'rows'   : [],
		\	'cols'   : [],
		\	'cols_n' : 0,
		\	'rows_n' : 0,
		\	}
	let t = base#varget('tex_table',t)
	
endfunction
