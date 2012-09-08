LaTeX Tips
==========

Installing Fonts on Debian
--------------------------

::

  sudo vim /etc/texmf/updmap.d/90whatever.cfg
  sudo mktexlsr
  sudo update-updmap
  sudo updmap-sys
  sudo updmap

Checking if a File Exists
-------------------------

::

  \IfFileExists{package.sty}{true}{false}
