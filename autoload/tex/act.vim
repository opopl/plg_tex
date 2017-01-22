
function! tex#act#tab_remove_multicolumn ()
	let start = base#varget('tex_texact_start')
	let end   = base#varget('tex_texact_end')

	let exprs = [
			\	's/\\multicolumn\s*{\s*1\s*}\s*{.\{-}}\s*{\(.\{-}\)}\s*\(&\|\\\\\)/\1 \2/g',
			\	] 
	
	for expr in exprs
		call tex#apply_to_each_line(expr,start,end)
	endfor
endfunction

function! tex#act#tab_nice ()
	let start = base#varget('tex_texact_start')
	let end   = base#varget('tex_texact_end')

	let exprs = [
			\	'Tabularize/&'    ,
			\	'Tabularize/\\\\' ,
			\	's/\\textbf{}//g' ,
			\	] 

	for expr in exprs
		call tex#apply_to_markers(expr)
	endfor

endfunction

function! tex#act#everyhook_cmd ()

endfunction

"""sol_add_hline
function! tex#act#sol_add_hline ()
	let start = base#varget('tex_texact_start',0)
	let end   = base#varget('tex_texact_end',line('$'))

	let expr = 's/^/\\hline /g'

	call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#sol_add ()
	let start = base#varget('tex_texact_start',0)
	let end   = base#varget('tex_texact_end',line('$'))

	let cmd = input('TEX Command to insert:','')
	let expr = 's/^/\\'.cmd.' /g'

	call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#eol_add ()
	let start = base#varget('tex_texact_start',0)
	let end   = base#varget('tex_texact_end',line('$'))

	let cmds = base#varget('tex_cmds_eol_add',[])
	let cmd = get(cmds,0,'')
	let cmd = input('TEX Command to insert:',cmd,'custom,tex#complete#cmds_eol_add')

	call add(cmds,cmd)
	let cmds = base#uniq(cmds)
	call base#varset('tex_cmds_eol_add',cmds)

	let expr = 's/$/\\'.cmd.'/g'

	call tex#apply_to_each_line (expr,start,end)
endfunction

function! tex#act#eol_add_par ()
	let start = base#varget('tex_texact_start',0)
	let end   = base#varget('tex_texact_end',line('$'))

	let expr = 's/$/\\par/g'

	call tex#apply_to_each_line (expr,start,end)
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

		if line =~ '^\s*%'
    	let num+=1
			continue
		endif
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

		let row_l  = len(row_a)

		call add(rows,row_a)
		call add(rows_l,row_l)
	endfor

	let rows_n = len(rows)
	let cols_n = max(rows_l)

	let cells_n = rows_n*cols_n
	let cells   = []

	let irow=0
	for row in rows
		let jcol=0
		for cell in row
			call add(cells,cell)
			let jcol+=1
		endfor
		call extend(cells,base#listnew(max([cols_n-jcol,0])))
		let irow+=1
	endfor

	let cols = base#listnew(cols_n)
	let col  = []

	for jcol in base#listnewinc(0,cols_n-1,1)
			let cols[jcol]=base#listnew(rows_n)
	endfor

	let ic=0
	for cell in cells
		let irow = ic/cols_n
		let jcol = ic % cols_n

		let thiscol       = cols[jcol]
		let thiscol[irow] = cell

		let ic += 1
	endfor

	let t={}
	call extend(t,{ 
		\	'cols'   : cols,
		\	'rows'   : rows,
		\	'rows_n' : rows_n,
		\	'cols_n' : cols_n,
		\	})

	call base#varset('tex_table',t)

	echo 'Table loaded with '.rows_n.' rows and '.cols_n.' columns into variable tex_table'

endfunction
