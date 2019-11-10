
function! tex#buff#setmaps ()

	if exists('b:tex_buff_setmaps')
		return
	endif
	let b:tex_buff_setmaps = 1

  nnoremap <buffer><silent> <F4> :TEXRUN thisfile_pdflatex<CR>

  nnoremap <buffer><localleader>tn :TEXACT buf_nice<CR>
	
endfunction

function! tex#buff#start ()

	if exists('b:tex_buff_start')
		return
	endif
	let b:tex_buff_start = 1

	call base#buf#start()	

	let b:texfile_path  = b:file
	let b:texfile_lines = readfile(b:file)

	let b:texfile_struct = tex#input#parse({ 
		\ 'lines' : b:texfile_lines,
		\	})

endfunction

function! tex#buff#nice ()
	call base#buf#start()	

	if b:ext != 'tex'
			return
	endif

	call base#log([
		\	'Applying to:',
		\	'		' . b:file,
		\	],{ 'prf' : 'tex#buff#nice' })

	let b:texfile_path  = b:file
	let b:texfile_lines = readfile(b:file)

	perldo s/–/ --- /g
	perldo s/—/ --- /g

	perldo s/’/'/g
	perldo s/‘/'/g

	perldo s/“/``/g
	perldo s/”/''/g

	perldo s/"([^"\s]+)"/``$1''/g
	perldo s/([^-\s]+)-\s+([^-\s]+)/$1$2/g

	"perldo s/a/b/g
	"perldo VimMsg("a")

	"let b:texfile_struct = tex#input#parse({ 
		"\ 'lines' : b:texfile_lines,
		"\	})

endfunction

function! tex#buff#parse ()

	call base#buf#start()	

	let b:texfile_path  = b:file
	let b:texfile_lines = readfile(b:file)

	let b:texfile_struct = tex#input#parse({ 
		\ 'lines' : b:texfile_lines,
		\	})

endfunction
