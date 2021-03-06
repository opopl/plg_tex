
function! tex#act#tab_remove_multicolumn ()
  let start = base#varget('tex_texact_start')
  let end   = base#varget('tex_texact_end')

  let exprs = [
      \ 's/\\multicolumn\s*{\s*1\s*}\s*{.\{-}}\s*{\(.\{-}\)}\s*\(&\|\\\\\)/\1 \2/g',
      \ ] 
  
  for expr in exprs
    call tex#apply_to_each_line(expr,start,end)
  endfor
endfunction

function! tex#act#tab_col_enclose_verb ()
  let start = base#varget('tex_texact_start')
  let end   = base#varget('tex_texact_end')

  let exprs = [
      \ 's/^\([^&]*\)\(&\)/\\verb|\1| \2/g',
      \ ] 
  
  for expr in exprs
    call tex#apply_to_each_line(expr,start,end)
  endfor
endfunction

function! tex#act#tab_nice ()
  let start = base#varget('tex_texact_start')
  let end   = base#varget('tex_texact_end')

  let exprs = [
      \ 'Tabularize/&'    ,
      \ 'Tabularize/\\\\' ,
      \ 's/\\textbf{}//g' ,
      \ ] 

  for expr in exprs
    call tex#apply_to_markers(expr)
  endfor

endfunction

function! tex#act#everyhook_cmd ()

endfunction

function! tex#act#thisfile_compile_latex ()
  let fi=b:finfo

endfunction

"""sol_add_hline
function! tex#act#sol_add_hline ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/^/\\hline /g'

  call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#sol_add ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let cmd = input('TEX Command to insert:','')
  let expr = 's/^/\\'.cmd.' /g'

  call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#buf_parse ()
  call tex#buff#parse()

endfunction

function! tex#act#escape_latex ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  '<,'>perldo s/_/\\_/g
  "'<,'>perldo s/\$/\\$/g

endfunction

function! tex#act#delete_empty_lines ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/^\s*\n//g'

  call tex#apply_to_each_line (expr,start,end)

endfunction


function! tex#act#down_sections ()

  perldo s/\\paragraph/\\subparagraph/g
  perldo s/\\subsubsection/\\paragraph/g
  perldo s/\\subsection/\\subsubsection/g
  perldo s/\\section/\\subsection/g
  perldo s/\\chapter/\\section/g
  perldo s/\\part/\\chapter/g
  
endfunction

function! tex#act#up_sections ()

  perldo s/\\chapter/\\part/g
  perldo s/\\section/\\chapter/g
  perldo s/\\subsection/\\section/g
  perldo s/\\subsubsection/\\subsection/g
  perldo s/\\paragraph/\\subsubsection/g
  perldo s/\\subparagraph/\\paragraph/g
  
endfunction

function! tex#act#buf_nice ()
  call tex#buff#nice()
endfunction

if 0
  Usage:
    run for the current buffer
      call tex#act#texify()
    run for any file
      call tex#act#texify({ 
        \ 'file'  : file,
        \ 'cmd'   : cmd,
        \ 'start' : start,
        \ 'end'   : end,
        \ })
endif

function! tex#act#rpl_quotes (...)
	call tex#act#texify({ 'cmd' : 'rpl_quotes' })
endf

function! tex#act#rpl_verbs (...)
	call tex#act#texify({ 'cmd' : 'rpl_verbs' })
endf

function! tex#act#texify (...)
  let ref = get(a:000,0,{})

  let file = get(ref,'file','')
  let cmd  = get(ref,'cmd','')

  let start = base#varget('tex_texact_start',1)
  let start = get(ref,'start',start)

  let end   = base#varget('tex_texact_end',line('$'))
  let end   = get(ref,'end',end)

  let file_full = len(file) ? 1 : 0
  let env = { 
    \ 'file_full' : file_full,
    \ 'start'     : start,
    \ 'end'       : end,
    \ 'cmd'       : cmd,
    \ }

  if !len(file)
    let lines = base#buf#lines(start,end)
    let dir  = base#qw#catpath('home','tmp texify')
    call base#mkdir(dir)
    let file = base#file#catfile([ dir, '1.txt' ])
    call writefile(lines,file)
  endif
  call extend(env,{ 'file' : file })

  let pl   = base#qw#catpath('plg projs scripts bufact tex texify.pl')
  let pl_e = shellescape(pl)
  let f_e  = shellescape(file)

  let a = [ 'perl', pl_e, '--file', f_e, '--cmd', cmd ]

  if file_full
    if len(start)
      call extend(a,[ '--start', start ])
    endif
    if len(end)
      call extend(a,[ '--end', end ])
    endif
  endif
  
  let cmd = join(a, ' ')
  "call base#buf#open_split({ 'lines' : [cmd] })

  function env.get(temp_file) dict
    call tex#act#texify_Fc (self,a:temp_file)
  endfunction
  
  call asc#run({ 
    \ 'cmd' : cmd, 
    \ 'Fn'  : asc#tab_restore(env) 
    \ })

endfunction

function! tex#act#texify_Fc (self,temp_file)
    let self      = a:self
    let temp_file = a:temp_file

    let code      = self.return_code
    let file      = get(self,'file','')

    let start      = get(self,'start',1)
    let end        = get(self,'end',line('$'))

    let lines     = readfile(file)
    if get(self,'file_full')
      e!
    else
      exe printf('%s,%sd',start,end)
      call append(start-1,lines)
    endif
  
    if filereadable(a:temp_file)
      let out = readfile(a:temp_file)
      call base#buf#open_split({ 'lines' : out })
    endif
endfunction

function! tex#act#better_tex ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

perl << eof
  sub texact_better_tex { 
       s/–/---/g;
       s/—/---/g;

       s/’/'/g;
       s/‘/'/g;

       s/([^-\s]+)-\s+([^-\s]+)/$1$2/g;
  };
eof

  let exprs = [ 'perldo texact_better_tex()' ]

  call tex#apply_to_each_line (exprs,start,end)

endfunction

function! tex#act#quotes_replace ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

perl << eof
  sub texact_quotes_replace { 
       s/’/'/g;
       s/‘/'/g;

       s/“/``/g;
       s/”/''/g;

       s/\"([^\"]+)\"/``$1''/g;
       s/"([^"]+)"/``$1''/g;
  };
eof

  let exprs = [ 'perldo texact_quotes_replace()' ]

  call tex#apply_to_each_line (exprs,start,end)

endfunction

function! tex#act#eol_add ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let cmds = base#varget('tex_cmds_eol_add',[])
  let cmd = get(cmds,0,'')
  let cmd = input('TEX Command to insert:',cmd,'custom,tex#complete#cmds_eol_add')

  call add(cmds,cmd)
  let cmds = base#uniq(cmds)
  call base#varset('tex_cmds_eol_add',cmds)

  let expr = 's/$/\\'.cmd.'/g'

  call tex#apply_to_each_line (expr,start,end)
endfunction

function! tex#act#eol_add_par ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/$/\\par/g'

  call tex#apply_to_each_line (expr,start,end)
endfunction

function! tex#act#verb_at_start ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/^\(\S\+\)/\\verb|\1|/g'

  call tex#apply_to_each_line (expr,start,end)
endfunction

function! tex#act#url_itemize ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/^\(.*\)$/\t\\item\\url{\1}/g'

  call tex#apply_to_each_line (expr,start,end)

  call append(start-1,'\begin{itemize}')
  call append(end+1,'\end{itemize}')
endfunction

function! tex#act#delete_multicolumn_1 ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/\\multicolumn{1}{\S*}{\(.*\)}/\1/g'

  call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#nice_table ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let start = 0  
  let end   = line('$')

  let exprs = [
    \ 's/\\textbf{\s*}//g',
    \ 's/\\multicolumn{1}{\w\+}{\(\w\+\)}/\1/g',
    \ 's/\\multicolumn{1}{\w\+}{\(.*\)}\s*&/\1/g',
    \ ]

  for expr in exprs
    call tex#apply_to_each_line (expr,start,end)
  endfor

endfunction

function! tex#act#retab_et ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 'set et | retab'

  call tex#apply_to_each_line (expr,start,end)
  
endfunction

function! tex#act#subst_dsh ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/—/---/g'

  call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#sol_add_item ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = 's/^/\\item /g'

  call tex#apply_to_each_line (expr,start,end)

endfunction

function! tex#act#tab_load ()
  let start = base#varget('tex_texact_start',0)
  let end   = base#varget('tex_texact_end',line('$'))

  let expr = ''
  let num  = start

  let all =''
  while num < end+1
    "exe 'normal! ' . num . 'G'
    "exe expr

    let line = getline(num)

    if line =~ '^\s*%'
      let num+=1
      continue
    endif
    let all .= line 

    let num+=1
  endw

  let all = base#rmwh(all)
  let all = substitute(all,'^\(.*\)\\\\\(.\{-}\)$','\1\\\\','g')

  let rows_s = split(all,'\\\\')

  let rows   = []
  let rows_l = []

  for rs in rows_s
    let row_a  = split(rs,'&')
    let row_a  = map(row_a,'substitute(v:val,"\\\\hline","","g")')
    let row_a  = map(row_a,'base#rmwh(v:val)')

    let row_l  = len(row_a)

    call add(rows,row_a)
    call add(rows_l,row_l)
  endfor

  let rows_n = len(rows)
  let cols_n = max(rows_l)

  let cells_n = rows_n*cols_n
  let cells   = []

  let irow=0
  for row in rows
    let jcol=0
    for cell in row
      call add(cells,cell)
      let jcol+=1
    endfor
    call extend(cells,base#listnew(max([cols_n-jcol,0])))
    let irow+=1
  endfor

  let cols = base#listnew(cols_n)
  let col  = []

  for jcol in base#listnewinc(0,cols_n-1,1)
      let cols[jcol]=base#listnew(rows_n)
  endfor

  let ic=0
  for cell in cells
    let irow = ic/cols_n
    let jcol = ic % cols_n

    let thiscol       = cols[jcol]
    let thiscol[irow] = cell

    let ic += 1
  endfor

  let t={}
  call extend(t,{ 
    \ 'cols'   : cols,
    \ 'rows'   : rows,
    \ 'rows_n' : rows_n,
    \ 'cols_n' : cols_n,
    \ })

  call base#varset('tex_table',t)

  echo 'Table loaded with '.rows_n.' rows and '.cols_n.' columns into variable tex_table'

endfunction
