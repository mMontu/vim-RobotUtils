RobotUtils.vim
==============

Tools and utilities to folks working with **[Robot Framework](http://robotframework.org/)**.


### Tour

- Syntax highlight (*soon*)
- Enhanced [`tag`](http://vimhelp.appspot.com/tagsrch.txt.html#CTRL%2d%5d) lookup  (which can be generated using [Universal Ctags](https://github.com/universal-ctags/ctags))
    - uses Robot and Python identifiers instead of space separated identifiers. 
    - works for keywords with [embeded arguments](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#embedding-arguments-into-keyword-name)
    - triggred with <kbd>Ctrl</kbd>-<kbd>]</kbd> or (<kbd>Ctrl</kbd>-<kbd>Enter</kbd> / <kbd>Shift</kbd>-<kbd>Enter</kbd>)
- Tab key inserts four spaces (recommended for the plain text format) - integrated with [UltiSnips](https://github.com/SirVer/ultisnips)


## Installation

If you don't have a preferred installation method, I recommend
installing [pathogen.vim](https://github.com/tpope/vim-pathogen), and
then simply copy and paste:

    cd ~/.vim/bundle
    git clone https://github.com/mMontu/vim-RobotUtils.git

Once help tags have been generated, you can view the manual with
`:help LogNav`.


