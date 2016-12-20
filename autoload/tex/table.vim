
function! tex#table#cell (irow,jcol)
		let t = { 
			\	'rows'   : [],
			\	'cols'   : [],
			\	'cells'  : [],
			\	'cols_n' : 0,
			\	'rows_n' : 0,
			\	}
		let t = base#varget('tex_table',t)
	
		let irow = a:irow
		let jcol = a:jcol
	
		let cells = get(t,'cells',[])

		let rows  = get(t,'rows',[])
		let cols  = get(t,'cols',[])

		let row   = rows[irow]
		let cell  = row[jcol]

		return cell
	
endfunction

function! tex#table#act (...)
  let act = get(a:000,0,'')
	if !strlen(act)
		let act = input('TEX Table action:','','custom,tex#complete#textableact')
	endif

	if act == 'append_as_csv'
		" code
	endif

  "let sub = 'tex#act#'.act

endfunction
