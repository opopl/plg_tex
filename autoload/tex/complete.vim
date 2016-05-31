
function! tex#complete#insert (...)
	return base#complete#vars(['tex_insert_entries'])
endfunction

function! tex#complete#texdoc (...)
	return base#complete#vars(['tex_texdocentries'])
endfunction

function! tex#complete#seccmds (...)
	return base#complete#vars(['tex_seccmds'])
endfunction

"LFUN TEX_CompleteInsert
"LFUN TEX_Insert

"command! -nargs=* -complete=custom,TEX_CompleteInsert TEXINSERT 
  "\ call TEX_Insert(<f-args>)
