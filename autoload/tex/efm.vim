
function! tex#efm#latex ()

  let h = base#varget('tex_efm',{})
  let sals = get(h,'show_all_lines',0)

  let pm = ( sals ? '+' : '-' )

	setlocal efm=

	if !sals
		call tex#efm#ignore_warnings()
	endif

	setlocal efm+=%E!\ LaTeX\ %trror:\ %m
	setlocal efm+=%E!\ %m
	setlocal efm+=%E%f:%l:\ %m

	setlocal efm+=%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#
	setlocal efm+=%+W%.%#\ at\ lines\ %l--%*\\d
	setlocal efm+=%+WLaTeX\ %.%#Warning:\ %m

	exec 'setlocal efm+=%'.pm.'Cl.%l\ %m'
	exec 'setlocal efm+=%'.pm.'Cl.%l\ '
	exec 'setlocal efm+=%'.pm.'C\ \ %m'
	exec 'setlocal efm+=%'.pm.'C%.%#-%.%#'
	exec 'setlocal efm+=%'.pm.'C%.%#[]%.%#'
	exec 'setlocal efm+=%'.pm.'C[]%.%#'
	exec 'setlocal efm+=%'.pm.'C%.%#%[{}\\]%.%#'
	exec 'setlocal efm+=%'.pm.'C<%.%#>%m'
	exec 'setlocal efm+=%'.pm.'C\ \ %m'
	exec 'setlocal efm+=%'.pm.'GSee\ the\ LaTeX%m'
	exec 'setlocal efm+=%'.pm.'GType\ \ H\ <return>%m'
	exec 'setlocal efm+=%'.pm.'G\ ...%.%#'
	exec 'setlocal efm+=%'.pm.'G%.%#\ (C)\ %.%#'
	exec 'setlocal efm+=%'.pm.'G(see\ the\ transcript%.%#)'
	exec 'setlocal efm+=%'.pm.'G\\s%#'
	exec 'setlocal efm+=%'.pm.'O(%*[^()])%r'
	exec 'setlocal efm+=%'.pm.'P(%f%r'
	exec 'setlocal efm+=%'.pm.'P\ %\\=(%f%r'
	exec 'setlocal efm+=%'.pm.'P%*[^()](%f%r'
	exec 'setlocal efm+=%'.pm.'P(%f%*[^()]'
	exec 'setlocal efm+=%'.pm.'P[%\\d%[^()]%#(%f%r'

	if get(h,'ignore_unmatched',0) && !get(h,'show_all_lines',0)
		setlocal efm+=%-P%*[^()]
	endif

	exec 'setlocal efm+=%'.pm.'Q)%r'
	exec 'setlocal efm+=%'.pm.'Q%*[^()])%r'
	exec 'setlocal efm+=%'.pm.'Q[%\\d%*[^()])%r'

	if get(h,'ignore_unmatched',0) && !get(h,'show_all_lines',0)
		setlocal efm+=%-Q%*[^()]
		setlocal efm+=%-G%.%#
	endif
	
endfunction

" IgnoreWarnings -  parses g:LASU_IgnoredWarnings for message customization 
function! tex#efm#ignore_warnings()

	let i = 1

	let efm_h = base#varget('tex_efm',{})

	let iglev = str2nr( get(efm_h,'ignore_level','100' ) )

	let iw_a = base#varget('tex_efm_ignored_warnings','')
	let iw   = join(iw_a,"\n")

	while base#strntok(iw, "\n", i) != '' && i <= iglev

		let warningPat = base#strntok(iw, "\n", i)
		let warningPat = escape(substitute(warningPat, '[\,]', '%\\\\&', 'g'), ' ')
		exe 'setlocal efm+=%-G%.%#' .  warningPat .'%.%#'
		let i = i + 1

	endwhile

endfunction

