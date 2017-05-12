"================================================================ 
" RobotUtils: Tools and utilities for Robot Framework
"================================================================ 

function! RobotUtils#getIdentifier()
   let l:text = getline('.')
   let l:col = col('.')
   let l:result = matchstr(l:text, '\v\{\zs\w*%'.l:col.'c\w*\ze\}')
   if l:result == ""
      let l:result = matchstr(l:text, 
               \ '\v%(^|\s\s)\s*\zs(%(\s\s)@!.){-}%'.l:col.'c(%(\s\s)@!.){-}\ze%($|\s\s)')
   endif
   return l:result
endfunction


" vim:set et sw=2:
