
function! tex#insert#plaintex (...)
	let lines=[]

	if a:0
		let cmd = a:1
	endif

	if cmd == 'begingroup'
		call add(lines,'\begingroup')
		call add(lines,'<++>')
		call add(lines,'\endgroup')
	elseif cmd == 'leaders'
		call add(lines,'\leaders<+box or rule+><+glue+>')

	endif
	return lines
endfunction

function! tex#insert#booktabs (...)
		call add(lines,'\toprule')
		call add(lines,'\midrule')
		call add(lines,'\bottomrule')
endfunction
