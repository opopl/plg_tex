
function! tex#code#item (...)
	 let val   = get(a:000,0,'')
	 let style = get(a:000,1,'')

	 let item = '\item ' . val
	 return item
	
endfunction

function! tex#code#itemize (items)
	let itemize = []

	call add(itemize,'\begin{itemize}')
	call add(itemize,'\end{itemize}')

	return join(itemize,"\n")

endfunction
