"================================================================ 
" Vim filetype plugin file
" Language:	robot (test framework)
"================================================================ 

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
   finish
endif

setlocal commentstring=#\ %s

" expand Tab to four spaces, as it is recommended for the plain text format
" from https://vi.stackexchange.com/a/7354/1405
inoremap <buffer> <Tab> <Space><Space><Space><Space>

