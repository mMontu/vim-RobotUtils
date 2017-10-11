"================================================================ 
" RobotUtils: Tools and utilities for Robot Framework
"================================================================ 

" Options {{{1
if !exists("g:robot_utils_cache_dir")
   let g:robot_utils_cache_dir = $HOME.'/.cache/vim-RobotUtils'
endif


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

function! RobotUtils#packageTags() " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Check for new or updated Robot packages in the system and prompt the user
  " for tag creation
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  if executable('pip') != 1
    return 'unable to find pip executable'
  endif
  if !s:checkDirectory(g:robot_utils_cache_dir)
    return 'failed to create cache dir'
  endif

  " - filter and write pip list to pip_list
  " - compare against the previous contents of the file
  " - prompt the user
  " - for each element
  " -   retrieve the path
  " -   append the element and its path in the pip_list file
  " -   append the tags
  "
  " or just grep the package path for robot and selenium, because trying to
  " understand the a user lib it became clear that it was necessary to have
  " tags for Selenium, not only Selenium2Library. 
  " - save the current python packages in a file
  " - ctags for all packages
  " - check for new packages and propose regenerate the tags

  " on ftplugin: 
  " - append this tag file in the &l:tags
  " - check for g:robot_utils_system_tags; if it doesn't exist, call this
  "   funciton and assign its return value to that variable

  let pipShowRobot = systemlist('pip --disable-pip-version-check show robotframework')
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "  NOTE: it seems that the packages used by current project are already    "
  "  part of the repo, inside the env folder; thus this feature isn't
  "  currently necessary.
  "  It was enough to change ~/.git_template/hooks/ctags from
  "  http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
  "  , replacing `git ls-files | \` 
  "  with `(git ls-files && git ls-files -o env) | \`
  "  , which caused the untracked files inside `env` directory to be
  "  considered when running ctags for the repo
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  

endfunction

function! RobotUtils#tag(cmd) " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Runs the command specified (tag or ptag) on the identifiers in the current
  " cursor position
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  let l:idList = RobotUtils#getIdentifiers()
  for i in range(len(l:idList))
    " echo 'idList[i]: '.l:idList[i]
    if !empty(taglist('^'.l:idList[i].'$'))
      exe a:cmd.' '.l:idList[i]
      return
    endif
    """"""""""""""""""""""""""""""""""
    "  check for embedded arguments  "
    """"""""""""""""""""""""""""""""""
    let l:idSplit = split(l:idList[i])
    if len(l:idSplit) > 1
      " select all tags that matches the first and last word and filter those
      " that contains embedded arguments
      let l:tags = filter(taglist('^'.l:idSplit[0]), 'v:val.name =~ "\\${"')
      call extend (l:tags, filter(taglist(l:idSplit[len(l:idSplit)-1].'$'), 'v:val.name =~ "\\${"'))
      " echo 'tags len: '.len(l:tags)
      " echo l:tags
      for j in range(len(l:tags))
        " replace the embedded arguments with non-greedy `.*`; considers that
        " then tags.name sometimes is truncated (leaving an unmatched brace)
        " when the embedded argument regex is specified
        let l:tagRegex = '^'.substitute(l:tags[j].name, '\${.\{-}\(}\|$\)', '.\\{-}', 'g').'$'
        " echo 'tag regex: '.l:tagRegex
        if l:idList[i] =~ l:tagRegex
          " echo 'l:idList[i]: '.l:idList[i]
          " echo 'l:tags[j].name : '.l:tags[j].name 
          exe a:cmd.' '.escape(l:tags[j].name, '|')
          return
        endif
      endfor
    endif
  endfor
  echomsg 'tag not found: '.string(l:idList)
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

function! s:checkDirectory(dir) " {{{1
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Return true if the given directory exists or was successfully created
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  if !isdirectory(a:dir)
    if !exists('*mkdir') || !mkdir(a:dir, 'p')
      echohl ErrorMsg
      echomsg "RobotUtils plugin: unable to create directory: ".a:dir
      echohl None
      return 0
    endif
  endif
  return 1
endfunction

" vim:set et sw=2 foldmethod=marker:
