
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

function! tex#table#cols_n ()
		let t      = tex#table#t()
		let cols_n = get(t,'cols_n')
		return cols_n
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

function! tex#table#col (jcol)
		let t = tex#table#t()

		let jcol = a:jcol
		let cols = get(t,'cols',[])
		let col  = get(cols,jcol,[])

		return col
endfunction

function! tex#table#sum_col (ref)
	let ref = a:ref
	let t   = tex#table#t()

	let rows_n = tex#table#rows_n()

	let jcol  = get(ref,'jcol',0)
	let start = get(ref,'start',0)
	let end   = get(ref,'end',rows_n)

	let col   = tex#table#col(jcol)
	let sum   = 0.0

	let j=0
	while j<cols_n
		let cell = col[j]
		let sum+=cell
		let j+=1
	endw

	return sum
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

"""TexTable_append_as_csv
	if act == 'append_as_csv'
		let csv_a = tex#table#lines_csv()
		call append(line('.'),csv_a)

"""TexTable_show_as_csv
	elseif act == 'show_as_csv'
		let csv_a = tex#table#lines_csv()
		split
		enew
		set buftype=nofile
		call tex#table#act('append_as_csv')

"""TexTable_info
	elseif act == 'info'
		let i = [
			\	'Columns: ' . cols_n,
			\	'Rows:    ' . rows_n,
			\	]
		let is=join(i,"\n")
		echo is

	endif

endfunction
