
function! tex#table#empty ()
		let t = { 
			\	'rows'   : [],
			\	'cols'   : [],
			\	'cells'  : [],
			\	'cols_n' : 0,
			\	'rows_n' : 0,
			\	}
		return t

endfunction

function! tex#table#t ()
	let t = tex#table#empty()
	let t = base#varget('tex_table',t)
	return t
endfunction

function! tex#table#rows_n ()
		let t      = tex#table#t()
		let rows_n = get(t,'rows_n')
		return rows_n
endfunction

function! tex#table#cell (irow,jcol)

		let t = tex#table#t()
	
		let irow = a:irow
		let jcol = a:jcol
	
		let cells = get(t,'cells',[])

		let rows  = get(t,'rows',[])
		let cols  = get(t,'cols',[])

		let row   = rows[irow]
		let cell  = row[jcol]

		return cell
	
endfunction

function! tex#table#lines_csv (...)
	let csv = ''
	let t   = tex#table#t()

	let rows_n = get(t,'rows_n',0)
	let cols_n = get(t,'cols_n',0)
	let csv_a=[]
	let irow=0
	while irow<rows_n
		let row = []
		let jcol=0
		while jcol<cols_n
			let cell = tex#table#cell(irow,jcol) 
			call add(row,cell)
			let jcol+=1
		endw
		let row_s = join(row,',')
		call add(csv_a,row_s)
		let irow+=1
	endw

	return csv_a


endfunction

function! tex#table#act (...)
  let act = get(a:000,0,'')
	if !strlen(act)
		let act = input('TEX Table action:','','custom,tex#complete#textableact')
	endif

	let t = tex#table#t()

	let rows_n = get(t,'rows_n',0)
	let cols_n = get(t,'cols_n',0)

	if act == 'append_as_csv'
		let csv_a = tex#table#lines_csv()
		call append(line('.'),csv_a)

	elseif act == 'info'
		let i = [
			\	'Columns: ' . cols_n,
			\	'Rows:    ' . rows_n,
			\	]
		let is=join(i,"\n")
		echo is

	endif

endfunction
