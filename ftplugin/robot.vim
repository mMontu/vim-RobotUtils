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

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql

nnoremap <buffer> <silent> <c-]>  :call RobotUtils#tag('tag')<CR>
nnoremap <buffer> <silent> <s-CR> :call RobotUtils#tag('ptag')<CR>
nnoremap <buffer> <silent> <c-CR> :call RobotUtils#tag('sp \| tag')<CR>


" vim:set et sw=2:
