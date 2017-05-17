"================================================================ 
" RobotUtils: Tools and utilities for Robot Framework
"================================================================ 

function! RobotUtils#getIdentifiers() " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Returns a list of identifiers for the current cursor position. The first
  " element is the Robot identifier, and the second is the python equivalent (if
  " available)
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  let l:text = getline('.')
  let l:col = col('.')
  let l:result = []
  " check for variables under the cursor
  call add(l:result, matchstr(l:text, '\v\{\zs\w*%'.l:col.'c\w*\ze\}'))
  if l:result[0] == ""
    " check for keywords and tests under the cursor
    let l:result[0] = matchstr(l:text, 
          \ '\v%(^|\s\s)\s*\zs(%(\s\s)@!.){-}%'.l:col.'c(%(\s\s)@!.){-}\ze%($|\s\s)')
    let l:pythonId = substitute(l:result[0], '\s\+', '_', 'g')
    let l:pythonId = substitute(l:pythonId, '\v.+', '\L&', '')
    call add(l:result, l:pythonId)
  endif
  " echom string(l:result)
  return l:result
endfunction

function! RobotUtils#tag(cmd) " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Runs the command specified (tag or ptag) on the identifiers in the current
  " cursor position
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  let l:id = RobotUtils#getIdentifiers()
  for i in range(len(l:id))
    if !empty(taglist('^'.l:id[i].'$'))
      exe a:cmd.' '.l:id[i]
      return
    endif
  endfor
  echomsg 'tag not found: '.string(l:id)
endfunction

function! RobotUtils#UltiExpandOrSpaces() " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Integration of the <Tab> to four spaces with the UltiSnips plugin
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res
    return ""
  else
    return "    "
  endif
endfunction

" vim:set et sw=2 foldmethod=marker:
