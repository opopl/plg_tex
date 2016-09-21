
fun! tex#tab(...)
    return ' '
endf

fun! tex#show(...)
  let aa=a:000
  let opt = get(aa,0,'')

  if !len(opt)
    let opt=input('TEXSHOW option:','','custom,tex#complete#texshow')
  endif

  let lines=[]

  let class = input('Document Class:','article','custom,tex#complete#documentclass')

  call add(lines,'\nonstopmode')
  call add(lines,'\documentclass{'.class.'}')

  call add(lines,'\show'.opt)
  "call add(lines,'\begin{document}')
  "call add(lines,'\end{document}')

  let f = tempname()
  call writefile(lines,f)

  let cmd = 'pdflatex '.f
  call base#sys({ "cmds" : [cmd], 'skip_errors' : 1 })

  let olines =  base#var('sysout')
  let y=0
  let z=0
  let r=[]
  for l in olines
    if l =~ 'l.\d\+'
      let y=0
      let z=0
      continue
    endif

    if y && (l=~'^->')
      let z=1
      let l = substitute(l,'^->','','g')
      call add(r,l)
      continue
    endif
    if z | call add(r,l) | endif

    if l =~ '^>'
      let y=1
      "call add(r,l)
    else
      continue
    endif
  endfor
  let ans=join(r,'')

  split
  enew
  set modifiable
  call append(line('.'),ans)
  set buftype=nofile

endf

fun! tex#run(...)
  let aa=a:000
  let opt = get(aa,0,'')

  if !len(opt)
    let opt=input('TEXRUN option:','','custom,tex#complete#texrun')
  endif

  if ! base#inlist(&ft,base#qw('tex plaintex'))
    call base#warn({ 'text' : 'Should be a TeX file'})
    return
  endif

  if opt =~ 'thisfile'
    let file=expand('%:p')
    if opt == 'thisfile_pdflatex'
      let target = expand('%:p:t')
      let texexe = input('TeX exe:','pdflatex')

      let outdir = input('TeX output dir:',expand('%:p:r'))

      let texmode = input('TeX mode:','nonstopmode','custom,tex#complete#texmodes')

      let texopts='\ -file-line-error\ -interaction=' . texmode
          \ .'\ -output-directory='.outdir

      let pdffile = fnamemodify(target,':p:t:r') . '.pdf'
      let pdffile = base#file#catfile([ outdir, pdffile ])

      if filereadable(pdffile)
        let d = input('PDF file already exists, delete? (1/0):',1)
        if d
          call delete(pdffile)
        endif
      endif

      call base#cdfile()

      exe 'setlocal makeprg='.texexe.'\ '.texopts.'\ '.target 

      call tex#efm#latex()

      if base#inlist( texmode,base#qw('nonstopmode batchmode') )
        exe 'silent make!'
      elseif texmode == 'errorstopmode'
        exe 'make!'
      endif

      if filereadable(pdffile)
          let v = input('View created PDF file? (1/0):',1)
          if v
            call base#pdfview(pdffile)
          endif
      else
          echo 'Output PDF File does NOT exist:'
          echo ' '.pdffile
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
  let lines = tex#lines(env,{ 'prompt' : 1 })

  call append(line('.'),lines)
endf

function! tex#lines (env,...)
  let env   = a:env
  let lines = []

  let iopts = get(a:000,0,{})

  call base#opt#save('prompt')
  let prompt = get(iopts,'prompt',0)

  call base#opt#set('prompt',prompt)

  let envs = { 
    \ 'tab' : base#qw('table longtable tabular'),
    \ 'sec' : base#qw('chapter section subsection subsubsection paragraph'),
    \ 'list' : base#qw('enumerate itemize description')
    \ }

  let cmds = { 
      \ 'plaintex' : base#qw('begingroup leaders')
    \ }
  let opts = {
    \ 'tabular' : { 'center' : 1 },
    \ 'section' : {},
  \ }

  let tfiles = base#varget('tex_texfiles',{})
  let ie     = get(tfiles,'insert',[])

  if base#inlist(env,ie)
    let f = base#qw#catpath('plg','tex data tex insert '.env.'.tex')
    if filereadable(f)
      call extend(lines,readfile(f))
    endif
  endif

  if env == ''

  elseif env == 'url'
    let url   = base#prompt("URL:",'<+URL+>')
    call add(lines,'\url{'.url.'}')

  elseif env == 'rule'

    let raiseheight = base#prompt('Raise height:','<+RaiseHeight+>')
    let width       = base#prompt('Width:','<+Width+>')
    let thickness   = base#prompt('Thickness:','<+Thickness+>')

    let s = '\rule['.raiseheight.']{'.width.'}{'.thickness.'}'

    call add(lines,s)

  elseif base#inlist(env,envs.list)
    let ni=base#prompt('Number of items in a list:',5)

    call add(lines,'\begin{'.env.'}')
    if ni>0
      for i in base#listnewinc(0,ni-1,1)
        call add(lines,tex#tab().'\item <++>')
      endfor
    endif
    call add(lines,'\end{'.env.'}')

  elseif env == 'vspace'
    let x=base#prompt('vertical space width:','0.5cm')
    call add(lines,'\vspace{'.x.'}')

  elseif env == 'newcommand'

"\newcommand{cmd}[args][default]{definition}
    let s = '\newcommand{'.cmd.'}['.args.']['.default.']{'.definition.'}'

    let cmd     = base#prompt('Command:','')
    let args    = base#prompt('Number of Arguments:','')
    let default = base#prompt('Default argument values:','')
    let definition = base#prompt('Definition:','')

    call add(lines,s)

  elseif base#inlist(env,base#qw('titlepage'))

    call add(lines,'\begin{'.env.'}')
    call add(lines,'<++>')
    call add(lines,'\end{'.env.'}')

  elseif base#inlist(env,cmds.plaintex)
    let lines = tex#insert#plaintex(env)

  elseif base#inlist(env,envs.sec)

    let title = base#prompt('Title:','')
    let lab   = base#prompt('Label:',title)
  
    let clp = base#prompt('Clearpage? (1/0):',0)
    if clp | call add(lines,'\clearpage') | endif

    call add(lines,'\'.env.'{'.title.'}')
    call add(lines,'\label{'.lab.'}')

  elseif env == 'href'

    let url   = base#prompt("URL:",'<+url+>')
    let title = base#prompt("Title:",'<+title+>')

    call add(lines,'\href{'.url.'}{'.title.'}')

  elseif env == 'multicolumn'

    let cols = base#prompt("Number of columns:",'')
    let pos  = base#prompt("Position:",'')
    let text = base#prompt("Text:",'')

    call add(lines,'\hline\\')
    call add(lines,'\multicolumn{'.cols.'}{'.pos.'}{'.text.'} \\') 
    call add(lines,'\hline\\')

  elseif env == 'tikzpicture'
    call add(lines,'\begin{tikzpicture}')
    call add(lines,'\end{tikzpicture}')

  elseif env == '@ifpackageloaded'
    let pack=base#prompt('Package:','','custom,tex#complete#texpackages')
    let code=base#prompt('Code:','<+Code+>')

    call add(lines,'\@ifpackageloaded{'.pack.'}{'.code.'}')

  elseif env == 'selectlanguage'

    let language=base#prompt('Language:','russian')
    call add(lines,'\selectlanguage{'.language.'}')

  elseif env == 'iflanguage'

	  let language=base#prompt('Language:','russian')
	  let true=base#prompt('True:','')
	  let false=base#prompt('False:','')

  call add(lines,'\iflanguage{'.language.'}{'.true.'}{'.false.'}')

"""texlines_ifthenelse
  elseif env == 'ifthenelse'

  let test       = base#prompt('Test:','\equal{<++>}{<++>}')
  let thenclause = base#prompt('Then clause:','<++>')
  let elseclause = base#prompt('Else clause:','<++>')

  call add(lines,'\ifthenelse{'.test.'}{'. thenclause .'}{'.elseclause .'}')

"""texlines_equal
  elseif env == 'equal'

    let one       = base#prompt('#1: ','<++>')
    let two       = base#prompt('#2: ','<++>')

    call add(lines,'\equal{'. one .'}{'.two .'}')

  elseif env == 'leftright'

    call add(lines,'\left(<++>\right)')

  elseif env == 'usepackage'
    let packopts=base#varget('tex_packopts',{})
  
    let pack = get(iopts,'pack','<+Package+>')

    let popts = ''
    let popts = get(packopts,pack,'')
    let popts = get(iopts,'popts',popts)

    let pack = base#prompt('Package name:',pack,'custom,tex#complete#texpackages')
  
    let popts = base#prompt('Package options:',popts )
  
    let ostr = ''
    if strlen(popts)
      let ostr = '['.popts.']'
    endif
  
    call add(lines,'\usepackage'.ostr.'{'.pack.'}')

  elseif env == 'InputIfFileExists'

    let file=base#prompt('File name:','<+File+>')
    call add(lines,'\InputIfFileExists{'.file.'}{}{}')

  elseif env == 'makeatletter'

    call add(lines,'\makeatletter')
    call add(lines,'<++>')
    call add(lines,'\makeatother')

  elseif env == 'frac'

    let nom   = base#prompt("Nominator:",'')
    let denom = base#prompt("DeNominator:",'')

    call add(lines,'\frac{'.nom.'}{'.denom.'}')

  elseif env == 'ParDer'

    let nom   = base#prompt("Nominator:",'')
    let denom = base#prompt("DeNominator:",'')

    call add(lines,'\ParDer{'.nom.'}{'.denom.'}')

"""texlines_tabs
  elseif base#inlist(env,envs.tab)

    let ncols = get(iopts,'ncols',2)
    let nrows = get(iopts,'nrows',10)
    let tabpos = get(iopts,'tabpos','[ht]')

    let headers_dict = get(iopts,'headers_dict',{})
\multido{\i=0+1}{10}{<++>}
    let headers_list = get(iopts,'headers_list',[])

    let ncols  = base#prompt("Number of columns:",ncols)
    let nrows  = base#prompt("Number of rows:",nrows)
    let tabpos = base#prompt("Table position:",'[ht]')

    if env == 'table'
      let opts['tabular']['center'] = base#prompt('Center tabular env?(1/0):',opts['tabular']['center'])
    endif

    let colwidth = string(1.0/ncols)
    let cwcode   = colwidth . '\textwidth'

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

    for ncol in colnums
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
    let samplerow=join(map(base#listnew(ncols),"'" . '<++>' . "'"),' & ') . ' \\'

    for ncol in colnums
      let cwc=get(column_w_codes,ncol-1,'p{0.1\textwidth}')
      call add(lines,'\def\cw'.get(cwids,ncol,'').'{'.cwc.'}')
    endfor

    call add(lines,' ')

"""texlines_longtable
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

"""texlines_table
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

 elseif env == '@startsection'

     let hlines=[]
     call add(hlines,'%\@startsection{name}{level}{indent}{beforeskip}'
                 \  . '{afterskip}{style}*[altheading]{heading}')

     let name       = base#prompt('name (e.g. subsection):','subsection')
     let level      = base#prompt('level (Depth level):','0')
     let indent     = base#prompt('indent ( Indentation of heading from left margin:','0mm')
     let beforeskip = base#prompt('beforeskip:','-\baselineskip')
     let afterskip  = base#prompt('afterskip:','.5\baselineskip')
     let style      = base#prompt('style:','\normalfont\normalsize\bfseries')

     call add(lines,'--------------')
     call extend(lines,hlines)
     call add(lines,'--------------')

     call add(lines,'\@startsection{'   . name    . '}{' . level . '}{' . indent . '}%')
     call add(lines,'       {' . beforeskip . '}%')
     call add(lines,'       {' . afterskip  . '}%')
     call add(lines,'       {' . style          . '}%')

"""ft_tex_fontsize
 elseif env == '\fontsize'
   let size=base#prompt('Font size:',14)
   let skip=base#prompt('Baselineskip multiplier:',1.2)

   call add(lines,'\fontsize{'.size.'}{'.size*skip.'}')

  endif

  if !len(lines)
    let sub = 'tex#insertcmd#'.env
    try
      exe 'let lines='.sub.'(iopts)'
    catch /.*/
      call base#warn({ 'text' : 'No method for TeX inserting: ' . sub})
    endtry
  endif

  call base#opt#restore('prompt')

  return lines
  
endfunction
"""endof_tex_lines

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

  call tex#init#au()

  let tdir   = base#qw#catpath('plg','tex data tex insert')
  let tfiles={}

  let tfiles.insert = base#find({
    \ "dirs"    : [tdir],
    \ "qw_exts" : 'tex',
    \ "relpath" : 1,
    \ 'subdirs' : 1,
    \ 'rmext' : 1,
    \ })
  call base#varset('tex_texfiles',tfiles)
  let ie = base#varget('tex_insert_entries',[])
  call extend(ie,tfiles.insert)
  let ie = sort(ie)

  call base#varset('tex_insert_entries',ie)

endfunction

function! tex#escape (text)
 let text=a:text
 for sym in base#varget('tex_escape_sym',[]) 
    let text=substitute(text,'\([\' . sym . ']\)','\\\1','g')
 endfor

 return text
endfunction
