" binary view
augroup Binary
	au!
	au BufReadPre  *.bin let &bin=1
	au BufReadPost *.bin if &bin | %!xxd
	au BufReadPost *.bin set ft=xxd | endif
	au BufWritePre *.bin if &bin | %!xxd -r
	au BufWritePre *.bin endif
	au BufWritePost *.bin if &bin | %!xxd
	au BufWritePost *.bin set nomod | endif
augroup END

augroup LargeFile
	let g:large_file = 10485760 " 10MB

	" Set options:
	"   eventignore+=FileType (no syntax highlighting etc
	"   assumes FileType always on)
	"   noswapfile (save copy of file)
	"   bufhidden=unload (save memory when other file is viewed)
	"   buftype=nowritefile (is read-only)
	"   undolevels=-1 (no undo possible)
	au BufReadPre *
		\ let f=expand("<afile>") |
		\ if getfsize(f) > g:large_file |
						\ set eventignore+=FileType |
						\ setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
		\ else |
						\ set eventignore-=FileType |
		\ endif
augroup END
