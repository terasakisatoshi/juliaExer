%%
%% Taken from 
%% https://github.com/JunoLab/Weave.jl/blob/master/templates/julia_tex.tpl
%%
%% We've applied GenKuroki-san's patch
%% https://gist.github.com/genkuroki/479a1fec113035f05c661675eee8b830
%%


% \documentclass[12pt,a4paper]{article}
\documentclass[12pt,a4paper,xelatex,ja=standard]{bxjsarticle}
% \usepackage[a4paper,text={16.5cm,25.2cm},centering]{geometry}
\geometry{top=1cm, bottom=1cm, left=2cm, right=2cm}
\usepackage{lmodern}
\usepackage{amssymb,amsmath}
\usepackage{bm}
\usepackage{graphicx}
\usepackage{microtype}
\usepackage{hyperref}
\setlength{\parindent}{0pt}
\setlength{\parskip}{1.2ex}

\hypersetup
       {   pdfauthor = { {{{:author}}} },
           pdftitle={ {{{:title}}} },
           colorlinks=TRUE,
           linkcolor=black,
           citecolor=blue,
           urlcolor=blue
       }

{{#:title}}
\title{ {{{ :title }}} }
{{/:title}}

{{#:author}}
\author{ {{{ :author }}} }
{{/:author}}

{{#:date}}
\date{ {{{ :date }}} }
{{/:date}}

{{ :highlight }}

\begin{document}

{{#:title}}\maketitle{{/:title}}

\tableofcontents

{{{ :body }}}

\end{document}
