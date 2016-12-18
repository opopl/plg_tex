

function! tex#act#tab_remove_multicolumn ()
	let start = base#varget('tex_texact_start')
	let end   = base#varget('tex_texact_end')

	let exprs = [
			\	's/\\multicolumn\s*{1}\s*{.\{-}}\s*{\(.\{-}\)}\s*\(&\|\\\\\)/\1 \2/g',
			\	] 
	
	for expr in exprs
		call tex#apply_to_each_line(expr,start,end)
	endfor
endfunction

function! tex#act#tab_nice ()
	let start = base#varget('tex_texact_start')
	let end   = base#varget('tex_texact_end')

	let exprs = [
			\	'Tabularize/&',
			\	'Tabularize/\\\\',
			\	's/\\textbf{}//g',
			\	] 

	for expr in exprs
		call tex#apply_to_markers(expr)
	endfor
endfunction
