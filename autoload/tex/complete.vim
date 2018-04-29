
function! tex#complete#insert (...)
	return base#complete#vars(['tex_insert_entries'])
endfunction

function! tex#complete#texmodes (...)
	return base#complete#vars(['tex_texmodes'])
endfunction

function! tex#complete#texmf (...)
	return base#complete#vars(['tex_texmf_acts'])
endfunction

function! tex#complete#texact (...)
	return base#complete#vars(['tex_texact'])
endfunction

function! tex#complete#textableact (...)
	return base#complete#vars(['tex_textableact'])
endfunction

function! tex#complete#texdoc (...)
	return base#complete#vars(['tex_texdoc_entries'])
endfunction

function! tex#complete#texht (...)
	return base#complete#vars(['tex_texht_actions'])
endfunction

function! tex#complete#texrun (...)
	return base#complete#vars(['tex_opts_texrun'])
endfunction

function! tex#complete#texshow (...)
	return base#complete#vars(['tex_opts_texshow'])
endfunction

function! tex#complete#documentclass (...)
	return base#complete#vars(['tex_documentclasses'])
endfunction

function! tex#complete#cmds_eol_add (...)
	return base#complete#vars(['tex_cmds_eol_add'])
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
