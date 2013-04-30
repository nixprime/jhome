% vim: set ft=tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% jpaper.cls - v2.2.0 - 29 April 2013
%% Copyright 2013 Jamie Liu <jliu@nixprime.com>
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
% * border: If turned off, page margins are set to nearly 0, and page size is
%   reduced to match. This option is intended for reading on smaller devices
%   such as tablets. If you want to turn this option off, you probably want to
%   use the "tablet" meta-option instead (described below). On by default.
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
% * marginnotes: Enables display of margin notes. This may be useful while
%   editing. On by default.
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
% jpaper uses Times New Roman, Helvetica, and Latin Modern Typewriter as
% default fonts; these can be overridden by defining the commands
% \jp@select@rm, \jp@select@sf, and \jp@select@tt respectively.
% For font sizes, jpaper supports 10pt (the default) and 9pt. Use of 9pt
% requires the extsizes LaTeX package to be installed, although this is common.
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
%
% * tablet: Equivalent to "noborder,hyperref,nolineno,nomarginnotes,nopageno".
%   Produces a document that is more readable on tablets. If you are using this
%   option, you should probably list it last in the options list, since
%   changing any of the options it sets (aside from hyperref) will break the
%   document horribly.
%
% Finally, jpaper provides the following space-reducing options, all of which
% are off by default (note that use of these options is strongly discouraged
% unless absolutely necessary, since they *will* have a negative impact on the
% aesthetic acceptability and readability of the document):
%
% * compact: Reduces the leading (line spacing). This is probably the most
%   dangerous space-reducing option, since this option is likely to have the
%   greatest impact on readability.
%
% * narrowgutter: Reduces the size of the gutter (space between columns). This
%   is probably the safest space-reducing option overall.
%
% * narrowmargins: Reduces the page margins. This option is extremely dangerous
%   for conference submissions; side margins are required to ensure that when a
%   page is bound into a book, no text on the sides is rendered unreadable due
%   to the binding, while page number will be printed in the bottom margin.
%   If your document is not a conference submission, this option is safe.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jpaper}[2013/04/29 v2.2.0 Paper template class]

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
\jp@newfiletoggle{jp@have@amsmath}{amsmath.sty}
\jp@newfiletoggle{jp@have@microtype}{microtype.sty}
\jp@newfiletoggle{jp@have@pgf}{pgf.sty}
\jp@newfiletoggle{jp@have@siunits}{SIunits.sty}
\jp@newfiletoggle{jp@have@tikz}{tikz.sty}
\jp@newfiletoggle{jp@have@ulem}{ulem.sty}
\jp@newfiletoggle{jp@have@url}{url.sty}
\jp@newfiletoggle{jp@have@version}{version.tex}

% Configuration flags.
\jp@newtoggle{jp@anonymous}
\jp@newtoggle{jp@bfcaption}
\jp@newtoggle{jp@border}
\jp@newtoggle{jp@compact}
\jp@newtoggle{jp@date}
\jp@newtoggle{jp@extsizes}
\jp@newtoggle{jp@hyperref}
\jp@newtoggle{jp@lineno}
\jp@newtoggle{jp@marginnotes}
\jp@newtoggle{jp@narrowgutter}
\jp@newtoggle{jp@narrowmargins}
\jp@newtoggle{jp@pageno}
\jp@newtoggle{jp@tabcaptbelow}
\jp@newtoggle{jp@version}
\jp@newtoggle{jp@orphans}
\jp@newtoggle{jp@widows}
\newcommand{\jp@ptsize}{10pt}
\newlength{\jp@normalsize}

% Basic options.
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{anonymous}{\jp@toggletrue{jp@anonymous}}
\DeclareOption{noanonymous}{\jp@togglefalse{jp@anonymous}}
\DeclareOption{bfcaption}{\jp@toggletrue{jp@bfcaption}}
\DeclareOption{nobfcaption}{\jp@togglefalse{jp@bfcaption}}
\DeclareOption{border}{\jp@toggletrue{jp@border}}
\DeclareOption{noborder}{\jp@togglefalse{jp@border}}
\DeclareOption{compact}{\jp@toggletrue{jp@compact}}
\DeclareOption{nocompact}{\jp@togglefalse{jp@compact}}
\DeclareOption{date}{\jp@toggletrue{jp@date}}
\DeclareOption{nodate}{\jp@togglefalse{jp@date}}
\DeclareOption{hyperref}{\jp@toggletrue{jp@hyperref}}
\DeclareOption{nohyperref}{\jp@togglefalse{jp@hyperref}}
\DeclareOption{lineno}{\jp@toggletrue{jp@lineno}}
\DeclareOption{nolineno}{\jp@togglefalse{jp@lineno}}
\DeclareOption{marginnotes}{\jp@toggletrue{jp@marginnotes}}
\DeclareOption{nomarginnotes}{\jp@togglefalse{jp@marginnotes}}
\DeclareOption{narrowgutter}{\jp@toggletrue{jp@narrowgutter}}
\DeclareOption{nonarrowgutter}{\jp@togglefalse{jp@narrowgutter}}
\DeclareOption{narrowmargins}{\jp@toggletrue{jp@narrowmargins}}
\DeclareOption{nonarrowmargins}{\jp@togglefalse{jp@narrowmargins}}
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
\DeclareOption{9pt}{%
  \renewcommand{\jp@ptsize}{9pt}
  \setlength{\jp@normalsize}{9pt}
  \jp@toggletrue{jp@extsizes}}
\DeclareOption{10pt}{%
  \renewcommand{\jp@ptsize}{10pt}
  \setlength{\jp@normalsize}{10pt}
  \jp@togglefalse{jp@extsizes}}

% Meta-options.
\DeclareOption{default}{%
  \jp@togglefalse{jp@anonymous}
  \jp@toggletrue{jp@bfcaption}
  \jp@toggletrue{jp@border}
  \jp@togglefalse{jp@compact}
  \jp@togglefalse{jp@date}
  \jp@togglefalse{jp@extsizes}
  \jp@togglefalse{jp@hyperref}
  \jp@togglefalse{jp@lineno}
  \jp@toggletrue{jp@marginnotes}
  \jp@togglefalse{jp@narrowgutter}
  \jp@togglefalse{jp@narrowmargins}
  \jp@togglefalse{jp@pageno}
  \jp@togglefalse{jp@tabcaptbelow}
  \jp@togglefalse{jp@version}
  \jp@toggletrue{jp@orphans}
  \jp@toggletrue{jp@widows}
  \setlength{\jp@normalsize}{10pt}
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
\DeclareOption{tablet}{%
  \jp@togglefalse{jp@border}
  \jp@toggletrue{jp@hyperref}
  \jp@togglefalse{jp@lineno}
  \jp@togglefalse{jp@marginnotes}
  \jp@togglefalse{jp@pageno}
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
\RequirePackage{calc}

% Font selection. Load lmodern first to replace CM for any glyphs not provided
% by another package. Helvetica is scaled for optical consistency.
\RequirePackage{lmodern}
\providecommand{\jp@select@rm}{\RequirePackage{mathptmx}}
\providecommand{\jp@select@sf}{\RequirePackage[scaled=0.833]{helvet}}
\providecommand{\jp@select@tt}{} % LModern TT is already default
\jp@select@rm
\jp@select@sf
\jp@select@tt

% Set page margins and page size.
% Default page margins: 3/4" left and right, 1" top and bottom.
% Narrow page margins: 1/2" left, right, and top, 3/4" bottom.
% Noborder page margins: 5pt all sides.
\RequirePackage{geometry}
\newlength{\jp@sidemargin}
\newlength{\jp@topmargin}
\newlength{\jp@botmargin}
\jp@iftoggle{jp@narrowmargins}{%
  \setlength{\jp@sidemargin}{0.5in}
  \setlength{\jp@topmargin}{0.5in}
  \setlength{\jp@botmargin}{0.75in}
}{%
  \setlength{\jp@sidemargin}{0.75in}
  \setlength{\jp@topmargin}{1in}
  \setlength{\jp@botmargin}{1in}
}
\newlength{\jp@sidecut}
\newlength{\jp@topcut}
\newlength{\jp@botcut}
\jp@iftoggle{jp@border}{%
  \setlength{\jp@sidecut}{0pt}
  \setlength{\jp@topcut}{0pt}
  \setlength{\jp@botcut}{0pt}
}{%
  \newcommand{\jp@nobordermargin}{5pt}
  \setlength{\jp@sidecut}{\jp@sidemargin-\jp@nobordermargin}
  \setlength{\jp@topcut}{\jp@topmargin-\jp@nobordermargin}
  \setlength{\jp@botcut}{\jp@botmargin-\jp@nobordermargin}
  \setlength{\jp@sidemargin}{\jp@nobordermargin}
  \setlength{\jp@topmargin}{\jp@nobordermargin}
  \setlength{\jp@botmargin}{\jp@nobordermargin}
}
\newlength{\jp@paperwidth}
\newlength{\jp@paperheight}
\setlength{\jp@paperwidth}{8.5in-2.0\jp@sidecut}
\setlength{\jp@paperheight}{11in-\jp@topcut-\jp@botcut}
\geometry{%
  paperwidth=\jp@paperwidth,
  paperheight=\jp@paperheight,
  lmargin=\jp@sidemargin,
  rmargin=\jp@sidemargin,
  tmargin=\jp@topmargin,
  bmargin=\jp@botmargin
}

% The gutter size is 1/4" by default, and 1 pica (~1/6") with narrowgutter.
\jp@iftoggle{jp@narrowgutter}{%
  \setlength{\columnsep}{1pc}}{%
  \setlength{\columnsep}{0.25in}}

% Taken from leading.sty (v0.3, 2008/12/11, by Will Robertson).
\newcommand\jp@leading[1]{%
  \begingroup
    \@tempdima=\f@baselineskip\relax
    \@tempdimb=#1\relax
    \setlength\@tempdimc{1pt*\ratio{\@tempdimb}{\@tempdima}}%
    \global\@tempdimc=\@tempdimc
  \endgroup
  \linespread{\strip@pt\@tempdimc}\selectfont\ignorespaces}

% Leading and microtypography. Leading of 1.2x (10pt/12pt or 9pt/10.8pt)
% *should* be default, but we set it explicitly here to be safe.
\setlength{\parindent}{1em}
\RequirePackage{setspace}
\jp@iftoggle{jp@compact}{%
  \newcommand{\normalspacing}{\jp@leading{1.125\jp@normalsize}}}{%
  \newcommand{\normalspacing}{\jp@leading{1.2\jp@normalsize}}}
\jp@iftoggle{jp@have@microtype}{\RequirePackage{microtype}}{}

% Orphan and widow control.
\jp@iftoggle{jp@orphans}{}{\clubpenalty=10000}
\jp@iftoggle{jp@widows}{}{\widowpenalty=10000}

% If anonymous is set, override the document author setting to ensure that the
% user-provided value never sees the light of day.
\jp@iftoggle{jp@anonymous}{\author{}\renewcommand{\author}[1]{}}{}

% Title formatting.
\RequirePackage{titling}
\setlength{\droptitle}{-3.5em}
\pretitle{\begin{center}\normalfont\Large\bfseries}
\posttitle{\par\end{center}}
\let\jp@normal@and=\and
\preauthor{\begin{center}\normalfont\large\let\and=\quad%
  \begin{tabular}[t]{c}}
\postauthor{\end{tabular}\let\and=\jp@normal@and\par\end{center}}
\jp@iftoggle{jp@date}{%
  \predate{\begin{center}\normalfont}
  \postdate{\end{center}\vspace{-1em}}
}{%
  \predate{}
  \postdate{\vspace{-1em}}
  \date{}
  \renewcommand{\date}[1]{}
}

% Command for formatting author emails in the author block.
\newcommand{\authemail}[1]{{\large\texttt{#1}}}

% Compress vertical space around section and subsection headings. Make
% subsubsection headings run-in (i.e. part of the following paragraph).
\RequirePackage[compact]{titlesec}
\renewcommand{\thesubsubsection}{\arabic{subsubsection}}
\titleformat{\section}[hang]{\normalfont\large\bfseries}{\thesection. }%
  {0pt}{}{}
\titleformat{\subsection}[hang]{\normalfont\bfseries}{\thesubsection. }%
  {0pt}{}{}
\titleformat{\subsubsection}[runin]{\normalfont\bfseries}{\thesubsubsection. }%
  {0pt}{}{}
\newlength{\sectionspace}
\setlength{\sectionspace}{0.6\jp@normalsize %
  plus 0.6\jp@normalsize minus 0.4\jp@normalsize}
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

% Remove spacing between bibliography entries and use small font. Adapted from
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
  \fancyfoot[L]{\jp@versionid}
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

% Formatting for margin notes.
\let\jp@marginpar\marginpar
\jp@iftoggle{jp@marginnotes}{%
  \renewcommand\marginpar[1]{\jp@marginpar%
    [\raggedleft\singlespacing\footnotesize\color{red} #1]%
    {\raggedright\singlespacing\footnotesize\color{red} #1}}
  \jp@iftoggle{jp@narrowmargins}{%
    \setlength{\marginparwidth}{0.4in}}{%
    \setlength{\marginparwidth}{0.65in}}
}{%
  \renewcommand\marginpar[1]{}
}

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
\jp@iftoggle{jp@have@amsmath}{\RequirePackage{amsmath}}{}
\jp@iftoggle{jp@have@siunits}{\RequirePackage[squaren]{SIunits}}{}
\jp@iftoggle{jp@have@pgf}{\RequirePackage{pgf}}{}
\jp@iftoggle{jp@have@tikz}{%
  \RequirePackage{tikz}
  % Better circled numerals.
  \renewcommand*{\textcircled}[1]{%
    \tikz[baseline={([yshift=-0.1em] char.base)}]{%
        \node[shape=circle, draw, inner sep=0.1em] (char) {\scriptsize #1};}}
}{}
\jp@iftoggle{jp@have@ulem}{\RequirePackage[normalem]{ulem}}{}

\endinput
