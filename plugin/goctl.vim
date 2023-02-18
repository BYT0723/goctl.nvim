" return if plugin has benn loaded
if exists('g:loaded_goctl') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

" hi def link WhidHeader    Number
" hi def link WhidSubHeader Identifier

" command! Whid lua require('whid').init()
command! GoctlInstall require('goctl.common').goctl_install()
command! GoctlUpgrade require('goctl.common').goctl_upgrade()
command! GoctlEnv require('goctl.common').goctl_env()


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_goctl = 1
