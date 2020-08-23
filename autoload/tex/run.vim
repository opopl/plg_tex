
if 0
	Call tree
		Called by
			tex#run
	Tags
		texrun_thisfile_pdflatex
endif

function! tex#run#thisfile_pdflatex_Fc (self,temp_file)
	let self      = a:self
	let temp_file = a:temp_file

	let code      = self.return_code

  let start     = self.start
  let target    = self.target

  let end      = localtime()
  let duration = end - start
  let s_dur    = printf(' %s (secs)',string(duration))

	if filereadable(temp_file)
	  let err = []
	
    call tex#efm#latex()
    exe 'cgetfile ' . temp_file
		call extend(err,getqflist())

		redraw!
		if len(err)
			let msg = printf('TEXRUN ERR: %s %s',target,s_dur)
			call base#rdwe(msg)
			BaseAct copen
		else
			let msg = printf('TEXRUN OK: %s %s',target,s_dur)
			call base#rdw(msg,'StatusLine')
			BaseAct cclose
		endif
		echohl None
	endif
endfunction
