
if 0
  call tree
    called by
      tex#init
endif

function! tex#parser#init ()

  call tex#parser#latex#patterns()
  
endfunction

"call tex#parser#output_to_qflist ({ 'out' : [ ... ] })

function! tex#parser#output_to_qflist (...)

 let ref = get(a:000,0,{})
 let out = get(ref,'out',[])

 let pats = tex#parser#latex#patterns()
 let patids = base#qw('latex_error error')

 let keep = 0
 let newlist= []

 let i=0
 let lnum=0

 for line in out
  let err = 0

  if ! lnum
    for patid in patids
      let pat = get(pats,patid,'')
      if strlen(pat)
        if line =~ pat
          echo text
          let err=1
        endif
      endif
    endfor
  endif

  if keep 
    call add(newlist,item)
  endif

  let lnum+=1
 endfor

 call setqflist(newlist)
 let errcount = len(newlist)

endfunction
