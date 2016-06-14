
function! tex#complete#insert (...)
	return base#complete#vars(['tex_insert_entries'])
endfunction

function! tex#complete#texmodes (...)
	return base#complete#vars(['tex_texmodes'])
endfunction

function! tex#complete#texdoc (...)
	return base#complete#vars(['tex_texdocentries'])
endfunction

function! tex#complete#texrun (...)
	return base#complete#vars(['tex_opts_texrun'])
endfunction


function! tex#complete#seccmds (...)
	return base#complete#vars(['tex_seccmds'])
endfunction

function! tex#complete#texpackages (...)
	return base#complete#vars(['tex_texpackages'])
endfunction

"LFUN TEX_CompleteInsert
"LFUN TEX_Insert

"command! -nargs=* -complete=custom,TEX_CompleteInsert TEXINSERT 
  "\ call TEX_Insert(<f-args>)
