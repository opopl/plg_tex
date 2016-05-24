
fun! tex#insert(env,...)

  let env=a:env

  let lines=[]

"""longtable
  if env == 'longtable'

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

	elseif env == 'figure'

	call add(lines,'\begin{figure}[ht]')
	call add(lines,'	\begin{center}')
	call add(lines,'		\ifig{1}')
	call add(lines,'	\end{center}')
	call add(lines,'	')
	call add(lines,'	\caption{<++>}')
	call add(lines,'	\label{fig:1}')
    call add(lines,'\end{figure}')


"""pap_table
  elseif env == 'pap_table'

perl << EOF
  #!/usr/bin/env perl

  use warnings;
  use strict;
  
  use Vim::Perl qw( VimVar VimEval VimAppend );
  use LaTeX::Table ();
  use OP::PAPERS::PSH ();

  Vim::Perl::init;
  
  my $curtab=VimVar('g:PAP_CurrentTab');
  my $caption=VimVar('g:PAP_CurrentTabCaption');
  my $datfile=VimVar('g:PAP_CurrentTabDat');

  my $pkey=VimVar('g:PAP_pkey');

  my $psh=OP::PAPERS::PSH->new();
  $psh->init_vars();

  my $string=$psh->_tex_paper_tabdat2tex($pkey);

  my @slines=split("\n",$string);

  my $num=VimEval("line('.')");

  foreach (@slines){
    chomp;
    next if /^\s*#/;

    VimAppend($num,$_);
    $num++;
    
  }
  
EOF
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
	let dictdir = base#qw#catpath('plg','tex data dict')
	let listdir = base#qw#catpath('plg','tex data list')

	let ext = ".i.dat"
	let exts = [ ext ]
	let lists = base#find({ 
		\	"dirs" : [listdir], 
		\	"ext" : exts,
		\	"relpath" : 1,
		\	})
	call map( lists,'substitute(v:val,"'.ext.'$","","g")' )

	let dicts = base#find({ 
		\	"dirs" : [dictdir], 
		\	"ext" : exts,
		\	"relpath" : 1,
		\	})

	call map( dicts,'substitute(v:val,"'.ext.'$","","g")' )

	for lst in lists
		let vname = 'tex_'.lst
		let df = base#file#catfile([ listdir, lst . ext ])
		let vv = base#readarr(df)

		call base#var(vname,vv)
	endfor
	if exists("vv") | unlet vv | endif 
		
	for dct in dicts
		let vname = 'tex_'.dct
		let df = base#file#catfile([ dictdir, dct . ext ])
		let vv = base#readdict(df)

		call base#var(vname,vv)
	endfor
	"echo dicts
endfunction
