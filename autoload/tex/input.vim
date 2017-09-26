
"lines > file
" process lines first, if defined
"
function! tex#input#parse (ref)
	let ref  = a:ref

	let lines = get(ref,'lines',[])

	if !len(lines) | return | endif

	let envs = {
			\	'longtable' : [],
			\	'table'     : [],
			\	}
	let packages=[]

	let struct = {
		\	'envs'     : envs,
		\	'packages' : packages,
		\	}

	let lnum       = 0

	let longtables = []
	let tables     = []

	let this_longtable = {}
	let inside         = {}

	for line in lines
		if line =~ tex#pat('longtable_begin')
			call extend(this_longtable,{ 'begin' : lnum })
			call extend(inside, { 'longtable' : 1 })

		elseif line =~ tex#pat('longtable_end')
			call extend(this_longtable,{ 'end' : lnum })
			call add(longtables,deepcopy(this_longtable))

			let this_longtable={}
			call extend(inside, { 'longtable' : 0 })

		elseif line =~ tex#pat('usepackage')
			let pat = tex#pat()

		else
			if get(inside,'longtable')
				let ll = get(this_longtable,'lines',[])
				call add(ll,line)
				call extend(this_longtable,{ 'lines' : copy(ll) })
			endif
		endif
		let lnum+=1
	endfor

	call extend(envs,{ 
		\	'longtable' : longtables,
		\	'table'     : tables,
		\	})

	call extend(struct,{ 'envs' : envs }) 

	return struct
	
endfunction
