\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mitthesis}[2026/01/01 Minimal proxy for report class]

% Ignore these specific keys passed from main.tex
\DeclareOption{fontset=newtx}{\relax}
\DeclareOption{mydesign=mydesign}{\relax}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\LoadClass[12pt,twoside]{report}
\RequirePackage{geometry}
\RequirePackage{hyperref}

% The original mitthesis.cls loaded mydesign.tex automatically if the option was passed.
% We will load it here to ensure the ASU styling is applied.
\InputIfFileExists{mydesign.tex}{}{}