"======================================================================
"
" misc.vim - edit details
"
" created by: skywind in 2016/9/19 1:00:44
" last change: 2016/9/19 1:00:44
"
"======================================================================

"-----------------------------------------------------------------------
" insert before current line
"-----------------------------------------------------------------------
function! s:snip(text)
	call append(line('.') - 1, a:text)
endfunc


"-----------------------------------------------------------------------
" guess comment
"-----------------------------------------------------------------------
function! s:comment()
	let l:ext = expand('%:e')
	if &filetype == 'vim'
		return '"'
	elseif index(['c', 'cpp', 'h', 'hpp', 'hh', 'cc', 'cxx'], l:ext) >= 0
		return '//'
	elseif index(['m', 'mm', 'java', 'go', 'delphi', 'pascal'], l:ext) >= 0
		return '//'
	elseif index(['coffee', 'as'], l:ext) >= 0
		return '//'
	elseif index(['c', 'cpp', 'rust', 'go', 'javascript'], &filetype) >= 0
		return '//'
	elseif index(['coffee'], &filetype) >= 0
		return '//'
	elseif index(['sh', 'bash', 'python', 'php', 'perl'], $filetype) >= 0
		return '#'
	elseif index(['make', 'ruby'], $filetype) >= 0
		return '#'
	elseif index(['py', 'sh', 'pl', 'php', 'rb'], l:ext) >= 0
		return '#'
	elseif index(['asm', 's'], l:ext) >= 0
		return ';'
	elseif index(['asm'], &filetype) >= 0
		return ';'
	elseif index(['sql'], l:ext) >= 0
		return '--'
	elseif index(['basic'], &filetype) >= 0
		return "'"
	endif
	return ""
endfunc


"-----------------------------------------------------------------------
" comment bar
"-----------------------------------------------------------------------
function! s:comment_bar(repeat, limit)
	let l:comment = s:comment()
	while strlen(l:comment) < a:limit
		let l:comment .= a:repeat
	endwhile
	return l:comment
endfunc


"-----------------------------------------------------------------------
" comment block
"-----------------------------------------------------------------------
function! <SID>snip_comment_block(repeat)
	let l:comment = s:comment()
	let l:complete = s:comment_bar(a:repeat, 71)
	if l:comment == ''
		return
	endif
	call s:snip('')
	call s:snip(l:complete)
	call s:snip(l:comment . ' ')
	call s:snip(l:complete)
endfunc


"-----------------------------------------------------------------------
" copyright
"-----------------------------------------------------------------------
function! <SID>snip_copyright(author)
	let l:c = s:comment()
	let l:complete = s:comment_bar('=', 71)
	let l:filename = expand("%:t")
	let l:t = strftime("%Y/%m/%d")
	let l:text = []
	if &filetype == 'python'
		let l:text += ['#! /usr/bin/env python']
		let l:text += ['# -*- coding: utf-8 -*-']
	elseif &filetype == 'sh'
		let l:text += ['#! /bin/sh']
	elseif &filetype == 'php'
	endif
	let l:text += [l:complete]
	let l:text += [l:c]
	let l:text += [l:c . ' ' . l:filename . ' - ' ]
	let l:text += [l:c]
	let l:text += [l:c . ' Created by ' . a:author . ' on '. l:t]
	let l:text += [l:c . ' Last change: ' . strftime('%Y/%m/%d %H:%M:%S') ]
	let l:text += [l:c]
	let l:text += [l:complete]
	call append(0, l:text)
endfunc


"----------------------------------------------------------------------
" bundle setup
"----------------------------------------------------------------------
function! <SID>snip_bundle()
	let l:text = []
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ['" Bundle Header']
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ["set nocompatible"]
	let l:text += ["filetype off"]
	let l:text += ["set rtp+=~/.vim/bundle/Vundle.vim"]
	let l:text += ["call vundle#begin()"]
	let l:text += ["Plugin 'gmarik/Vundle.vim'"]
	let l:text += [""]
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ['" Plugins']
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += [""]
	let l:text += [""]
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ['" Bundle Footer']
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ["call vundle#end()"]
	let l:text += ["filetype on"]
	let l:text += [""]
	let l:text += [""]
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += ['" Settings']
	let l:text += ['"----------------------------------------------------------------------']
	let l:text += [""]
	let l:text += [""]
	call append(line('.') - 1, l:text)
endfunc


"-----------------------------------------------------------------------
" hot keys
"-----------------------------------------------------------------------
noremap <space>e- :call <SID>snip_comment_block('-')<cr>
noremap <space>e= :call <SID>snip_comment_block('=')<cr>
noremap <space>ec :call <SID>snip_copyright('skywind')<cr>
noremap <space>eb :call <SID>snip_bundle()<cr>
noremap <space>et "=strftime("%Y/%m/%d %H:%M:%S")<CR>gp
noremap <space>ep :call append(line('.') - 1, '')<cr>
noremap <space>en :call append(line('.'), '')<cr>



"----------------------------------------------------------------------
" insert mode fast
"----------------------------------------------------------------------
inoremap <c-x>( ()<esc>i
inoremap <c-x>[ []<esc>i
inoremap <c-x>' ''<esc>i
inoremap <c-x>" ""<esc>i
inoremap <c-x>< <><esc>i
inoremap <c-x>{ {<esc>o}<esc>ko

if has('gui_running')
	inoremap <M-(> ()<esc>i
	inoremap <M-[> []<esc>i
	inoremap <M-'> ''<esc>i
	inoremap <M-"> ""<esc>i
	inoremap <M-<> <><esc>i
	inoremap <M-{> {<esc>o}<esc>ko
endif



