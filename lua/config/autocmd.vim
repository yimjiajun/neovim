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
	let g:large_file = 500 * 1048" 500KB

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
						\ if getfsize(f) <= (1048*1048*1048) |
							\ if getfsize(f) < (1048*1048) |
								\ echo "large file :" (getfsize(f)/1048)"KB" |
							\ else |
								\ echo "large file :" (getfsize(f)/1048/1048)(getfsize(f)/1048%1000)"MB" |
							\ endif |
						\ else |
							\ echo "large file :" (getfsize(f)/1048/1048/1048)(getfsize(f)/1048/1048%1000)"GB" |
						\ endif |
		\ else |
						\ set eventignore-=FileType |
		\ endif
augroup END
