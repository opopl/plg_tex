
function! tex#visual#load_lines(start,end,...)
  let vmode=visualmode()

  if ( vmode == "V" ) || ( ( vmode == "v" ) && (a:start != a:end ) )
    let mode='updown'
  elseif vmode == "v"
    let mode='leftright'
  endif

	let lines = []
	let lnum  = a:start

	while lnum < a:end+1
		 let line = getline(lnum)
		 call add(lines,line)
	
	   let lnum+=1
	endw

	let b:texfile_visual=lines
	return lines
	
endfunction

"command! -nargs=* -range -complete=custom,txtmy#complete#venclose 
  "\ VENCLOSE call txtmy#venclose(<line1>,<line2>,<f-args>)
