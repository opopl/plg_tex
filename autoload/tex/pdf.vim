
if 0
	Usage
		call tex#pdf#view()

		call tex#pdf#view(pdf_file)
		call tex#pdf#view('',viewer_id)

		call tex#pdf#view('','evince')
		call tex#pdf#view('','okular')

endif

function! tex#pdf#view (...)
	let pdf_file = fnamemodify(b:file,':r') . '.pdf'

	let a0 = get(a:000,0,'')
	let pdf_file = len(a0) ? a0 : pdf_file 

	let viewer_id = get(a:000,1,'evince')
	let viewer = base#exefile#path(viewer_id)
	echo viewer
	echo viewer_id
	
  if ! filereadable(pdf_file)
		let msg = printf('NO PDF FILE: %s', pdf_file)
		call base#rdwe(msg)
		return 
	endif

	if has('win32')
	  let ec = printf('silent! !start %s %s',viewer,pdf_file)
	else  
	  let ec = printf('silent! !%s %s &',viewer,pdf_file)
	endif
	
	exe ec
	redraw!

endfunction

