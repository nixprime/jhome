% vim: set ft=tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% jpaper.cls - v2.0.2 - 9 November 2012
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
% jpaper provides a template class for papers that satisfy the requirements of
% many current computer architecture conferences: 10pt Times New Roman,
% single-spaced lines, two-column, 0.75" side margins, 1" top and bottom
% margins. By default, jpaper emits documents that are suitable for
% camera-ready submission to IEEE PDF-eXpress.
%
% In addition to the usual options leqno and fleqn, jpaper also provides the
% following additional flags (each of which can be turned on by specifying the
% flag as an option, or turned off by specifying "no"flag as an option):
%
% * anonymous: Hide the authors field in the title block. Off by default.
%
% * bfcaption: Captions (for figures and tables) always use the sans-serif
%   face; this option controls whether or not they are in bold as well. You
%   should probably leave this option on if using Helvetica, the default
%   sans-serif typeface. On by default.
%
% * compact: Enables tighter spacing in certain contexts while remaining
%   aesthetically acceptable. This option is provided for things like class
%   papers and is not recommended for professional work. Off by default.
%
% * courier: Uses Courier for the monospaced typeface. This is not recommended
%   unless you really love Courier, since the psfnss version of Courier (which
%   this uses) is unnaturally huge, while Latin Modern Typewriter (which is
%   used otherwise) is scaled correctly by default.
%
% * date: Enables the date field in the title block. Most papers do not have a
%   field for the date. The date option is provided for those documents that
%   do. Off by default.
%
% * hyperref: Enables the hyperref package. While the hyperref package is
%   convenient for your readers, IEEE PDF-eXpress does not allow it. Off by
%   default.
%
% * lineno: Enables line numbering. This may be useful while editing. Off by
%   default.
%
% * pageno: Enables page numbering. This is useful for standalone documents
%   (technical reports, etc.) but not for papers that appear in conference
%   proceedings or journals, since these provide their own page numbers. Off by
%   default.
%
% * tabcaptbelow: Makes the spacing correct for table captions that are placed
%   *below* tables. When this option is off, spacing is correct for table
%   captions *above* tables. Off by default. "tabcaptabove" is synonymous with
%   "notabcaptbelow".
%
% * version: If version control information is available in a version.tex file,
%   include version information in the document footer. Very useful for drafts.
%   Off by default.
%
% * orphans: Allows orphans (single lines at the beginning of a page or column)
%   to exist. On by default.
%
% * widows: Allows widows (single lines at the end of a page or column) to
%   exist. On by default.
%
% Widows and orphans have separate flags because orphans are sometimes
% considered more acceptable than widows; for example, the Chicago Manual of
% Style, 11th Edition accepts orphans but not widows.
%
% For font sizes, jpaper supports 8pt, 9pt, 10pt, 11pt, 12pt, 14pt, 17pt, and
% 20pt. Use of sizes other than 10pt, 11pt, and 12pt requires the extsizes
% LaTeX package to be installed, although this is common.
%
% jpaper also provides the following special meta-options:
%
% * submission: Equivalent to "anonymous,hyperref,pageno". Intended for
%   submissions for blind review.
%
% * camera: No-op. This option is provided for backward compatibility to v1.x,
%   for which submission and camera were distinctly different modes.
%
% * final: Equivalent to "hyperref,pageno". Intended for the standalone, online
%   version of a camera-ready paper.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jpaper}[2012/09/26 v2.0.1 Paper template class]

% Taken from etoolbox.sty (v2.1, 2011/01/03, by Philipp Lehman).
\RequirePackage{etex}
\newcommand{\cslet}[2]{\expandafter\let\csname#1\endcsname#2}
\let\jp@bool@true\@firstoftwo
\let\jp@bool@false\@secondoftwo
\newcommand*{\jp@newtoggle}[1]{\cslet{jp@tgl@#1}\jp@bool@false}
\newcommand*{\jp@toggletrue}[1]{\cslet{jp@tgl@#1}\jp@bool@true}
\newcommand*{\jp@togglefalse}[1]{\cslet{jp@tgl@#1}\jp@bool@false}
\newcommand*{\jp@iftoggle}[1]{\csname jp@tgl@#1\endcsname}

% Feature detection flags.
\newcommand*{\jp@newfiletoggle}[2]{\IfFileExists{#2}{%
  \jp@toggletrue{#1}}{%
  \jp@togglefalse{#1}}}
\jp@newfiletoggle{jp@have@microtype}{microtype.sty}
\jp@newfiletoggle{jp@have@siunits}{SIunits.sty}
\jp@newfiletoggle{jp@have@tikz}{tikz.sty}
\jp@newfiletoggle{jp@have@ulem}{ulem.sty}
\jp@newfiletoggle{jp@have@url}{url.sty}
\jp@newfiletoggle{jp@have@version}{version.tex}

% Configuration flags.
\jp@newtoggle{jp@anonymous}
\jp@newtoggle{jp@bfcaption}
\jp@newtoggle{jp@compact}
\jp@newtoggle{jp@courier}
\jp@newtoggle{jp@date}
\jp@newtoggle{jp@extsizes}
\jp@newtoggle{jp@hyperref}
\jp@newtoggle{jp@lineno}
\jp@newtoggle{jp@pageno}
\jp@newtoggle{jp@tabcaptbelow}
\jp@newtoggle{jp@version}
\jp@newtoggle{jp@orphans}
\jp@newtoggle{jp@widows}
\newcommand{\jp@ptsize}{10pt}

% Basic options.
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{anonymous}{\jp@toggletrue{jp@anonymous}}
\DeclareOption{noanonymous}{\jp@togglefalse{jp@anonymous}}
\DeclareOption{bfcaption}{\jp@toggletrue{jp@bfcaption}}
\DeclareOption{nobfcaption}{\jp@togglefalse{jp@bfcaption}}
\DeclareOption{compact}{\jp@toggletrue{jp@compact}}
\DeclareOption{nocompact}{\jp@togglefalse{jp@compact}}
\DeclareOption{courier}{\jp@toggletrue{jp@courier}}
\DeclareOption{nocourier}{\jp@togglefalse{jp@courier}}
\DeclareOption{date}{\jp@toggletrue{jp@date}}
\DeclareOption{nodate}{\jp@togglefalse{jp@date}}
\DeclareOption{hyperref}{\jp@toggletrue{jp@hyperref}}
\DeclareOption{nohyperref}{\jp@togglefalse{jp@hyperref}}
\DeclareOption{lineno}{\jp@toggletrue{jp@lineno}}
\DeclareOption{nolineno}{\jp@togglefalse{jp@lineno}}
\DeclareOption{pageno}{\jp@toggletrue{jp@pageno}}
\DeclareOption{nopageno}{\jp@togglefalse{jp@pageno}}
\DeclareOption{tabcaptbelow}{\jp@toggletrue{jp@tabcaptbelow}}
\DeclareOption{notabcaptbelow}{\jp@togglefalse{jp@tabcaptbelow}}
\DeclareOption{tabcaptabove}{\jp@togglefalse{jp@tabcaptbelow}}
\DeclareOption{version}{\jp@toggletrue{jp@version}}
\DeclareOption{noversion}{\jp@togglefalse{jp@version}}
\DeclareOption{orphans}{\jp@toggletrue{jp@orphans}}
\DeclareOption{noorphans}{\jp@togglefalse{jp@orphans}}
\DeclareOption{widows}{\jp@toggletrue{jp@widows}}
\DeclareOption{nowidows}{\jp@togglefalse{jp@widows}}

% Font size options.
\DeclareOption{8pt}{%
  \renewcommand{\jp@ptsize}{8pt}
  \jp@toggletrue{jp@extsizes}}
\DeclareOption{9pt}{%
  \renewcommand{\jp@ptsize}{9pt}
  \jp@toggletrue{jp@extsizes}}
\DeclareOption{10pt}{%
  \renewcommand{\jp@ptsize}{10pt}
  \jp@togglefalse{jp@extsizes}}
\DeclareOption{11pt}{%
  \renewcommand{\jp@ptsize}{11pt}
  \jp@togglefalse{jp@extsizes}}
\DeclareOption{12pt}{%
  \renewcommand{\jp@ptsize}{12pt}
  \jp@togglefalse{jp@extsizes}}
\DeclareOption{14pt}{%
  \renewcommand{\jp@ptsize}{14pt}
  \jp@toggletrue{jp@extsizes}}
\DeclareOption{17pt}{%
  \renewcommand{\jp@ptsize}{17pt}
  \jp@toggletrue{jp@extsizes}}
\DeclareOption{20pt}{%
  \renewcommand{\jp@ptsize}{20pt}
  \jp@toggletrue{jp@extsizes}}

% Combined options.
\DeclareOption{default}{%
  \jp@togglefalse{jp@anonymous}
  \jp@toggletrue{jp@bfcaption}
  \jp@togglefalse{jp@compact}
  \jp@togglefalse{jp@courier}
  \jp@togglefalse{jp@date}
  \jp@togglefalse{jp@extsizes}
  \jp@togglefalse{jp@hyperref}
  \jp@togglefalse{jp@lineno}
  \jp@togglefalse{jp@pageno}
  \jp@togglefalse{jp@tabcaptbelow}
  \jp@togglefalse{jp@version}
  \jp@toggletrue{jp@orphans}
  \jp@toggletrue{jp@widows}
}
\DeclareOption{submission}{%
  \jp@toggletrue{jp@anonymous}
  \jp@toggletrue{jp@hyperref}
  \jp@toggletrue{jp@pageno}
}
\DeclareOption{camera}{}
\DeclareOption{final}{%
  \jp@toggletrue{jp@hyperref}
  \jp@toggletrue{jp@pageno}
}

% Process options.
\ExecuteOptions{default}
\ProcessOptions

% Load the underlying article class.
\jp@iftoggle{jp@extsizes}{%
  \LoadClass[letterpaper,\jp@ptsize,twocolumn]{extarticle}}{%
  \LoadClass[letterpaper,\jp@ptsize,twocolumn]{article}}

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
\jp@iftoggle{jp@courier}{\RequirePackage{courier}}{}

% Taken from leading.sty (v0.3, 2008/12/11, by Will Robertson).
\RequirePackage{calc}
\newcommand\jp@leading[1]{%
  \begingroup
    \@tempdima=\f@baselineskip\relax
    \@tempdimb=#1\relax
    \setlength\@tempdimc{1pt*\ratio{\@tempdimb}{\@tempdima}}%
    \global\@tempdimc=\@tempdimc
  \endgroup
  \linespread{\strip@pt\@tempdimc}\selectfont\ignorespaces}

% Leading and microtypography.
\setlength{\parindent}{1em}
\RequirePackage{setspace}
\jp@iftoggle{jp@compact}{%
  \newcommand{\normalspacing}{\jp@leading{1.125em}}}{%
  \newcommand{\normalspacing}{\singlespace}}
\jp@iftoggle{jp@have@microtype}{\RequirePackage{microtype}}{}

% Orphan and widow control.
\jp@iftoggle{jp@orphans}{}{\clubpenalty=10000}
\jp@iftoggle{jp@widows}{}{\widowpenalty=10000}

% Page margins: 3/4" left and right, 1" top and bottom.
\RequirePackage{geometry}
\geometry{lmargin=0.75in,rmargin=0.75in,tmargin=1in,bmargin=1in}

% 1/4" space between columns.
\setlength{\columnsep}{0.25in}

% If anonymous is set, override the document author setting to ensure that the
% user-provided value never sees the light of day.
\jp@iftoggle{jp@anonymous}{\author{}\renewcommand{\author}[1]{}}{}

% Title formatting.
\RequirePackage{titling}
\setlength{\droptitle}{-3.5em}
\pretitle{\begin{center}\normalfont\Large\bfseries}
\posttitle{\par\end{center}}
\preauthor{\begin{center}\normalfont\large%
  \begin{tabular}[t]{c}}
\postauthor{\end{tabular}\par\end{center}}
\jp@iftoggle{jp@date}{%
  \predate{\begin{center}\normalfont}
  \postdate{\end{center}}
}{%
  \predate{}
  \postdate{}
  \date{}
  \let\date=\relax
}

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
\jp@iftoggle{jp@compact}{%
  \setlength{\sectionspace}{4pt plus 5pt minus 3pt}}{%
  \setlength{\sectionspace}{8pt plus 2pt minus 6pt}}
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

% Remove spacing between bibliography entries and use 8pt font. Adapted from
% http://dcwww.camd.dtu.dk/~schiotz/comp/LatexTips/LatexTips.html
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
\jp@iftoggle{jp@pageno}{\fancyfoot[C]{\thepage}}{}
\jp@iftoggle{jp@have@version}{}{\jp@togglefalse{jp@version}}
\jp@iftoggle{jp@version}{%
  \input{version}
  \fancyfoot[L]{\jp@revision}
  \fancyfoot[R]{\jp@datetime}
}{}
\pagestyle{fancy}

% Line numbering.
\jp@iftoggle{jp@lineno}{%
  \RequirePackage{lineno}
  \renewcommand{\linenumberfont}{\normalfont\tt\small}
  \newcommand{\jp@mt@lineno}{\linenumbers}
}{%
  \newcommand{\jp@mt@lineno}{}
}

% Replace maketitle to invoke settings for leading, page numbering, and line
% numbering.
\let\jp@maketitle\maketitle
\renewcommand{\maketitle}{%
  \jp@maketitle%
  \jp@mt@lineno%
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
\jp@iftoggle{jp@hyperref}{%
  \RequirePackage{hyperref}
  \hypersetup{%
    unicode=true,%
    pdfstartview={FitH},%
    colorlinks=true,%
    citecolor=black,%
    filecolor=black,%
    linkcolor=black,%
    urlcolor=black}
}{}
\jp@iftoggle{jp@have@url}{\RequirePackage{url}}{}

% Utility packages.
\jp@iftoggle{jp@have@siunits}{\RequirePackage[squaren]{SIunits}}{}
\jp@iftoggle{jp@have@tikz}{\RequirePackage{tikz}}{}
\jp@iftoggle{jp@have@ulem}{\RequirePackage[normalem]{ulem}}{}

% Command for formatting author emails in the author block.
\newcommand{\authemail}[1]{{\large\texttt{#1}}}

\endinput
