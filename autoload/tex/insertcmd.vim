
function! tex#insertcmd#booktabs (...)
		let lines =[]

		call add(lines,'\toprule')
		call add(lines,'\midrule')
		call add(lines,'\bottomrule')

		return lines
endfunction

function! tex#insertcmd#ad (...)
		let lines =[]

		let url   = input('Ad url:','')
		let price = input('Ad price:','')

		return lines
endfunction

function! tex#insertcmd#multido (...)
		let lines =[]

		let var   = input('Variable name:','\i')
		let start = input('Start value:',0)
		let inc   = input('Increment:',1)
		let rep   = input('Repetitions:',10)

		let code = input('Code:','')

    call add(lines,'\multido{'.var.'='.start.'+'.inc.'}{'.rep.'}{'.code.'}')

		return lines
endfunction

function! tex#insertcmd#sum ()
		let lines =[]

    let lowlim   = input("Lower limit:",'')
    let uplim    = input("Upper limit:",'')

    call add(lines,'\sum_{'.lowlim.'}^{'.uplim.'}')
		return lines
endfunction

function! tex#insertcmd#addcontentsline ()
		let lines =[]

		let secname = input('Sectioning command:','chapter')
		let tocid   = input('Toc ID:','toc')
		let name    = input('Entry name:','')

		call add(lines,'\addcontentsline{'.tocid.'}{'.secname.'}{'.name.'}')

		return lines
endfunction

function! tex#insertcmd#babel ()
		let lines =[]

		let opts_fenc = input('fontenc options:','OT1,T2A,T3')
		let opts_ienc = input('inputenc options:','utf8')
		let langs     = input('babel languages:','english,ukrainian,russian')

		call add(lines,'\usepackage['.opts_fenc.']{fontenc}')
		call add(lines,'\usepackage['.opts_ienc.']{inputenc}')
		call add(lines,'\usepackage['.langs.']{babel}')

		return lines
endfunction

function! tex#insertcmd#documentclass ()
		let lines =[]

		let dclass = input('Documentclass:','report','custom,tex#complete#documentclass')

    call add(lines,'\documentclass{'.dclass.'}')
	
		return lines
endfunction

function! tex#insertcmd#preamble ()

endfunction

function! tex#insertcmd#toc ()
		let lines = []

    call add(lines,'%%% TOC %%% ')
    call add(lines,'\phantomsection')
    call add(lines,' ')
    call add(lines,'\hypertarget{toc}{}')
    call add(lines,'\bookmark[dest=toc,rellevel=1,keeplevel=1]{\contentsname}')
    call add(lines,' ')
    call add(lines,'\addcontentsline{toc}{chapter}{\contentsname}')
    call add(lines,' ')
    call add(lines,'\tableofcontents')
    call add(lines,'\newpage')
		call add(lines,'%%% ENDTOC %%% ')

		return lines
endfunction

function! tex#insertcmd#lof ()
		let lines = []

    call add(lines,'%%% LOF %%% ')
    call add(lines,'\phantomsection')
    call add(lines,' ')
    call add(lines,'\hypertarget{lof}{}')
    call add(lines,'\bookmark[dest=toc,rellevel=1,keeplevel=1]{\listfigurename}')
    call add(lines,' ')
    call add(lines,'\addcontentsline{toc}{chapter}{\listfigurename}')
    call add(lines,' ')
    call add(lines,'\listoffigures')
    call add(lines,'\newpage')
		call add(lines,'%%% ENDLOF %%% ')

		return lines
endfunction

function! tex#insertcmd#figure ()

	let lines =[]

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

		return lines
endfunction

function! tex#insertcmd#pap_tabdat (...)
  let env == 'pap_tabdat'

	let lines =[]

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

		return lines

endfunction
