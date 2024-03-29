"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Plugin written and maintained by Gael Induni
" This is HgCi plugin to commit on save
"  Last modified: Mon 21 May 2012 04:10:58 PM CEST
"  Version 0.2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" To be always up-to-date:
"" GetLatestVimScripts: 4080 1 :AutoInstall: HgCi
""
"" Problems when saving many times without leaving Vim

if exists("g:loaded_HgCi") && g:loaded_HgCi
	finish
endif
let g:loaded_HgCi = 1
let g:HgCi_version = 0.2

function HgCi(...)
	if a:0 > 0 && a:1 != ""
		let l:file = a:1
		let l:path = "."
		if l:file =~ "/"
			let l:path = matchstr( l:file, "^.*/" )
			let l:path = substitute( l:path, "\/$", "", "" )
			let l:file = matchstr( l:file, "[^/]*$" )
		endif
	else
		let l:file = expand("%:t")
		let l:path = expand("%:h")
	endif
	let l:tmp = "/tmp/" . l:file . ".log.hg"

	execute "augroup HgCi_" . l:file
		autocmd!
		execute "autocmd BufUnload " . l:tmp . " call HgCiEnd(\"" . l:path . "/" . l:file . "\")"
	augroup END

	execute "5split " . l:tmp
endfunction

function HgCiEnd(...)
	if a:0 > 0 && a:1 != ""
		let l:file = a:1
		let l:path = "."
		if l:file =~ "/"
			let l:path = matchstr( l:file, "^.*/" )
			let l:path = substitute( l:path, "\/$", "", "" )
			let l:file = matchstr( l:file, "[^/]*$" )
		endif
	else
		let l:file = expand("%:t")
		let l:path = expand("%:h")
	endif
	let l:tmp = "/tmp/" . l:file . ".log.hg"

	execute "!hg ci -l " . l:tmp . " " . l:path . "/" . l:file
	execute "silent !rm " . l:tmp
	execute "augroup! HgCi_" . l:file
endfunction

com! -nargs=* -complete=file HgCi call HgCi(<f-args>)
