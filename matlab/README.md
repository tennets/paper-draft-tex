# **ffsp**
The documentation for `ffsp`.
Feel free to give me feedback and ideas, ask for new features, contribute, or modify it 😄!

### Table of Contents
- [Introduction](#introduction)
- [Inputs](#inputs)
- [Usage](#usage)
- [Examples](#examples)

## Introduction
To use `ffsp` with good results, you need to know two pieces of information:
1. The (text) width (`LATEXW`) and height (`LATEXH`) used in your LaTex document
2. How the plot (or graph) you want to format will be arranged in your document, for instance, in an `NROWS`-by-`NCOLS` gridded figure.

### How to get `LATEXW` and `LATEXH`?
1. Open your LaTex document with your favourite LaTex editor
2. Add this line in the preamble (before the 'document' environment)
    ```
    \usepackage{layouts}
    ```
3. Copy-paste this code somewhere inside the `document` environment
    ```
    \texttt{LATEXW}=\printinunitsof{cm}\prntlen{\textwidth}
    \texttt{LATEXH}=\printinunitsof{cm}\prntlen{\textheight}
    ```

4. Compile the document to output the values (in cm) of `LATEXW` and `LATEXH`. It will look something like that ![latexw-latexh](./fig/doc/latexw-latexh.png)

### What about `NROWS` and `NCOLS`?
`ffsp` assumes that its output is in the `subfigure` environment, where one specifies the **size** of each subfigure. 
Thus, in a figure environment, we can have a single figure, two side-by-side, three stacked figures, etc.
In this way, we define a grid of `NROWS`-by-`NCOLS` subfigures. The maximum grid size supported is a 4-by-4 layout. That's because a figure should fit on a single page, be clear and not too dense.

## Inputs

### Require Arguments
|  | Explanation |
|-------|:-----------|
| `f` | The figure handle of the target graphic object. See [`gcf`](https://www.mathworks.com/help/matlab/ref/gcf.html)(built-in) |
| `ax` | The axes handle of the target graphic object. See [`gca`](https://www.mathworks.com/help/matlab/ref/gca.html) (built-in)
| `LATEXW` | The text width (in cm) of the target LaTex document|
| `LATEXH` | The text heigh (in cm) of the target LaTex document|
| `NROWS`| Number of grid rows in the layout (must be < 5)|
| `NCOLS`| Number of grid columns in the layout (must be < 5)|

### Name-Value Arguments
|  | Explanation |
|-------|-----------|
|`FILENAME`| String with the output figure filename<sup>1<sup> |
| `FORMAT`| String with the output figure extension<sup>2<sup> |

1. FFSP uses the default name "formatted_figure" if FILENAME is an empty string or not specified.  
2. FFSP throws an error if FORMAT is specified as an empty string. Otherwise, if not specified FFSP used the "pdf" extension by default.

## Usage
- `ffsp(f, ax, LATEXW, LATEXH, NROWS, NCOLS)` saves the figure using default settings as FORMATTED_FIGURE.pdf
- `ffsp(___, "FILENAME", "figname")` saves the figure using the default extension as FILENAME.pdf
- `ffsp(___, "FORMAT", "figext")` saves the figure using the default filename as FORMATTED_FIGURE.figext
- `ffsp(___, "FILENAME", "figname", "FORMAT", "figext")` saves the figure as figname.figext

Since R2021a, 
- `ffsp(___, FILENAME="figname")`
- `ffsp(___, FORMAT="figext")`
- `ffsp(___, FILENAME="figname", FORMAT="figext")`

### Tip 💡: 
1. Copy-paste these four lines in the preamble of your LaTex document 
    ```
    \newcommand{\onefig}{0.9}
    \newcommand{\twofig}{0.45}
    \newcommand{\threefig}{0.3}
    \newcommand{\fourfig}{0.225}
    ```
    The values of `\onefig`, `\twofig`, `\threefig`, and `\fourfig` are used in `ffsp` to format the figure correctly.
    These values are printed on the command windows when `ffsp` runs. Make sure to use them correctly in the LaTex document. See the examples [here](./examples/) and in the appendix section of [this template](../latex-template/main.pdf).

2. Run `help ffsp` or `doc ffsp` on your command windows to see the documentation.

### Limitations
- `ffsp` assumes NROWS and NCOLS range from 1 to 4.
- `ffsp` saves the figure in the directory where it runs.
- `ffsp` only supports PDF and EPS formats.
- `ffsp` returns a grey scale figure when EPS is specified.

## Examples
Run and modify the examples yourself.
1. Clone this repository.
2. `cd` to the location where you have cloned the repository and navigate to the `matlab` folder.
3. Run `ffsp_examples` in your command window.

