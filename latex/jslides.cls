% vim: set ft=tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% jslides.cls - v1.2.0 - 12 September 2012
%% Copyright 2012 Jamie Liu <jliu@nixprime.com>
%% https://github.com/nixprime/jhome/tree/master/latex
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `author-maintained'.
%
% This software is provided 'as is', without warranty of any kind,
% either expressed or implied, including, but not limited to, the
% implied warranties of merchantability and fitness for a
% particular purpose.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% jslides provides three mode options:
%
% * talk: frame number in footer (default)
% * remote: page number in footer
% * handout
%
% jslides also provides the following additional flags (each of which can be
% turned off by specifying the flag as an option, or turned off by specifying
% "no"flag as an option):
%
% * nav: Enables the navigation symbol bar on each slide. Off by default.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jslides}[2012/09/12 Presentation template class]

\RequirePackage{etoolbox}
\newtoggle{js@handout}
\newtoggle{js@pageno}
\newtoggle{js@nav}
\DeclareOption{talk}{%
  \togglefalse{js@handout}
  \togglefalse{js@pageno}
}
\DeclareOption{remote}{%
  \togglefalse{js@handout}
  \toggletrue{js@pageno}
}
\DeclareOption{handout}{%
  \toggletrue{js@handout}
  \togglefalse{js@pageno}
}
\providecommand{\jsdefaultmode}{talk}
\DeclareOption{nav}{\toggletrue{js@nav}}
\DeclareOption{nonav}{\togglefalse{js@nav}}
\ExecuteOptions{\jsdefaultmode,nonav}
\ProcessOptions

% Load beamer.
\iftoggle{js@handout}{%
  \LoadClass[handout,xcolor=svgnames]{beamer}}{%
  \LoadClass[xcolor=svgnames]{beamer}}

% Add layouts for 3/6 slides per page.
\RequirePackage{pgfpages}
\pgfpagesdeclarelayout{3 on 1}{%
  \edef\pgfpageoptionheight{\the\paperwidth} % landscaped by default
  \edef\pgfpageoptionwidth{\the\paperheight}
  \def\pgfpageoptionborder{0pt}
  \def\pgfpageoptionfirstshipout{1}
}{%
  \pgfpagesphysicalpageoptions{%
    logical pages=3,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth,%
    current logical shipout=\pgfpageoptionfirstshipout%
  }
  \ifdim\paperheight>\paperwidth\relax
    % put side-by-side
    \pgfpageslogicalpageoptions{1}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.33\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.1667\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{2}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.33\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{3}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.33\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.8333\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
  \else
    % stack on top of one another
    \pgfpageslogicalpageoptions{1}{%
      border shrink=\pgfpageoptionborder,%
      resized width=\pgfphysicalwidth,%
      resized height=.33\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.8333\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{2}{%
      border shrink=\pgfpageoptionborder,%
      resized width=\pgfphysicalwidth,%
      resized height=.33\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{3}{%
      border shrink=\pgfpageoptionborder,%
      resized width=\pgfphysicalwidth,%
      resized height=.33\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.1667\pgfphysicalheight}%
    }%
  \fi
}
\pgfpagesdeclarelayout{6 on 1}{%
  \edef\pgfpageoptionheight{\the\paperwidth} % landscaped by default
  \edef\pgfpageoptionwidth{\the\paperheight}
  \def\pgfpageoptionborder{0pt}
  \def\pgfpageoptionfirstshipout{1}
}{%
  \pgfpagesphysicalpageoptions{%
    logical pages=6,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth,%
    current logical shipout=\pgfpageoptionfirstshipout%
  }
  \ifdim\paperheight>\paperwidth\relax
    % put side-by-side
    \pgfpageslogicalpageoptions{1}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.1667\pgfphysicalwidth}{.25\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{3}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.25\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{5}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.8333\pgfphysicalwidth}{.25\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{2}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.1667\pgfphysicalwidth}{.75\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{4}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.5\pgfphysicalwidth}{.75\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{6}{%
      border shrink=\pgfpageoptionborder,%
      resized width=.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.8333\pgfphysicalwidth}{.75\pgfphysicalheight}%
    }%
  \else
    % stack on top of one another
    \pgfpageslogicalpageoptions{1}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.25\pgfphysicalwidth}{.8333\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{3}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.25\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{5}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.25\pgfphysicalwidth}{.1667\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{2}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.75\pgfphysicalwidth}{.8333\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{4}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.75\pgfphysicalwidth}{.5\pgfphysicalheight}%
    }%
    \pgfpageslogicalpageoptions{6}{%
      border shrink=\pgfpageoptionborder,%
      resized width=0.5\pgfphysicalwidth,%
      resized height=\pgfphysicalheight,%
      center=\pgfpoint{.75\pgfphysicalwidth}{.1667\pgfphysicalheight}%
    }%
  \fi
}

% In handout mode, place 6 slides per page.
\iftoggle{js@handout}{%
  \pgfpagesuselayout{6 on 1}[letterpaper,border shrink=5mm]}{}

% Standard packages.
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{verbatim}
\RequirePackage{fixltx2e}

% Font selection. lmodern is loaded first for backup symbols in e.g. math.
\RequirePackage{lmodern}
\RequirePackage[fullfamily,opticals,lf]{MinionPro}
\RequirePackage[lf]{MyriadPro}

% Beamer theming.
\useinnertheme{default}
\useoutertheme{infolines}
\setbeamertemplate{headline}{}
\iftoggle{js@pageno}{%
  \newcommand{\insertfootnumber}{\insertpagenumber}}{%
  \newcommand{\insertfootnumber}{\insertframenumber}}
\defbeamertemplate{footline}{titlepagesection}{
  \begin{beamercolorbox}[colsep=1.5pt]{upper separation line foot}
  \end{beamercolorbox}
  \begin{beamercolorbox}%
    [ht=2.5ex,dp=1.125ex,leftskip=.25cm,rightskip=.25cm plus 1fil]%
    {title in head/foot}
    \makebox[0pt][l]{%
      \usebeamerfont{title in head/foot}%
      %\usebeamercolor[fg]{title in head/foot}%
      \insertshorttitle}
    \hspace*{\fill}\llap{%
      \usebeamerfont{page number in head/foot}%
      %\usebeamercolor[fg]{page number in head/foot}%
      \insertfootnumber}
  \end{beamercolorbox}
  \begin{beamercolorbox}[colsep=1.5pt]{lower separation line foot}
  \end{beamercolorbox}
}
\setbeamertemplate{footline}[titlepagesection]
\setbeamercolor*{structure}{}
\iftoggle{js@nav}{}{\setbeamertemplate{navigation symbols}{}}

% Discourage hyphenation.
\hyphenpenalty=5000
\tolerance=1000

% Reduced itemize indentation.
\setlength{\leftmargini}{1em}
\setlength{\leftmarginii}{1em}
\setlength{\leftmarginiii}{1em}

% Figures, tables, and decoration.
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{multirow}
\RequirePackage{gensymb}
\RequirePackage{tikz}

% As a convenience, change \maketitle to emit the title slide.
\renewcommand{\maketitle}{\begin{frame}[plain] \titlepage \end{frame}}

% Change the shade of red used by \alert.
\definecolor{JCLRed}{RGB}{165,17,16}
\setbeamercolor{alerted text}{fg=JCLRed}

% Change \emph to make stuff green.
\definecolor{JCLGreen}{RGB}{0,112,1}
\setbeamercolor{emphasized text}{fg=JCLGreen}
\renewcommand{\emph}[1]{\textcolor{JCLGreen}{#1}}
\newenvironment{emphenv}{\begin{altenv}{%
  \usebeamertemplate{emphasized text begin}%
  \usebeamercolor[fg]{emphasized text}%
  \usebeamerfont{emphasized text}
}{%
  \usebeamertemplate{emphasized text end}%
}{%
  \color{.}%
}{}}{\end{altenv}}

% Positive counterpart to alert that makes stuff blue.
\definecolor{JCLBlue}{RGB}{0,83,193}
\setbeamercolor{good text}{fg=JCLBlue}
\newcommand{\good}[1]{\textcolor{JCLBlue}{#1}}
\newenvironment{goodenv}{\begin{altenv}{%
  \usebeamertemplate{good text begin}%
  \usebeamercolor[fg]{good text}%
  \usebeamerfont{good text}
}{%
  \usebeamertemplate{good text end}%
}{%
  \color{.}%
}{}}{\end{altenv}}

% De-emphasis that makes stuff grey.
\definecolor{JCLGrey}{RGB}{128,128,128}
\setbeamercolor{deemphasized text}{fg=JCLGrey}
\newcommand{\deemph}[1]{\textcolor{JCLGrey}{#1}}
\newenvironment{deemphenv}{\begin{altenv}{%
  \usebeamertemplate{deemphasized text begin}%
  \usebeamercolor[fg]{deemphasized text}%
  \usebeamerfont{deemphasized text}
}{%
  \usebeamertemplate{deemphasized text end}%
}{%
  \color{.}%
}{}}{\end{altenv}}

% Macro to spread out items in the current environment.
\newcommand{\spreaditems}{\setlength{\itemsep}{\fill}}

% Circled numerals.
\newcommand*{\titlecircled}[1]{%
  \tikz[baseline={([yshift=-0.05em] char.base)}]{%
  \node[shape=circle, draw, inner sep=1pt] (char) {\large #1};}}

\endinput
