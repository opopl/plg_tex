

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

function! tex#act#tab_load ()
	let start = base#varget('tex_texact_start',0)
	let end   = base#varget('tex_texact_end',line('$'))

	let expr = ''
  let num  = start

	let all =''
  while num < end+1
    "exe 'normal! ' . num . 'G'
    "exe expr

		let line = getline(num)
		let all .= line 

    let num+=1
  endw

	let all = base#rmwh(all)
	let all = substitute(all,'^\(.*\)\\\\\(.\{-}\)$','\1\\\\','g')

	let rows_s = split(all,'\\\\')

	let rows = []
	let cols = []

	for rs in rows_s
		let row_a  = split(rs,'&')
		let row_a  = map(row_a,'substitute(v:val,"\\\\hline","","g")')
		let row_a  = map(row_a,'base#rmwh(v:val)')

		call add(rows,row_a)
	endfor

	echo cols

endfunction
