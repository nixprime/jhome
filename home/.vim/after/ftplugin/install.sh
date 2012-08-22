#!/bin/sh
# Based on http://peox.net/articles/vimconfig.html
find . -name "_.vim" -o -name "*.vim" -delete
for file in /usr/share/vim/vim73/ftplugin/*.vim
do
    ln -s ~/.vim/after/ftplugin/_.vim ~/.vim/after/ftplugin/`basename $file`
done
