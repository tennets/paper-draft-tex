# **paper-draft-tex**

*paper-draft-tex* showcases how you might want to structure the draft of your scientific paper in LaTex.

It helped me structure my ideas and results to share them effectively with my supervisors before formatting the manuscript according to the journal template.

This work is under the [MIT License](LICENSE) and adapts [these tips](https://github.com/Wookai/paper-tips-and-tricks). The source code is written in Matlab. 

## Table of Contents
- [How *template* is structured?](#how-template-is-structured)
- [Typesetting](#typesetting)
- [Math notation](#math-notation)
- [Bibliography](#bibliography)
- [Figures](#figures)

## How *template* is structured?


```bash
.
|-- main.tex
|
|-- src/
|    |-- abstract.tex
|    |-- bibliography.bib
|    |-- discussion.tex
|    |-- introduction.tex
|    |-- materials-and-methods.tex
|    |-- matlab/
|    |      |-- ffsp.m
|    |-- results.tex
|
|-- fig/
|    |-- nice-cat.jpg
|    |-- sparsity.eps
```

## Typesetting

- One sentence per line in your source file. For example
    ```
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Interdum velit laoreet id donec ultrices tincidunt.
    ```
    It is easier to source control and collaborate.
- Select the correct Capitalization style for the title, subtitle, sections, and subsections with [this tool](https://capitalizemytitle.com/).
- Keep **reference**d object and reference number in the same line with the tilde `~` character. 
    ```
    Section~\ref{sec:problem-statement} talks about ...
    ```
    It avoids ugly line breaks. 
    Consider adding what you need in your preamble
    ```
    \newcommand{\refalg}[1]{Algorithm~\ref{#1}}
    \newcommand{\refapp}[1]{Appendix~\ref{#1}}
    \newcommand{\refchap}[1]{Chapter~\ref{#1}}
    \newcommand{\refeq}[1]{Equation~\ref{#1}}
    \newcommand{\reffig}[1]{Figure~\ref{#1}}
    \newcommand{\refsec}[1]{Section~\ref{#1}}
    \newcommand{\reftab}[1]{Table~\ref{#1}}
    ```

    Now you can write
    ```
    \refsec{sec:problem-statement} talks about ...
    ```
- For **tables**, use [booktabs](https://www.ctan.org/pkg/booktabs) package. 
  Simple, minimalistic tables look nicer. Further details [here](https://people.inf.ethz.ch/markusp/teaching/guides/guide-tables.pdf).
- Format **number** with the [siunitx](https://ctan.org/pkg/siunitx) package. 
    Use it to round up
    ```
    \usepackage{siunitx}

    % ...

    \sisetup{
        round-mode = places,
        round-precision = 3
    }  
    ```
    and to align numbers in tables.
    ```
    \usepackage{booktabs}
    \usepackage{siunitx}

    % ...

    \begin{table}
        \centering
        \begin{tabular}{lS}
            \toprule
            Letter & {Number} \\% headers of S columns have to be in {}
            \midrule
            A & 1.34092 \\
            B & 2.234000 \\
            C & 3.73333 \\
            \bottomrule
        \end{tabular}
        \caption{Numbers alignment with \texttt{siunitx}.}
    \end{table}
    ```


## Math notation

- Define variables with the [fixmath](https://www.ctan.org/pkg/fixmath) package

    | Scalars | Vectors | Matrices | Random Varibales
    |--------------|-----------|--------------|-----------|
    |`$x$`|`$\mathbold{x}$`|`$\mathbold{X}$`|`$X$`|

- Add superscripts or subscripts to variables *outside* of the styling:

    | Good | Bad |
    |--------------|-----------|
    | `$\mathbold{x}_i$` | `$\mathbold{x_i}$` 

- Define your custom commands to shortcut math notation and make the source LaTex more readable, especially if you have variables that you use a lot.

    ```
    \renewcommand{\vec}[1]{\mathbold{#1}} % for vector
    \newcommand{\mat}[1]{\mathbold{#1}}   % and matrices
    ```

## Bibliography

For drafting purposes, set

```
\usepackage[backref=page]{hyperref}
```

It helps to track how many times and where you cite a reference.
You can modify how it looks

```
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{{\footnotesize [%
		\ifcase #1 Not cited.%
		\or Cited on page~#2%
		\else Cited on pages~#2%
		\fi%
		]}}
```

## Figures

Write a comment above a particular figure with the command used to generate that figure in the LaTeX file. 
Very useful.

- *Many simple* figures are better than *one complex* figure.

- *All figures* should have the *same fonts* for labels and axes (define the size at the script level, avoid resizing it in the Tex document).

- The format in which you *save* your figures depends on the data you want to represent, the script that generates it, and the Tex compiler you are using ([latex or pdflatex](https://www.overleaf.com/learn/latex/Choosing_a_LaTeX_Compiler)).

    These are the most popular formats:
    - `EPS` and `PDF` are good choices for vector graphics content. 
    However, `PDF` seems a [better](https://tex.stackexchange.com/questions/1072/which-graphics-formats-can-be-included-in-documents-processed-by-latex-or-pdflat) [choice](https://tex.stackexchange.com/questions/2092/which-figure-type-to-use-pdf-or-eps) for compatibility, compilation speed, and overall results.
    - `JPEG` for photos, screenshots.
    - `PNG` for anything that does not fall in the previous two categories.

See [Matlab code to format figures](template/src/matlab/ffsp.m).
