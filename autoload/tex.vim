

fun! tex#show(...)
  let aa=a:000
  let opt = get(aa,0,'')

  if !len(opt)
    let opt = input('TEXSHOW option:','','custom,tex#complete#texshow')
  endif

  let lines = []

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
  let aa  = a:000
  let opt = get(aa,0,'')

  if !len(opt)
    let opt = input('TEXRUN option:','','custom,tex#complete#texrun')
  endif

  if ! base#inlist(&ft,base#qw('tex plaintex'))
    call base#warn({ 'text' : 'Should be a TeX file'})
    return
  endif

    let file    = expand('%:p')
    let target  = expand('%:p:t')

    let tex_exe = 'pdflatex'

    if opt == ''

    elseif opt == 'evince_view_thisfile'
      call tex#pdf#view('','evince')

    elseif opt == 'okular_view_thisfile'
      call tex#pdf#view('','okular')
    
"""texrun_thisfile_pdflatex
    elseif opt == 'thisfile_tex'

      call base#varset('this',base#qw('pdflatex xelatex'))
      let tex_exe = input('tex_exe: ','','custom,base#complete#this')

      call base#cdfile()

      let pdf_file = fnamemodify(target,':p:t:r') . '.pdf'

      let tex_opts_a = [ 
        \ '-file-line-error',
        \ '-interaction=nonstopmode'
        \ ]
      let tex_opts = join(tex_opts_a, ' ')
      let cmd      = printf('%s %s %s',tex_exe,tex_opts,target)

      let start = localtime()

      let env = {
        \ 'start'  : start,
        \ 'target' : target,
        \ }

      function env.get(temp_file) dict
        call tex#run#thisfile_pdflatex_Fc(self,a:temp_file)
      endfunction

      let msg = printf('TEXRUN: %s',target)
      call base#rdw(msg,'LineNr')

      call asc#run({ 
        \ 'cmd' : cmd, 
        \ 'Fn'  : asc#tab_restore(env) 
        \ })

"""texrun_thisfile_pdflatex_prompt
    elseif opt == 'thisfile_pdflatex_prompt'
      let tex_exe = input('TeX exe:',tex_exe)

      let out_dir = input('TeX output dir:',expand('%:p:r'))

      let tex_mode = input('TeX mode:','nonstopmode','custom,tex#complete#texmodes')

      let tex_opts='\ -file-line-error\ -interaction=' . tex_mode
          \ .'\ -output-directory='.out_dir

      let pdffile = fnamemodify(target,':p:t:r') . '.pdf'
      let pdffile = base#file#catfile([ outdir, pdffile ])

      if filereadable(pdffile)
        let d = input('PDF file already exists, delete? (1/0):',1)
        if d
          call delete(pdffile)
        endif
      endif

      call base#cdfile()

      exe 'setlocal makeprg='. tex_exe .'\ ' . tex_opts.'\ ' . target 

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
endf

fun! tex#texht(...)

 if a:0
    let action=a:1
 else
    let actions = base#varget('tex_texht_actions',[])
    let action=base#getfromchoosedialog({ 
    \ 'list'        : actions,
    \ 'startopt'    : 'CfgNew',
    \ 'header'      : "Available TeXHT action are: ",
    \ 'numcols'     : 1,
    \ 'bottom'      : "Choose action by number: ",
    \ })
 endif

endf

fun! tex#texdoc(...)

  let aa    = a:000
  let topic = get(aa,0,'')

  if !len(topic)
    let topic=input('TEXDOC topic:','','custom,tex#complete#texdoc')
  endif

  let opts = '-l -I '
  let opts = input('texdoc command-line options:',opts)

  let lines = base#splitsystem('texdoc '.opts.topic )

  if !len(opts) |  return | endif

  let desc  = {}
  let files = []

  let num=0

  for line in lines
    if line =~ '^\s*\d\+'
      let file=matchstr(line,'\d\+\s\+\zs\S\+\ze\s*$')
      call add(files,file)
      let num+=1

    elseif line =~ '\s*='
      let desc[num] = matchstr(line,'^\s*=\zs.*\ze$')

    endif
  endfor

  let file = base#getfromchoosedialog({ 
    \ 'list'        : files,
    \ 'desc'        : desc,
    \ 'startopt'    : get(files,0,''),
    \ 'header'      : "Available file are: ",
    \ 'numcols'     : 1,
    \ 'bottom'      : "Choose file by number: ",
    \ })

  let ext = fnamemodify(file,':e')

  if ext == 'html'
    call system(g:htmlbrowser . " " . file )

  elseif ext == 'pdf'
    call base#pdfview(file,{ "cdfile" : 1 })

  else
    call base#fileopen(file)

  endif

endf

fun! tex#insert(...)
  let entry = get(a:000,0,'')

  let entries = base#varget('tex_insert_entries',[])

  let desc = base#varget('tex_desc_insert_entries',{})

  let fmt_call = 'call tex#lines_insert("%s")'

  let front = [
      \ 'Possible TEXINSERT entries: ' 
      \ ]

  let s:obj = { }
  function! s:obj.init (...) dict
  endfunction
  let Fc = s:obj.init

  call base#util#split_acts({
    \ 'act'      : entry,
    \ 'acts'     : entries,
    \ 'desc'     : desc,
    \ 'front'    : front,
    \ 'fmt_call' : fmt_call,
    \ 'Fc'       : Fc,
    \ })

endf

fun! tex#lines_insert(...)
  let entry = get(a:000,0,'')
  let lines = tex#lines(entry,{ 'prompt' : 1 })
  call append(line('.'),lines)
endf

"function! projs#bld#do (...)
  "let Fc = projs#fc#match_proj({ 'proj' : proj })
"endfunction

function! tex#act(start,end,...)
  let act = get(a:000,0,'')

  let acts = base#varget('tex_texact',[])

  let sub = 'tex#act#'.act

  call base#varset('tex_texact_start',a:start)
  call base#varset('tex_texact_end',a:end)

  let fmt_sub = 'tex#act#%s'
  let front = [
			\	printf('start: %s',a:start),
			\	printf('end: %s',a:end),
			\	'	',
      \ 'Possible TEXACT commands: ' 
      \ ]
  let desc = base#varget('tex_desc_TEXACT',{})

	let s:obj = {  }
	function! s:obj.init (...) dict
	endfunction
	let Fc = s:obj.init

  call base#util#split_acts({
    \ 'act'     : act,
    \ 'acts'    : acts,
    \ 'desc'    : desc,
    \ 'front'   : front,
    \ 'fmt_sub' : fmt_sub,
    \ 'Fc'      : Fc,
    \ })

endfunction

function! tex#apply_to_markers (expr)
  let m = "'<,'>"
  exe m.a:expr
endfunction

function! tex#apply_to_each_line (expr,start,end)
  if type(a:expr) == type([])
    for e in a:expr
      call tex#apply_to_each_line (e,a:start,a:end)
    endfor
    return 1
  endif

  let num=a:start
  while num < a:end+1
    exe 'normal! ' . num . 'G'
    try
      exe a:expr
    catch
    finally
    endtry
    let num+=1
  endw
endf

function! tex#lines (env,...)
  let env   = a:env
  let lines = []

  let iopts={}
  let iopts_def = {
    \ 'tabular' : { 'center' : 1 },
    \ 'section' : {},
    \ }

  call extend(iopts,iopts_def)
  call extend(iopts,get(a:000,0,{}))

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


  elseif env == 'horizontal_line'

    let width = base#prompt('Width:','\textwidth')
    let s = '\noindent\rule{'.width.'}{0.4pt}'

    call add(lines,s)

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

  elseif env == 'href'

    let url   = base#prompt("URL:",'<+url+>')
    let title = base#prompt("Title:",'<+title+>')

    call add(lines,'\href{'.url.'}{'.title.'}')

  elseif env == 'multicolumn'

    let cols = base#prompt("Number of columns:",'')
    let pos  = base#prompt("Position:",'')
    let text = base#prompt("Text:",'')

    call add(lines,'\hline')
    call add(lines,'\multicolumn{'.cols.'}{'.pos.'}{'.text.'} \\') 
    call add(lines,'\hline')

  elseif env == 'tikzpicture'
    call add(lines,'\begin{tikzpicture}')
    call add(lines,'\end{tikzpicture}')

  elseif env == '@ifpackageloaded'
    let pack=base#prompt('Package:','','custom,tex#complete#texpackages')
    let code=base#prompt('Code:','<+Code+>')

    call add(lines,'\@ifpackageloaded{'.pack.'}{'.code.'}')

  elseif env == 'includegraphics'

    let height = base#prompt('height:','')
    let width  = base#prompt('width:','')
    let gfile  = base#prompt('graphics file:','')

    call add(lines,'\includegraphics[width='.width.',height='.height.']{'.gfile.'}')

  elseif env == 'selectlanguage'

    let language=base#prompt('Language:','russian')
    call add(lines,'\selectlanguage{'.language.'}')

  elseif env == 'iflanguage'

    let language = base#prompt('Language:','russian')
    let true     = base#prompt('True:','')
    let false    = base#prompt('False:','')

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

"""texlines_secs
  elseif base#inlist(env,envs.sec)

    call extend(lines,tex#lines#envs_sec(env,iopts))

"""texlines_tabs
  elseif base#inlist(env,envs.tab)

    call extend(lines,tex#lines#envs_tab(env,iopts))

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

     call add(lines,'%--------------')
     call extend(lines,hlines)
     call add(lines,'%--------------')

     call add(lines,'\@startsection{'   . name    . '}{' . level . '}{' . indent . '}%')
     call add(lines,'       {' . beforeskip . '}%')
     call add(lines,'       {' . afterskip  . '}%')
     call add(lines,'       {' . style          . '}%')

"""ft_tex_fontsize
 elseif env == '\fontsize'
   let size = base#prompt('Font size:',14)
   let skip = base#prompt('Baselineskip multiplier:',1.2)

   call add(lines,'\fontsize{'.size.'}{'.size*skip.'}')

  endif

  if !len(lines)
    let sub = 'tex#insertcmd#'.env
    exe 'let lines='.sub.'(iopts)'

"    try
      "exe 'let lines='.sub.'(iopts)'
    "catch /.*/
      "call base#warn({ 'text' : 'No method for TeX inserting: ' . sub})
    "endtry
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

  call tex#init#texmf()
  call tex#init#au()
  call tex#init#maps()

  call tex#parser#init()

  let tdir   = base#qw#catpath('plg','tex data tex insert')
  let tfiles = {}

  let tfiles.insert = base#find({
        \ "dirs"    : [tdir],
        \ "qw_exts" : 'tex',
        \ "relpath" : 1,
        \ 'subdirs' : 1,
        \ 'rmext'   : 1,
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

function! tex#pat (...)

  let patname = get(a:000,0,'')

  if !strlen(patname)
    let pat = base#varget('tex_pat','')
    return pat
  endif

  let pats = base#varget('tex_pats',{})
  let pat  = get(pats,patname,'')

  call base#varset('tex_pat',pat)

  return pat
endfunction
