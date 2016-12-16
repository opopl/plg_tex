

function! tex#act#tab_remove_multicolumn ()
	let start = base#varget('tex_texact_start')
	let end   = base#varget('tex_texact_end')

	let expr = 's/\\multicolumn\s*{.\{-}}\s*{.\{-}}\s*{\(.\{-}\)}\s*\(&\|\\\\\)/\1 \2/g'

	call tex#apply2lines(expr,start,end)
endfunction
