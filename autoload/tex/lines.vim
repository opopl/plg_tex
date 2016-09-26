
function! tex#lines#join_headers (headers,...)
  let headers = a:headers
  let lines=[]

  let ref_def = { 'join_mode' : 'single_row' }
  let ref = get(a:000,0,ref_def)

  let jmode = get(ref,'join_mode','single_row')
  if  jmode == 'single_row'
    call add(lines,join(headers,' & ') . ' \\')
  elseif  jmode == 'split'
    let i=1
    let n_h=len(headers)

    for h in headers
			if i == n_h
      	call add(lines,h .' %'.i)
			else
      	call add(lines,h .' & %'.i)
			endif
      let i+=1
    endfor
    call add(lines,'\\')
  endif

  return lines

endf

function! tex#lines#envs_sec (env,...)

    let env   = a:env
    let lines = []
    let iopts = get(a:000,0,{})

		let sec   = get(iopts,'sec','')
		let prm   = get(iopts,'prompt',1)

		let base#opt#save('prompt')

    let sec     = base#prompt('Sectioning Command sec:',sec)
		let sec_tex = tex#escape(sec)

    let lab     = base#prompt('Label:',sec)

    let clp 		= base#prompt('Clearpage? (1/0):',0)
    if clp | call add(lines,'\clearpage') | endif

    call add(lines,'\'.env.'{'.sec_tex.'}')
    call add(lines,'\label{sec:'.lab.'}')

		let base#opt#restore('prompt')

		return lines

endf


function! tex#lines#envs_tab (env,...)

    let env   = a:env
    let lines=[]

    let iopts = get(a:000,0,{})

    let ncols  = get(iopts,'ncols',2)
    let nrows  = get(iopts,'nrows',10)
    let tabpos = get(iopts,'tabpos','[ht]')

    let headers_dict = get(iopts,'headers_dict',{})
    let headers_list = get(iopts,'headers_list',[])

    let header_opts = get(iopts,'header_opts',{})

    let rows_h       = get(iopts,'rows_h',[])
    let rows_h_given = has_key(iopts,'rows_h') ? 1 : 0

    let ncols  = base#prompt("Number of columns:",ncols)
    let nrows  = base#prompt("Number of rows:",nrows)
    let tabpos = base#prompt("Table position:",'[ht]')

    if env == 'table'
      let iopts['tabular']['center'] = base#prompt('Center tabular env? (1/0):',iopts['tabular']['center'])
    endif

    let colwidth_def = string(1.0/ncols)
    let cwcode       = colwidth_def . '\textwidth'

    let colnums = base#listnewinc(1,ncols,1)

    let cwids={
      \ 1 : 'one',
      \ 2 : 'two',
      \ 3 : 'three',
      \ 4 : 'four',
      \ 5 : 'five',
      \ 6 : 'six',
      \ 7 : 'seven',
      \ 8 : 'eight',
      \ 9 : 'nine',
      \ 10 : 'ten',
      \ }
    let column_widths=[]
    let column_w_codes=[]
    let column_w_names=[]

		let cws=get(iopts,'colwidths',{})

    for ncol in colnums
			let colwidth=get(cws,ncol,colwidth_def)

      let cwi     = base#prompt('Column '.ncol. ' width (in terms of \textwidth):',colwidth)
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
      let h = get(headers_dict,icol,'')

      if !strlen(h)
        let h = get(headers_list,icol,'')
      endif

      let h = base#prompt('Header #' . icol . ':',h)
      if !strlen(h)
          let h = '<+Header'.icol.'+>'
      endif
      call add(headers,h)
    endfor

		let samplerow=tex#env#tab#samplerow({ 'ncols' : ncols })

		if get(iopts,'each_row_hline')
			let samplerow.='\hline'
		endif

		if get(iopts,'each_row_delim')
			"let samplerow.=repeat('-',50)
		endif

    for ncol in colnums
      let cwc=get(column_w_codes,ncol-1,'p{0.1\textwidth}')
      call add(lines,'\def\cw'.get(cwids,ncol,'').'{'.cwc.'}')
    endfor

    call add(lines,' ')

"""texlines_longtable
  if env == 'longtable'

      call add(lines,'\begin{longtable}' . args)
      call add(lines,'\toprule')

      call extend(lines,tex#lines#join_headers(headers,header_opts))

      call add(lines,'\midrule')
  
      for irow in base#listnewinc(0,nrows-1,1)
          call add(lines,samplerow)
      endfor
  
      call add(lines,'\bottomrule')
      call add(lines,'\end{longtable}')
      call add(lines,' ')

"""texlines_table
  elseif env == 'table'

      call add(lines,'\begin{table}'.tabpos)

	    if iopts['tabular']['center']
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

	    if iopts['tabular']['center']
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

  return lines
        
endfunction
