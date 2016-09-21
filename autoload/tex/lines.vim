
function! tex#lines#join_headers (headers,...)
  let headers = a:headers

  let ref_def = { 'single_row' : 1 }
  let ref = get(a:000,0,ref_def)

  call add(lines,join(headers,' & ') . ' \\')

  return lines

endf

