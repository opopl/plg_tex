
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
    for h in headers
      call add(lines,h .' & %'.i)
      let i+=1
    endfor
    call add(lines,'\\')
  endif

  return lines

endf

