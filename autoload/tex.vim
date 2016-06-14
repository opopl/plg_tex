
fun! tex#tab(...)
		return ' '
endf

fun! tex#run(...)
	let aa=a:000
	let opt = get(aa,0,'')

	if !len(opt)
		let opt=input('TEXRUN option:','','custom,tex#complete#texrun')
	endif

	if opt =~ 'thisfile'
		let file=expand('%:p')
		if opt == 'thisfile_pdflatex'
			let target = expand('%:p:t')
			let texexe = 'pdflatex'

			let texmode = input('TeX mode:','nonstopmode','custom,tex#complete#texmodes')

			let texopts=' -file-line-error\ -interaction=' . texmode

			call base#cdfile()

			exe 'setlocal makeprg='.texexe.'\ ' .texopts.'\ '.target 

			call tex#efm#latex()

			 if index([ 'nonstopmode','batchmode' ],texmode) >= 0 
			   exe 'silent make!'
			 elseif texmode == 'errorstopmode'
			   exe 'make!'
			 endif

		endif

	endif
endf

fun! tex#texdoc(...)

	let aa=a:000
  let topic=get(aa,0,'')
  if !len(topic)
  	let topic=input('TEXDOC topic:','','custom,tex#complete#texdoc')
  endif

	let opts='-l -I '
	let opts=input('texdoc command-line options:',opts)

  let lines = base#splitsystem('texdoc '.opts.topic )

	if !len(opts) |  return | endif

  let desc={}
  let files=[]

  let num=0
  for line in lines

    if line =~ '^\s*\d\+'
      let file=matchstr(line,'\d\+\s\+\zs\S\+\ze\s*$')
      call add(files,file)
      let num+=1
    elseif line =~ '\s*='
      let desc[num]=matchstr(line,'^\s*=\zs.*\ze$')
    endif

  endfor

  let file=base#getfromchoosedialog({ 
    \ 'list'        : files,
    \ 'desc'        : desc,
    \ 'startopt'    : get(files,0,''),
    \ 'header'      : "Available file are: ",
    \ 'numcols'     : 1,
    \ 'bottom'      : "Choose file by number: ",
    \ })

  let ext=fnamemodify(file,':e')

  if ext == 'html'
    call system(g:htmlbrowser . " " . file )
  elseif ext == 'pdf'
    call base#pdfview(file,{ "cdfile" : 1 })
  else
    call base#fileopen(file)
  endif

endf

fun! tex#insert(env,...)

  let env   = a:env
  let lines = []

  let envs = { 
		\ 'tab' : base#qw('table longtable tabular'),
		\ 'sec' : base#qw('chapter section subsection subsubsection paragraph'),
		\ 'list' : base#qw('enumerate itemize description')
 		\ }

  let cmds = { 
  		\	'plaintex' : base#qw('begingroup leaders')
		\	}
  let opts = {
	\ 'tabular' : { 'center' : 1 },
  	\ 'section' : {},
	\ }

  if env == ''
  elseif env == 'sum'
    let lowlim   = input("Lower limit:",'')
    let uplim    = input("Upper limit:",'')

    call add(lines,'\sum_{'.lowlim.'}^{'.uplim.'}')

  elseif env == 'url'
    let url   = input("URL:",'')
    call add(lines,'\url{'.url.'}')

  elseif env == 'rule'

		let s = '\rule['.raiseheight.']{'.width.'}{'.thickness.'}'

		let raiseheight = input('Raise height:','')
		let width       = input('Width:','')
		let thickness   = input('Thickness:','')

		call add(lines,s)

  elseif base#inlist(env,envs.list)
		let ni=input('Number of items in a list:',5)

		call add(lines,'\begin{'.env.'}')
		if ni>0
			for i in base#listnewinc(0,ni-1,1)
				call add(lines,tex#tab().'\item <++>')
			endfor
		endif
		call add(lines,'\end{'.env.'}')

  elseif env == 'vspace'
		let x=input('vertical space width:','0.5cm')
		call add(lines,'\vspace{'.x.'}')

  elseif env == 'newcommand'

"\newcommand{cmd}[args][default]{definition}
		let s = '\newcommand{'.cmd.'}['.args.']['.default.']{'.definition.'}'

		let cmd     = input('Command:','')
		let args    = input('Number of Arguments:','')
		let default = input('Default argument values:','')
		let definition = input('Definition:','')

		call add(lines,s)

  elseif base#inlist(env,base#qw('titlepage'))

    call add(lines,'\begin{'.env.'}')
    call add(lines,'<++>')
	call add(lines,'\end{'.env.'}')

  elseif base#inlist(env,cmds.plaintex)
		let lines = tex#insert#plaintex(env)

  elseif base#inlist(env,envs.sec)

	let title = input('Title:','')
	let lab   = input('Label:',title)

	let clp = input('Clearpage? (1/0):',0)
	if clp | call add(lines,'\clearpage') | endif

    call add(lines,'\'.env.'{'.title.'}')
    call add(lines,'\label{'.lab.'}')

  elseif env == 'href'

    let url   = input("URL:",'')
    let title = input("Title:",'')

    call add(lines,'\href{'.url.'}{'.title.'}')

  elseif env == 'multicolumn'

    let cols = input("Number of columns:",'')
    let pos  = input("Position:",'')
    let text = input("Text:",'')

    call add(lines,'\hline\\')
	call add(lines,'\multicolumn{'.cols.'}{'.pos.'}{'.text.'} \\') 
    call add(lines,'\hline\\')

  elseif env == 'tikzpicture'
	call add(lines,'\begin{tikzpicture}')
	call add(lines,'\end{tikzpicture}')

  elseif env == '@ifpackageloaded'
	let pack=input('Package:','','custom,tex#complete#texpackages')
	let code=input('Code:','')

	call add(lines,'\@ifpackageloaded{'.pack.'}{'.code.'}')

  elseif env == 'selectlanguage'

	let language=input('Language:','russian')
	call add(lines,'\selectlanguage{'.language.'}')

  elseif env == 'iflanguage'

	let language=input('Language:','russian')
	let true=input('True:','')
	let false=input('False:','')

	call add(lines,'\iflanguage{'.language.'}{'.true.'}{'.false.'}')

"""texinsert_ifthenelse
  elseif env == 'ifthenelse'

	let test       = input('Test:','\equal{<++>}{<++>}')
	let thenclause = input('Then clause:','<++>')
	let elseclause = input('Else clause:','<++>')

	call add(lines,'\ifthenelse{'.test.'}{'. thenclause .'}{'.elseclause .'}')

"""texinsert_equal
  elseif env == 'equal'

	let one       = input('#1: ','<++>')
	let two       = input('#2: ','<++>')
	call add(lines,'\equal{'. one .'}{'.two .'}')

  elseif env == 'leftright'

    call add(lines,'\left(<++>\right)')

  elseif env == 'usepackage'
	let packopts=base#var('tex_packopts')

	let pack = input('Package name:','','custom,tex#complete#texpackages')

	if exists("opts") | unlet opts | endif
	let opts = input('Package options:',get(packopts,pack,'') )

	let ostr = ''
	if strlen(opts)
		let ostr = '['.opts.']'
	endif

	call add(lines,'\usepackage'.ostr.'{'.pack.'}')

  elseif env == 'InputIfFileExists'

	let file=input('File name:','')
	call add(lines,'\InputIfFileExists{'.file.'}{}{}')

  elseif env == 'makeatletter'

	call add(lines,'\makeatletter')
	call add(lines,'<++>')
	call add(lines,'\makeatother')

  elseif env == 'frac'

    let nom   = input("Nominator:",'')
    let denom = input("DeNominator:",'')

    call add(lines,'\frac{'.nom.'}{'.denom.'}')

  elseif env == 'ParDer'

    let nom   = input("Nominator:",'')
    let denom = input("DeNominator:",'')

    call add(lines,'\ParDer{'.nom.'}{'.denom.'}')

"""longtable
"""table
"""tabular
  elseif base#inlist(env,envs.tab)

    let ncols  = input("Number of columns:",'2')
    let nrows  = input("Number of rows:",'2')
    let tabpos = input("Table position:",'[ht]')

		if env == 'table'
			let opts['tabular']['center'] = input('Center tabular env?(1/0):',opts['tabular']['center'])
		endif

  	let colwidth = string(1.0/ncols)
		let cwcode   = colwidth . '\textwidth'

		let colnums = base#listnewinc(1,ncols,1)

		let cwids={
			\	1 : 'one',
			\	2 : 'two',
			\	3 : 'three',
			\	4 : 'four',
			\	5 : 'five',
			\	6 : 'six',
			\	7 : 'seven',
			\	8 : 'eight',
			\	9 : 'nine',
			\	10 : 'ten',
			\	}
		let column_widths=[]
		let column_w_codes=[]
		let column_w_names=[]

		for ncol in colnums
			let cwi     = input('Column '.ncol. ' width (in terms of \textwidth):',colwidth)
			let cwidnum = get(cwids,ncol,'')
			let cwid    = '\cw'.cwidnum

			call add(column_widths,cwi)
			call add(column_w_codes,'p{'.cwi.'\textwidth}')
			call add(column_w_names,cwid)
		endfor

    let colsep = '|'
    let args   = '{' . colsep  . join(column_w_names, '|') . colsep . '}'

		let headers=[]
		for icol in colnums 
			call add(headers,input('Header #' . icol . ':',''))
		endfor
		let samplerow=join(map(base#listnew(ncols),"'" . '<++>' . "'"),' & ') . ' \\'

		for ncol in colnums
			let cwc=get(column_w_codes,ncol-1,'p{0.1\textwidth}')
			call add(lines,'\def\cw'.get(cwids,ncol,'').'{'.cwc.'}')
		endfor

		call add(lines,' ')

	if env == 'longtable'

	    call add(lines,'\begin{longtable}' . args)
	    call add(lines,'\toprule')
	    call add(lines,join(headers,' & ') . ' \\')
	    call add(lines,'\midrule')
	
		for irow in base#listnewinc(0,nrows-1,1)
	    	call add(lines,samplerow)
		endfor
	
	    call add(lines,'\bottomrule')
	    call add(lines,'\end{longtable}')
	    call add(lines,' ')

	elseif env == 'table'

	    call add(lines,'\begin{table}'.tabpos)


		if opts['tabular']['center']
	    	call add(lines,"\t".'\begin{center}')
		endif

	    call add(lines,"\t".'\begin{tabular}'.args)
	    call add(lines,join(headers,' & ') . ' \\')
	    call add(lines,'\hline\\')
	
		for irow in base#listnewinc(0,nrows-1,1)
	    	call add(lines,samplerow)
		endfor
	
	    call add(lines,'\hline')
	    call add(lines,"\t".'\end{tabular}')

		if opts['tabular']['center']
			call add(lines,"\t".'\end{center}')
		endif

	    call add(lines,'\end{table}')
	    call add(lines,' ')

	elseif env == 'tabular'

	    call add(lines,'\begin{tabular}'.args)
	    call add(lines,join(headers,' & ') . ' \\')
	    call add(lines,'\hline\\')
	
		for irow in base#listnewinc(0,nrows-1,1)
	    	call add(lines,samplerow)
		endfor
	
	    call add(lines,'\hline')
	    call add(lines,'\end{tabular}')

	endif

	elseif env == 'figure'

		let fname   = input('File name:','')
		let caption = input('Caption:','')
		let label   = input('Label:','fig:'.fname)

		let cmd = input('Graphics inclusion command:','\PrjPic{'.fname.'}')
	
		call add(lines,'\begin{figure}[ht]')
		call add(lines,'	\begin{center}')
		call add(lines,'		'.cmd )
		call add(lines,'	\end{center}')
		call add(lines,'	')
		call add(lines,'	\caption{'.caption.'}')
		call add(lines,'	\label{'.label.'}')
	    call add(lines,'\end{figure}')

"""pap_tabdat
  elseif env == 'pap_tabdat'

    let numcols=3
    let numrows=10

    if a:0
      let numcols=a:1
      if a:0 == 2 
        let numrows=a:2
      endif
    endif

    let sep='__'
    let width=10
    let cell=repeat(' ',width)


    let nrow=0

    call add(lines,'SEP')
    call add(lines,' ' . sep)
    call add(lines,'HEADER')
    call add(lines,'CAPTION')
    call add(lines,'LABEL')

    while nrow<numrows+1
      call add(lines,'ROW')
      let row=repeat(cell . sep,numcols)
      call add(lines,row)

      let nrow+=1
    endw

  endif

  call append(line('.'),lines)
endf

function! tex#kpsewhich (cmd)

  let cmd   = 'kpsewhich ' . a:cmd
  let lines = base#splitsystem(cmd)

  return join(lines,',')

endfunction

function! tex#init ()
  call base#plg#loadvars('tex')

  let texlive={
        \  'TEXMFDIST'  : tex#kpsewhich('--var-value=TEXMFDIST'),
        \  'TEXMFLOCAL' : tex#kpsewhich('--var-value=TEXMFLOCAL'),
        \  }
  call base#var('tex_texlive',texlive)

endfunction

