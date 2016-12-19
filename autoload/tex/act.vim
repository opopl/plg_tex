

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

	let rows   = []
	let rows_l = []

	for rs in rows_s
		let row_a  = split(rs,'&')
		let row_a  = map(row_a,'substitute(v:val,"\\\\hline","","g")')
		let row_a  = map(row_a,'base#rmwh(v:val)')

		let row_l = len(row_a)

		call add(rows,row_a)
		call add(rows_l,row_l)
	endfor

	echo rows

	let rows_n = len(rows)
	let cols_n = max(rows_l)

	let cells_n=rows_n*cols_n
	let cells=[]

	echo rows_n
	echo cols_n
	echo cells_n

	let i=0
	for row in rows
		let j=0
		for cell in row
			call add(cells,cell)
			let j+=1
		endfor
		call extend(cells,base#listnew(max([cols_n-j,0])))
		let i+=1
	endfor

	let cols = []
	let col  = []


endfunction
