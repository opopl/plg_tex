
fun! tex#insert(env,...)

  let env=a:env

  let lines=[]

"""longtable
  if env == ''
  elseif env == 'sum'
    let lowlim   = input("Lower limit:",'')
    let uplim    = input("Upper limit:",'')

    call add(lines,'\sum_{'.lowlim.'}^{'.uplim.'}')

  elseif env == 'leftright'

    call add(lines,'\left(<++>\right)')

  elseif env == 'frac'

    let nom   = input("Nominator:",'')
    let denom = input("DeNominator:",'')

    call add(lines,'\frac{'.nom.'}{'.denom.'}')

  elseif env == 'longtable'

    let ncols=input("Number of columns:",'2')
    let nrows=input("Number of rows:",'2')

    let colwidth=string(1.0/ncols) . '\textwidth'
    let colsep='|'
    let args='{' . colsep 
				\	. repeat( 'p{' . colwidth . '}' . colsep, ncols ) 
				\	. '}'

	let headers=[]
	for icol in base#listnewinc(0,ncols-1,1)
		call add(headers,input('Header #' . icol . ':',''))
	endfor
	let samplerow=join(map(base#listnew(ncols),"'" . '<++>' . "'"),' & ') . ' \\'

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

"""table
	elseif env == 'table'
	elseif env == 'tabular'

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
