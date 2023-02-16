" return if plugin has benn loaded
if exists('g:loaded_goctl') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

" hi def link WhidHeader    Number
" hi def link WhidSubHeader Identifier

" command! Whid lua require('whid').init()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_goctl = 1
