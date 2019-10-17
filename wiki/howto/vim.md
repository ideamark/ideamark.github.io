# Vim


> [knowledgeQA start]

## how to edit dos files by vim
:e ++ff=dos

## how to delete same lines by vim
:g/^\(.\+\)$\n\1/d

## how to get ascii code by vim
ga

## how to make vim plug-in
First, in /etc/vimrc, "filetype plugin on" should be opened
Then in plugin, "au BufNewFile, BufRead, *.xx call set filetype=AAA" to set the file type
When open *.xx file, Vim will find AAA.vim and execute it.
In each *.vim file, function like filename#function() will call filename#function() in filename.vim
In plugin folder, "set syntax=BBB" will call BBB.vim in syntax folder to highlight the codes.

## how to flip pages by vim
PageDown: Ctrl + f
PageUp: Ctrl + b

## how to match chinese by vim
'[\u4e00-\u9fa5]'

## how to match english by vim
'[\u0020-\u007E]'

## how to use vim historical views
Back: Ctrl + o
Forward: Ctrl + i

## how to find strings in multiple files by vim
vimgrep /String/ ./*

## how to fold code by vim
First, add this in vimrc,
Set foldmethod=indent
Then, open the fold: l
Open all folds: zR
Close fold: zc
Close all folds: zM
Expand entire function: zO

## how to access system clipboard by vim
Be sure to install the vim-gnome, otherwise you can not operate the system clipboard
sudo apt install vim-gnome
":reg" to see all clipboard contents in vim, the "+ is the system clipboard
Use command "+y to copied to the system clipboard, use command "+p to past from the system clipboard

## how to do when vim can not open plug-in help documentation
':helptags ~/.vim/doc'

## how to replace words by vim
Replace a to b: :%s/a/b/g
Replace a to b from line n to line m: :n,ms/a/b/g

## how to make a new line on vimwiki
Just type <br>

## how to read binary file by vim
vi -b filename
:%!xxd

## how to init gvim
set guifont=Consolas::h12:cANSI
colorscheme darkblue
set nobackup
set encoding=utf-8

## how to init vim
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set cindent
set cinoptions={2,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s
imap kk <ESC>

## how to install xml.vim
Copy xml.vim file to ~/.vim/ftplugin and then use ln -s command to create relationship between xml.vim and docbk.vim, xsl.vim, html.vim, xhtml.vim
Open ftplugin in vimrc
Tips,
Tag autocomplete: double-click > symbol
Auto new line: double-click ; symbol in INSERT mod
For more help, enter: help xml-plugin

## how to save word in regular expression by vim
:%s/\(str_1\) xx \(str_2\)/\2 or \1/

## how to remove duplicate rows by vim
:sort
:g/^\(.*\)$\n\1$/d

## how to mismatch by vim
'[^(your_regex)]'

## how to convert case by vim
:%s/\(xx\)/\L\1/g (Lower)
:%s/\(xx\)/\U\1/g (Upper)

## how to install vim-markdown
Download and unzip vim-markdown
Edit /etc/vimrc, add,
set noncompatible
filetype plugin on

## how to paste by vim
:set paste
:set nopaste

## how to open multiple files by vim
vi -o file1, file2, file3

## how to replace multiple files by vim
:args *.txt
:argdo %s/old/new/g

## how to format json by vim
:%!python -m json.tool

## how to search multiple keywords by vim
/aaa\|bbb\|ccc

## how to change vim theme?
colorscheme xxx

> [knowledgeQA end]
