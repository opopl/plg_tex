
function! tex#env#tab#samplerow ()
		let refdef={ 
				\	'ncols' : 1,
				\	}
		let ref=refdef
		call extend(ref,get(a:000,0,{}))

		let ncols = get(ref,'ncols')

    let samplerow=join(map(base#listnew(ncols),"'" . '<++>' . "'"),' & ') . ' \\'

		return samplerow
	
endfunction

