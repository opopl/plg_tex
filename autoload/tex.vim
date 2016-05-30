
fun! tex#texdoc(...)

  let topic=a:1

  let lines= base#splitsystem('texdoc -l -I ' . topic )

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
    \ 'startopt'    : '',
    \ 'header'      : "Available file are: ",
    \ 'numcols'     : 1,
    \ 'bottom'      : "Choose file by number: ",
    \ })

  let ext=fnamemodify(file,':e')

  if ext == 'html'
    call system(g:htmlbrowser . " " . file )
  elseif ext == 'pdf'
    call system(base#pdfviewer() . " " . file )
  else
    call base#fileopen(file)
  endif

endf


fun! tex#insert(env,...)

  let env=a:env

  let lines=[]

  let envs = { 
		\ 'tab' : base#qw('table longtable tabular'),
  		\ }
  let opts = {
	\ 'tabular' : { 'center' : 1 }
	  \ }

  if env == ''
  elseif env == 'sum'
    let lowlim   = input("Lower limit:",'')
    let uplim    = input("Upper limit:",'')

    call add(lines,'\sum_{'.lowlim.'}^{'.uplim.'}')

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

  elseif env == '\selectlanguage'

	let language=input('Language:','russian')
	call add(lines,'\selectlanguage{'.language.'}')

  elseif env == '\iflanguage'

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

  elseif env == '\usepackage'
	let packopts=base#var('tex_packopts')

	let pack = input('Package name:','','custom,tex#complete#packs')

	let opts = input('Package options:',get(packopts,pack,'') )

	let ostr = ''
	if strlen(opts)
		let ostr = '['.opts.']'
	endif

	call add(lines,'\usepackage'.ostr.'{'.pack.'}')

  elseif env == '\InputIfFileExists'

	let file=input('File name:','')
	call add(lines,'\InputIfFileExists{'.file.'}{}{}')

  elseif env == '\makeatletter'

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

    let ncols=input("Number of columns:",'2')
    let nrows=input("Number of rows:",'2')
    let tabpos=input("Table position:",'[ht]')

	if env == 'table'
		let opts['tabular']['center'] = input('Center tabular env?(1/0):',opts['tabular']['center'])
	endif

    let colwidth=string(1.0/ncols) . '\textwidth'

	let cw = 'p{' . colwidth . '}'

    let colsep='|'
    let args='{' . colsep 
				\	. repeat( '\cw' . colsep, ncols ) 
				\	. '}'

	let headers=[]
	for icol in base#listnewinc(0,ncols-1,1)
		call add(headers,input('Header #' . icol . ':',''))
	endfor
	let samplerow=join(map(base#listnew(ncols),"'" . '<++>' . "'"),' & ') . ' \\'

	call add(lines,'\def\cw{'.'p{' . colwidth . '}'.'}')
	call add(lines,' ')

	if env == 'longtable'

	    call add(lines,'\begin{longtable}' . args)
	    call add(lines,'\hline\\')
	    call add(lines,join(headers,' & ') . ' \\')
	    call add(lines,'\hline\\')
	
		for irow in base#listnewinc(0,nrows-1,1)
	    	call add(lines,samplerow)
		endfor
	
	    call add(lines,'\hline')
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

function! tex#init ()
	call base#plg#loadvars('tex')
endfunction
