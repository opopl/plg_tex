

fun! tex#texmf#files(...)
		let texlive = base#varget('tex_texlive',{})

		let dirs = []
		let ids = base#qw('TEXMFDIST TEXMFLOCAL')

		for k in ids
			call add(dirs,get(texlive,k,''))
		endfor

		let files = []
		let exts  = base#qw('tex sty')
						
		let files = base#find({ "dirs" : dirs, "exts" : exts, "subdirs" : 1 })
		return files

endf

function! tex#texmf#action (...)
	let act = get(a:000,0,'')

	if ! len(act)
		let act = input('TEXMF action:','','custom,tex#complete#texmf')
	endif

	if act == 'SearchFile'

	elseif act == 'PrintFiles'
		let pat = input('Search pattern:','')

		let files = copy(base#varget('tex_texmf_files',[]))
		call filter(files,"fnamemodify(v:val,':t') =~ pat")

		echo files

	elseif act == 'OpenFiles'
		let pat = input('Search pattern:','')

		let files = copy(base#varget('tex_texmf_files',[]))
		call filter(files,"fnamemodify(v:val,':t') =~ pat")

		call base#fileopen({ "files" : files })

	elseif act == 'SaveFiles'
		let files = base#varget('tex_texmf_files',[])

		let sf_dir = base#qw#catpath('plg','tex data saved')
		call base#mkdir(sf_dir)

		let sf     = base#file#catfile([ sf_dir, 'texmf_files.i.dat' ])

		call writefile(files,sf)

		echo 'Saved list of TEXMF files to:'
		echo ' '. sf

	elseif act == 'LoadFilesFromSaved'

		let sf_dir = base#qw#catpath('plg','tex data saved')
		let sf     = base#file#catfile([ sf_dir, 'texmf_files.i.dat' ])

		if !filereadable(sf)
				echo 'File does NOT exist:'
				echo ' '.sf
		else
				echo 'Will load list of TEXMF files from:'
				echo '  ' . sf
				
				let cnt = input('Continue? 1/0: ',1)
				if cnt
						let files=readfile(sf)
						call base#varset('tex_texmf_files',files)
				endif
		endif

	elseif act == 'UpdateFiles'
		let files = tex#texmf#files()
		call base#var('tex_texmf_files',files)

	endif
	
endfunction
