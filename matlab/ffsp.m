function ffsp(f, ax, LATEXW, LATEXH, NROWS, NCOLS, varargin)
%FFSP formats Matlab-generated figures to be high-quality LaTeX-ready 
%figures.
% 
%   USAGE:
%   FFSP(f, ax, LATEXW, LATEXH, NROWS, NCOLS) saves the figure using 
%   default settings as FORMATTED_FIGURE.pdf
% 
%   FFSP(___, "FILENAME", "figname") saves the figure using the default 
%   extension as FILENAME.pdf
% 
%   FFSP(___, "FORMAT", "figext") saves the figure using the default
%   filename as FORMATTED_FIGURE.figext 
% 
%   FFSP(___, "FILENAME", "figname", "FORMAT", "figext") saves the figure 
%   as figname.figext
% 
%   Since R2021a, it is possible to specify Name-Value Arguments as
%   FFSP(___, FILENAME="figname")
%   FFSP(___, FORMAT="figext")
%   FFSP(___, FILENAME="figname", FORMAT="figext")
% 
%   INPUTS:
%   Required Arguments
%   -----------------------------------------------------------------------
%   F                    The figure handle of the target graphic object.
%                        See GCF (built-in)
% 
%   AX                   The axes handle of the target graphic object. See 
%                        GCA (built-in)
% 
%   LATEXW               The text width (in cm) of the target LaTex 
%                        document
% 
%   LATEXH               The text heigh (in cm) of the target LaTex
%                        document
% 
%                        The easiest way to get those values is to print
%                        them on your LaTex document. To do so, write 
%                        \printinunitsof{cm}\prntlen{\textwidth} and
%                        \printinunitsof{cm}\prntlen{\textheight} to print
%                        LATEXW and LATEXH respectively 
% 
%   NROWS                Number of grid rows in the layout (must be < 5)
% 
%   NCOLS                Number of grid columns in the layout (must be < 5)
% 
%                        FFSP assumes that the target figure is arranged
%                        in the LaTex document using the SUBFIGURE 
%                        environment within the FIGURE environment. In 
%                        particular, FFSP assumes an NROW-by-NCOLS grid 
%                        layout of SUBFIGURES.  
% 
%   Name-Value Arguments
%   -----------------------------------------------------------------------
%   FILENAME         String with the output figure filename. 
% 
%                    FFSP uses the default name "formatted_figure" if 
%                    FILENAME is an empty string or not specified.  
% 
%   FORMAT           String with the output figure extension. Specify one 
%                    of the following options:
%                    'eps'       Encapsulated PostScript (EPS) format.
%                    'pdf'       Portable Document Format (PDF).
%
%                    FFSP throws an error if FORMAT is specified as an 
%                    empty string. Otherwise, if not specified FFSP used 
%                    the "pdf" extension by default.
% 
%   NOTE
%   If you format figures for a LaTeX document using FFSP, use the 
%   SUBFIGURE environment within the FIGURE environment to create an
%   NROWS-by-NCOLS grid layout. Check the recommended LaTeX template at
%   https://github.com/tennets/paper-draft-tex for more details about the 
%   inner workings of FFSP, together with some examples.
% 
%   LIMITATIONS
%   - FFSP assumes NROWS and NCOLS range from 1 to 4.
%   - FFSP saves the figure in the directory where it runs.
%   - FFSP only supports PDF and EPS formats.
%   - FFSP returns a grey scale figure when EPS is specified.
% 
%   ffsp.m
%   Produce Matlab-generated high-quality LaTex-ready figures
%   Stephan Gahima/LaTex/Matlab
% 
%   Inspired by https://github.com/altmany/export_fig, 
%   https://github.com/plotly/plotly_matlab, aesthetics and desire to write
%   a (simpler and basic) version of what's out there.
% 
% Copyright (c) 2023 Stephan Gahima.

% ------------------------ DO NOT EDIT ------------------------------------
% Software information
CURRENT_VERSION = 1.0;
VERSION_FORMAT  = "%.1f";
% Use CHAR to display nicely on the command window
RELEASE_DATE    = char(datetime("today", "Format", "d-MM-y"));
% -------------------------------------------------------------------------

% ----------------- DEFAULT VALUES AND SUPPORTED OPTS ---------------------
DEFAULT_FILENAME  = "formatted_figure";
DEFAULT_FORMAT    = "pdf";
AVAILABLE_FORMATS = ["eps", "pdf"];
ONEFIG   = .9;
TWOFIG   = .45;
THREEFIG = .3;
FOURFIG  = .225;
% -------------------------------------------------------------------------

disp('Copy-paste these four lines in the preamble of your LaTex document ')
disp(['\newcommand{\onefig}{', num2str(ONEFIG), '}'])
disp(['\newcommand{\twofig}{', num2str(TWOFIG), '}'])
disp(['\newcommand{\threefig}{', num2str(THREEFIG), '}'])
disp(['\newcommand{\fourfig}{', num2str(FOURFIG), '}'])
disp('---')
tic;

args = parseArgs();

% Unpack arguments
filename = args.Results.filename;
format   = args.Results.format;
LATEXW   = args.Results.LATEXW;
LATEXH   = args.Results.LATEXH;
NROWS    = args.Results.NROWS;
NCOLS    = args.Results.NCOLS;

check_filename();
 
% MAIN ---

% Working with centimeters
ul = "centimeters";

% Set unit of length
set(ax, "Units", ul); 
set(f, "PaperUnits", ul, "Units", ul);
% Get axes information
ax_pos = get(ax, "Position");
inset  = get(ax, "TightInset");

% Original width and height
ow = sum(ax_pos([1, 3])) + inset(3);
oh = sum(ax_pos([2, 4])) + inset(4);

% Based on NROWS and NCOLS, scale the original width and height.
% Assume that the NROWS-by-NCOLS figures must fit on a LaTex page.
subh = subfig_scale_factor(NROWS);
subw = subfig_scale_factor(NCOLS);

% The strategy aims to ensure the grid layout. First, we try to scale
% based on a preferred dimension (say width) and adapt the second one 
% (height) accordingly. If the height is such that the layout is not 
% respected, we try the other way, that is, we scale the other dimension
% (height) and adapt the width accordingly.   
if NROWS > NCOLS

    [width, height] = scale_height();

    if width >= LATEXW * subw
        [width, height] = scale_width();
    end

elseif NROWS < NCOLS

    [width, height] = scale_width();

    if height >= LATEXH * subh
        [width, height] = scale_height();
    end

else 

    % #TODO Maybe we can be more clever    
    [width, height] = scale_width();

    if height >= LATEXH * subh
        [width, height] = scale_height();
    end

end

% #TODO Fix linestiles for EPS images

% #TODO Set font family and font size

% Ref. https://undocumentedmatlab.com/articles/axes-looseinset-property/
set(ax, "LooseInset", [0, 0, 0, 0]); % inset); % Not sure which yields the best results

set(f,                                ...
    "PaperPositionMode", "manual",    ... 
    "PaperSize", [width, height],     ...
    "PaperPosition", [0, 0,           ...
                      width, height], ...
    "Renderer", "painters");

% SAVE ---
% Catch empty string provided by the user
if strlength(filename) == 0
    filename = DEFAULT_FILENAME;
elseif strlength(format) == 0
    format = DEFAULT_FORMAT;
end
print(f, filename, strcat("-d", format));

time = toc;
disp(['Executed in ', num2str(time), ' sec.'])
disp('---')
disp(' ')
disp(['ffsp version ', num2str(CURRENT_VERSION, VERSION_FORMAT), ...
        ' (', RELEASE_DATE, ')'])

% LOCAL FUNCTIONS ---------------------------------------------------------

function p = parseArgs()
%PARSEARGS parse the input arguments.

    % Create parsing object
    p = inputParser;
    % Set function name
    p.FunctionName = "ffsp";

    % Helper functions ---
    check_figure = @(x) isgraphics(f, "figure") && ...
        isa(f, "matlab.ui.Figure");
    check_axes   = @(x) isgraphics(ax, "axes")  && ...
        isa(ax, "matlab.graphics.axis.Axes");
    % Refuse inputs (in cm) greater than the height of a 4A0 paper.
    % Ref. https://www.papersizes.org/a-paper-sizes.htm
    check_latex  = @(x) isscalar(x) && x > 0 && x < 237.801; 
    % NROWS and NCOLS range from 1 to 4
    check_grid   = @(x) isscalar(x) && ~mod(x, 1) && x > 0 && x < 5;
    check_name   = @(x) isstring(x) | ischar(x);
    check_format = @(x) strlength(validatestring(x, AVAILABLE_FORMATS));

    % REQUIRED ARGUMENTS ---
    % Check f (current figure handle) 
    addRequired(p, "f", check_figure);
    % Check ax (current axes) 
    addRequired(p, "ax", check_axes);
    % Check width
    addRequired(p, "LATEXW", check_latex);
    % Check height
    addRequired(p, "LATEXH", check_latex);
    % Check number of rows
    addRequired(p, "NROWS", check_grid);
    % Check number of columns
    addRequired(p, "NCOLS", check_grid);

    % NAME-VALUE ARGUMENTS ---
    addParameter(p, "filename", DEFAULT_FILENAME, check_name);
    addParameter(p, "format", DEFAULT_FORMAT, check_format);

    parse(p, f, ax, LATEXW, LATEXH, NROWS, NCOLS, varargin{:});
    
end

% -------------------------------------------------------------------------

function check_filename()
%CHECK_FILENAME ensures filename is valid on different OS.

    % Ref. https://stackoverflow.com/questions/4814040/allowed-characters-in-filename
    if ismac
        INVALID_CHARACTERS = [':', '/'];
    elseif ispc
        INVALID_CHARACTERS = ["NUL", '\', '/', ':', '*', '?', '"', '<', '>', '|'];
    elseif isunix
        INVALID_CHARACTERS = ["NUL", '/'];
    else
        % Throw a warning for an unknown platform
        warning("FFSP:UnknownPlatform", ...
            ['Cannot check if "', filename, '" is a valid/legal filename.'])
    end
    
    for i = 1:length(INVALID_CHARACTERS)
        c = INVALID_CHARACTERS(i);
        if contains(filename, c)
            error("FFSP:CheckFilename", [c, ...
                ' is an invalid character for filename on your OS.']);
        end
    end

end

% -------------------------------------------------------------------------

function subl = subfig_scale_factor(N)
%SUBFIG_SCALE_FACTOR returns a scale factor used to scale the subfigures.
%
%   These values are defined at lines 69-72 in main.tex in the latex 
%   template you find at https://github.com/tennets/paper-draft-tex.

    if N == 1
        subl = ONEFIG;
    elseif N == 2
        subl = TWOFIG;
    elseif N == 3
        subl = THREEFIG;
    else 
        subl = FOURFIG; 
    end

end

% -------------------------------------------------------------------------

function [width, height] = scale_height()
%SCALE_HEIGHT returns the figure dimensions by height-scaling first.

    height = LATEXH * subh;
    scale  = oh / height;
    width  = ow / scale;

end

% -------------------------------------------------------------------------

function [width, height] = scale_width()
%SCALE_WIDTH returns the figure dimensions by width-scaling first.

    width  = LATEXW * subw;
    scale  = ow / width;
    height = oh / scale;

end


% LICENSE -----------------------------------------------------------------
% MIT License
% 
% Copyright (c) 2023 Stephan Gahima
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

end
