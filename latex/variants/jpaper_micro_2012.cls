% vim: set ft=tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% jpaper_micro_2012.cls - MICRO-45 2012 camera-ready - 26 September 2012
%% Based on jpaper.cls v. 2.0.1 (https://github.com/nixprime/jhome)
%% Copyright 2012 Jamie Liu <jliu@nixprime.com>
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
% jpaper_micro_2012 provides a template class suitable for final submission to
% the 45th Annual IEEE/ACM International Symposium on Microarchitecture
% (MICRO-45), 2012. By default, jpaper emits documents that are suitable for
% camera-ready submission to IEEE PDF-eXpress.
%
% In addition to the usual options leqno and fleqn, jpaper also provides the
% following additional flags (each of which can be turned on by specifying the
% flag as an option, or turned off by specifying "no"flag as an option):
%
% * bfcaption: Captions (for figures and tables) always use the sans-serif
%   face; this option controls whether or not they are in bold as well. You
%   should probably leave this option on if using Helvetica, the default
%   sans-serif typeface. On by default.
%
% * final: Enables the hyperref package and page numbering. This option is
%   intended for the standalone, online version of the camera-ready paper, if
%   you choose to provide one.
%
% * tabcaptbelow: Makes the spacing correct for table captions that are placed
%   *below* tables. When this option is off, spacing is correct for table
%   captions *above* tables. Off by default. "tabcaptabove" is synonymous with
%   "notabcaptbelow".

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jpaper}[2012/09/26 MICRO-45 camera-ready template class]

% Taken from etoolbox.sty (v2.1, 2011/01/03, by Philipp Lehman).
\RequirePackage{etex}
\newcommand{\cslet}[2]{\expandafter\let\csname#1\endcsname#2}
\let\jp@bool@true\@firstoftwo
\let\jp@bool@false\@secondoftwo
\newcommand*{\jp@newtoggle}[1]{\cslet{jp@tgl@#1}\jp@bool@false}
\newcommand*{\jp@toggletrue}[1]{\cslet{jp@tgl@#1}\jp@bool@true}
\newcommand*{\jp@togglefalse}[1]{\cslet{jp@tgl@#1}\jp@bool@false}
\newcommand*{\jp@iftoggle}[1]{\csname jp@tgl@#1\endcsname}

% Configuration flags.
\jp@newtoggle{jp@bfcaption}
\jp@newtoggle{jp@final}
\jp@newtoggle{jp@tabcaptbelow}

% Options.
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{bfcaption}{\jp@toggletrue{jp@bfcaption}}
\DeclareOption{nobfcaption}{\jp@togglefalse{jp@bfcaption}}
\DeclareOption{final}{\jp@toggletrue{jp@final}}
\DeclareOption{nofinal}{\jp@togglefalse{jp@final}}
\DeclareOption{tabcaptbelow}{\jp@toggletrue{jp@tabcaptbelow}}
\DeclareOption{notabcaptbelow}{\jp@togglefalse{jp@tabcaptbelow}}
\DeclareOption{tabcaptabove}{\jp@togglefalse{jp@tabcaptbelow}}

% Process options.
\DeclareOption{default}{%
  \jp@toggletrue{jp@bfcaption}
  \jp@togglefalse{jp@final}
  \jp@togglefalse{jp@tabcaptbelow}
}
\ExecuteOptions{default}
\ProcessOptions

% Load the underlying article class.
\LoadClass[letterpaper,9pt,twocolumn]{extarticle}

% Standard packages.
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{verbatim}
\RequirePackage{fixltx2e}
\RequirePackage[usenames,dvipsnames,svgnames,table]{xcolor}

% Font selection. Load lmodern first to replace CM for any glyphs not provided
% by another package, and to provide LModern TT. Fonts are scaled for optical
% consistency.
\RequirePackage{lmodern}
\RequirePackage{mathptmx}
\RequirePackage[scaled=0.833]{helvet}

% Leading and microtypography.
\setlength{\parindent}{1em}
\RequirePackage{setspace}
\newcommand{\normalspacing}{\singlespace}
\RequirePackage{microtype}

% Page margins: 3/4" left and right, 1" top and bottom.
\RequirePackage{geometry}
\geometry{lmargin=0.75in,rmargin=0.75in,tmargin=1in,bmargin=1in}

% 1/4" space between columns.
\setlength{\columnsep}{0.25in}

% Title formatting.
\RequirePackage{titling}
\setlength{\droptitle}{-3.5em}
\pretitle{\begin{center}\normalfont\Large\bfseries}
\posttitle{\par\end{center}}
\preauthor{\begin{center}\normalfont\large%
  \begin{tabular}[t]{c}}
\postauthor{\end{tabular}\par\end{center}}
\predate{}
\postdate{}
\date{}
\let\date=\relax

% Compress vertical space around section and subsection headings. Make
% subsubsection headings run-in (i.e. part of the following paragraph).
\RequirePackage[compact]{titlesec}
\titleformat{\section}[hang]{\normalfont\large\bfseries}{\thesection. }%
  {0pt}{}{}
\titleformat{\subsection}[hang]{\normalfont\bfseries}{\thesubsection. }%
  {0pt}{}{}
\titleformat{\subsubsection}[runin]{\normalfont\bfseries}{\thesubsubsection. }%
  {0pt}{}{}
\newlength{\sectionspace}
\setlength{\sectionspace}{7pt plus 2pt minus 6pt}
\titlespacing*{\section}{0pt}{\sectionspace}{\sectionspace}
\titlespacing*{\subsection}{0pt}{\sectionspace}{\sectionspace}
\titlespacing*{\subsubsection}{0pt}{\parskip}{0.25em plus 0.1em minus 0.05em}

% The abstract should be normally sized and italicized. Abstract leading
% should, in general, follow the normal leading.
\titleclass{\centersection}{straight}[\chapter]
\titleformat{\centersection}[hang]{\normalfont\large\bfseries\centering}{}%
  {0pt}{}{}
\titlespacing*{\centersection}{0pt}{\sectionspace}{\sectionspace}
\newcommand{\abstractspacing}{\normalspacing}
\renewenvironment{abstract}{%
  \centersection*{Abstract}
  \normalfont\itshape\abstractspacing
}{}

% Compress itemize and enumerate environments.
\RequirePackage{enumerate}
\RequirePackage{enumitem}
\setlist{noitemsep, leftmargin=*, topsep=0pt, partopsep=0pt}

% Remove spacing between bibliography entries and use smaller font. Adapted
% from http://dcwww.camd.dtu.dk/~schiotz/comp/LatexTips/LatexTips.html
\renewenvironment{thebibliography}[1]{%
  \section*{\refname\@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}}%
    \scriptsize \list{\@biblabel{\@arabic\c@enumiv}}{%
      \settowidth\labelwidth{\@biblabel{#1}}%
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
      \itemsep\z@skip
      \parsep\z@skip
      \@openbib@code
      \usecounter{enumiv}%
      \let\p@enumiv\@empty
      \renewcommand\theenumiv{\@arabic\c@enumiv}}%
    \sloppy\clubpenalty4000\widowpenalty4000%
    \sfcode`\.\@m
}{%
  \def\@noitemerr{\@latex@warning{Empty `thebibliography' environment}}%
  \endlist
}

% This is IEEEtran's bibliography formatting control macro.
\def\bstctlcite{\@ifnextchar[{\@bstctlcite}{\@bstctlcite[@auxout]}}
\def\@bstctlcite[#1]#2{\@bsphack
  \@for\@citeb:=#2\do{%
    \edef\@citeb{\expandafter\@firstofone\@citeb}%
    \if@filesw\immediate\write\csname #1\endcsname%
      {\string\citation{\@citeb}}\fi}%
  \@esphack}

% Settings for figures and tables. Figure captions are placed below the figure,
% while table captions are placed above the table. All captions are sans-serif.
\jp@iftoggle{jp@bfcaption}{%
  \RequirePackage[font={normalsize,sf,bf,stretch=0.8}, format=hang]{caption}}{%
  \RequirePackage[font={normalsize,sf,stretch=0.8}, format=hang]{caption}}
\RequirePackage[position=bottom]{subfig}
\captionsetup[figure]{aboveskip=0.5em, belowskip=0em}
\jp@iftoggle{jp@tabcaptbelow}{%
  \captionsetup[table]{aboveskip=0.5em, belowskip=0em}}{%
  \captionsetup[table]{aboveskip=0.5em, belowskip=0.5em}}
\captionsetup[subfloat]{font={small,sf}}
\setcounter{topnumber}{2}
\setcounter{dbltopnumber}{2}
\setcounter{bottomnumber}{2}
\setcounter{totalnumber}{4}
\renewcommand{\topfraction}{0.85}
\renewcommand{\dbltopfraction}{0.9}
\renewcommand{\bottomfraction}{0.85}
\renewcommand{\textfraction}{0.07}
\renewcommand{\floatpagefraction}{0.85}
\renewcommand{\dblfloatpagefraction}{0.85}
\setlength{\floatsep}{0.5em plus 0.2em minus 0.2em}
\setlength{\dblfloatsep}{0.5em plus 0.2em minus 0.2em}
\setlength{\textfloatsep}{0.5em plus 0.2em minus 0.2em}
\setlength{\dbltextfloatsep}{0.5em plus 0.2em minus 0.2em}
% Utility packages for floats and tables.
\RequirePackage{float}
\RequirePackage{graphicx}
\RequirePackage{booktabs}
\RequirePackage{multirow}

% Page headers and footers.
\RequirePackage{fancyhdr}
\fancyhead{}
\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\jp@iftoggle{jp@final}{\fancyfoot[C]{\thepage}}{}
\pagestyle{fancy}

% Replace maketitle to invoke settings for leading, page numbering, and line
% numbering.
\let\jp@maketitle\maketitle
\renewcommand{\maketitle}{%
  \jp@maketitle%
  \thispagestyle{fancy}%
  \normalspacing}

% Footnotes may not span pages.
\interfootnotelinepenalty=10000

% Formatting for margin notes (which you may find useful during editing).
\let\jp@marginpar\marginpar
\renewcommand\marginpar[1]{\jp@marginpar%
  [\raggedleft\singlespacing\footnotesize\color{red} #1]%
  {\raggedright\singlespacing\footnotesize\color{red} #1}}
\setlength{\marginparwidth}{0.65in}

% Link and URL formatting.
\jp@iftoggle{jp@final}{%
  \RequirePackage{hyperref}
  \hypersetup{%
    unicode=true,%
    pdfstartview={FitH},%
    colorlinks=true}
}{}
\RequirePackage{url}

% Scientific units.
\RequirePackage[squaren]{SIunits}

\endinput
