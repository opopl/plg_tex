
if exists("b:did_tex_tex_ftplugin")
  finish
endif
let b:did_tex_tex_ftplugin = 1

call base#buf#start()

"""ftplugin_tex

call tex#buff#start()
call tex#buff#setmaps()

call base#stl#set('tex')

" if we are dealing with a 'projs' (La)TeX file
"if ( ( b:dirname == b:root ) && ( b:ext == 'tex' ) )

"if ( b:dirname == b:root )
	
	"call projs#onload()

	"let b:proj = substitute(b:basename,'^\(\w\+\)\..*','\1','g')

	"if index(base#qw('inc jnames defs'),b:proj) >= 0
		"finish
	"endif

	"if (b:proj =~ '^'.'_def')
		"finish
	"endif

	"let b:sec = projs#secfromfile({ 
		"\	"file" : b:basename ,
		"\	"type" : "basename" ,
		"\	"proj" : b:proj     ,
       "\	})

	"let  mprg='projs_pdflatex'
	"let  mprg='projs_latexmk'

	"let aucmds = [ 
			"\	'call projs#root("'.escape(b:root,'\').'")'           ,
			"\	'call projs#proj#name("' . b:proj .'")'   ,
			"\	'call projs#proj#secname("' . b:sec .'")' ,
			"\	'call make#makeprg("'.mprg.'",{"echo":0})',
			"\	'call projs#onload()'                     ,
			"\	] 

	"let fr = '  autocmd BufWinEnter,BufRead,BufEnter,BufWritePost,BufNewFile '
	
	"let b:ufile = base#file#win2unix(b:file)
	
	"exe 'augroup projs_p_' . b:proj . '_' . b:sec
	"exe '  au!'
	"for cmd in aucmds
		"exe join([ fr,b:ufile,cmd ],' ')
	"endfor
	"exe 'augroup end'
"endif

