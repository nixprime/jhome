LaTeX Tips
==========

Installing Fonts on Debian
--------------------------

::

  sudo mktexlsr
  sudo update-updmap
  sudo updmap-sys
  sudo updmap

Checking if a File Exists
-------------------------

::

  \IfFileExists{package.sty}{true}{false}
