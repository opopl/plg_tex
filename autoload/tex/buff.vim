
function! tex#buff#setmaps ()

	if exists('b:tex_buff_setmaps')
		return
	endif
	let b:tex_buff_setmaps = 1

  nnoremap <buffer><silent> <F4> :TEXRUN thisfile_pdflatex<CR>
	
endfunction

function! tex#buff#start ()

	if exists('b:tex_buff_start')
		return
	endif
	let b:tex_buff_start = 1
	
endfunction
