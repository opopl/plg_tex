
function! tex#buff#setmaps ()

	if exists('b:tex_buff_setmaps')
		return
	endif
	let b:tex_buff_setmaps = 1

  let maps = {
    \ 'nnoremap' :
      \ {
      \  ';xx'    : 'TEXRUN thisfile_tex',
      \  ';xe'    : 'TEXRUN evince_view_thisfile',
      \  ';xk'    : 'TEXRUN okular_view_thisfile',
    \ },
		\	}

  for [ map, mp ] in items(maps)
    call base#buf#map_add(mp,{ 'map' : map })
  endfor
	
endfunction

function! tex#buff#start ()

	if exists('b:tex_buff_start')
		return
	endif
	let b:tex_buff_start = 1

	call base#buf#start()	

	if exists("b:file")
		let b:texfile_path  = b:file
		let b:texfile_lines = readfile(b:file)
	
		let b:texfile_struct = tex#input#parse({ 
			\ 'lines' : b:texfile_lines,
			\	})
	endif

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
