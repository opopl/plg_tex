
function! tex#insertcmd#booktabs (...)
		let lines =[]

		call add(lines,'\toprule')
		call add(lines,'\midrule')
		call add(lines,'\bottomrule')

		return lines
endfunction

function! tex#insertcmd#tex4ht_frames_two (...)
		let lines =[]

		call add(lines,base#qw#rf('tex','data tex insert tex4ht_frames_two.tex'))
	
		return lines
endfunction

function! tex#insertcmd#tex4ht_preamble (...)
		let lines =[]

		call add(lines,'\Preamble{html,frames,4,index=2,next,charset=utf-8,javascript}')

		return lines
endfunction

function! tex#insertcmd#horizontal_line (...)
		let lines =[]

		call add(lines,'\noindent\rule{\textwidth}{0.4pt}')

		return lines
endfunction

function! tex#insertcmd#tex4ht_cfg (...)
		let lines =[]

		call add(lines,'  ')
		call extend(lines,tex#lines('tex4ht_preamble'))
		call add(lines,'  ')
		call extend(lines,tex#lines('tex4ht_frames_two'))
		call add(lines,'  ')
		call add(lines,'\begin{document}')
		call add(lines,'  ')
		call add(lines,'\EndPreamble')
		call add(lines,'  ')

		return lines
endfunction

function! tex#insertcmd#envi (...)

	let env = get(a:000,0,'')
	if !strlen(env)
		let env = base#prompt('Environment:',env)
	endif

	let lines = []

	call add(lines,' ')
	call add(lines,'\begin{'.env.'}')
	call add(lines,' ')
	call add(lines,'\end{'.env.'}')
	call add(lines,' ')

	return lines

endfunction

function! tex#insertcmd#renewcommand (...)
		let lines =[]

		let cmd  = input('Command: ','')
		let code = input('Code: ','')

    call add(lines,'\renewcommand{'.cmd.'}{'.code.'}')

		return lines
endfunction

function! tex#insertcmd#fminipage (...)
		let lines =[]

    let width = input('fminipage width:','0.7\textwidth')

    call add(lines,'  ')
    call add(lines,'\begin{center}')
    call add(lines,'  \begin{fminipage}{'.width.'}')
    call add(lines,'  ')
    call add(lines,'  \end{fminipage}')
    call add(lines,'\end{center}')
    call add(lines,'  ')

		return lines

endfunction

function! tex#insertcmd#ad (...)
		let lines =[]

		let url   = base#prompt('Ad url:','')
		let price = base#prompt('Ad price:','')

		return lines
endfunction

function! tex#insertcmd#toc (...)
		let lines =[]

    call add(lines,'\tableofcontents')

		let cst   = base#prompt('Customize? (1/0):',0)

		"let url   = base#prompt('Ad url:','')

		return lines
endfunction

function! tex#insertcmd#lof (...)
		let lines =[]

		"let url   = base#prompt('Ad url:','')

		return lines
endfunction

function! tex#insertcmd#multirow (...)
		let lines =[]

		let l= '\multirow{<+nrows+>}[<+bigstruts+>]{<+width+>}[<+fixup+>]{<+text+>}'
    call add(lines,l)
		
		return lines
endfunction

function! tex#insertcmd#multido (...)
		let lines =[]

		let var   = base#prompt('Variable name:','\i')
		let start = base#prompt('Start value:',0)
		let inc   = base#prompt('Increment:',1)
		let rep   = base#prompt('Repetitions:',10)

		let code  = base#prompt('Code:','<++>')

    call add(lines,'\multido{'.var.'='.start.'+'.inc.'}{'.rep.'}{'.code.'}')

		return lines
endfunction

function! tex#insertcmd#sum (...)
		let lines =[]

    let lowlim   = base#prompt("Lower limit:",'')
    let uplim    = base#prompt("Upper limit:",'')

    call add(lines,'\sum_{'.lowlim.'}^{'.uplim.'}')
		return lines
endfunction

function! tex#insertcmd#addcontentsline (...)
		let lines =[]

		let secname = base#prompt('Sectioning command:','chapter')
		let tocid   = base#prompt('Toc ID:','toc')
		let name    = base#prompt('Entry name:','')

		call add(lines,'\addcontentsline{'.tocid.'}{'.secname.'}{'.name.'}')

		return lines
endfunction

function! tex#insertcmd#babel (...)
		let lines =[]

		let opts_fenc = base#prompt('fontenc options:','OT1,T2A,T3')
		let opts_ienc = base#prompt('base#promptenc options:','utf8')

		let langs     = base#prompt('babel languages:','english,ukrainian,russian')

		call add(lines,'\usepackage['.opts_fenc.']{fontenc}')
		call add(lines,'\usepackage['.opts_ienc.']{inputenc}')
		call add(lines,'\usepackage['.langs.']{babel}')

		return lines
endfunction

function! tex#insertcmd#documentclass ()
		let lines =[]

		let dclass = base#prompt('Documentclass:','report','custom,tex#complete#documentclass')

    call add(lines,'\documentclass{'.dclass.'}')
	
		return lines
endfunction

function! tex#insertcmd#preamble (...)

endfunction

function! tex#insertcmd#toc (...)
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

function! tex#insertcmd#lof (...)
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

function! tex#insertcmd#figure (...)

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

function! tex#insertcmd#fig_custom (...)

		let lines =[]

		let fname   = input('File name:','')
		let caption = input('Caption:','')
		let label   = input('Label:','fig:'.fname)
		
		let width   = input('Width:','0.7')

		let cmd = input('Graphics inclusion command:','\PrjPicW{' . fname . '}{' . width . '}' )
	
		let rn = input('Renew thefigure:','')
		if strlen(rn)
			call add(lines,' ')
			call add(lines,'\renewcommand{\thefigure}{'.rn.'}')
			call add(lines,' ')
		endif

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
