function ffsp(f, ax, LATEXW, LATEXH, NROWS, NCOLS, varargin)
% FFSP formats Matlab-generated figures to produce high-quality LaTeX-ready
% figures.
%
%   USAGE:
%   FFSP(f, ax, LATEXW, LATEXH, NROWS, NCOLS) saves the figure using default settings as FORMATTED_FIGURE.pdf.
%
%   FFSP(..., FILENAME) saves the figure using the default extension as FILENAME.pdf.
%
%   FFSP(..., FORMAT) saves the figure using the default filename as FORMATTED_FIGURE.FORMAT. 
%
%   FFSP(..., FILENAME, FORMAT) saves the figure as FILENAME.FORMAT.
%
%   INPUTS:
%   F                    The figure handle of the target graphic object.
%                        See GCF (built-in).
%
%   AX                   The axes handle of the target graphic object.
%                        See GCA (built-in).
%
%   LATEXW               The \textwidth (in cm) of the target LaTex 
%                        document.
%
%   LATEXH               The \textheigh (in cm) of the target LaTex
%                        document.
%
%                        The easiest way to get those values is to print
%                        them on your LaTex document. To do so, write 
%                        \printinunitsof{cm}\prntlen{\textwidth} and
%                        \printinunitsof{cm}\prntlen{\textheight} to print 
%                        LATEXW and LATEXH respectively. 
%
%   NROWS                Number of grid rows in the layout. 
%
%   NCOLS                Number of grid columns in the layout.
%
%                        FFSP assumes that the target figure is arranged in
%                        the LaTex document using the SUBFIGURE environment
%                        within the FIGURE environment. In particular, FFSP
%                        assumes an NROW-by-NCOLS grid layout of SUBFIGURES.  
%
%   FILENAME             String with the desired output filename. FFSP uses
%                        the default name 'formatted_figure' if 
%                        FILENAME is empty.
%
%   FORMAT               String(s) containing the output file extension(s). 
%                        Specify one (or more) of the following options:
%                        'eps'   Encapsulated PostScript (EPS) format.
%                        'pdf'   Portable Document Format (PDF).
%
%   NOTE:
%   If you format figures for a LaTeX document using FFSP, use the 
%   SUBFIGURE environment within the FIGURE environment to create an
%   NROWS-by-NCOLS grid layout. Check the recommended LaTeX template at
%   https://github.com/tennets/paper-draft-tex for more details about the 
%   inner workings of FFSP, together with some examples.
%
%   LIMITATIONS
%   - FFSP assumes NROWS and NCOLS range from 1 to 4.
%   - FFSP save the figure in the directory where FFSP runs.
%   - FFSP only supports PDF and EPS formats.
%
% ffsp.m
% Produce Matlab-generated high-quality LaTex-ready figures
% Stephan Gahima/LaTex/Matlab
%
% Inspired by https://github.com/altmany/export_fig, 
% https://github.com/plotly/plotly_matlab, aesthetics and desire to write a 
% (simpler and basic) version of what's out there.
%
% Copyright (c) 2023 Stephan Gahima.

% DO NOT MODIFY -----------------------------------------------------------
% Software information
CURRENT_VERSION = 0.1;
VERSION_FORMAT  = "%.1f";
% Use CHAR to display nicely on the command window
RELEASE_DATE    = char(datetime("today", "Format", "d-MM-y"));
% Default values
DEFAULT_FILENAME  = "formatted_figure";
DEFAULT_FORMAT    = "pdf";
AVAILABLE_FORMATS = ["eps", "pdf"];
% -------------------------------------------------------------------------

disp(['ffsp version ', num2str(CURRENT_VERSION, VERSION_FORMAT), ...
        ' (', RELEASE_DATE, ')'])
s
% Unpack 
filename = parse_args().Results.filename;
format   = parse_args().Results.format;

check_filename();
 
% MAIN ---

% Work in centimeters
set(ax, 'Units', 'centimeters'); 
set(f, 'PaperUnits', 'centimeters', 'Units', 'centimeters');

ax_pos = get(ax, 'Position');
inset  = get(ax, 'TightInset');

width  = sum(ax_pos([1, 3]))+inset(3);
height = sum(ax_pos([2, 4]))+inset(4);

% Ref. https://undocumentedmatlab.com/articles/axes-looseinset-property/
set(ax, 'LooseInset', [0, 0, 0, 0]); % inset); % Not sure which yields the best results

set(f,                                ...
    'PaperPositionMode', 'manual',    ... 
    'PaperSize', [width, height],     ...
    'PaperPosition', [0, 0,           ...
                      width, height], ...
    'Renderer', 'painters');

% Fix linestiles for EPS images

% SAVE ---
print(f, filename, strcat("-d", format));

% LOCAL FUNCTIONS ---------------------------------------------------------

function p = parse_args()
%PARSE_ARGS parse the input arguments.

    % Helper functions
    check_f  = @(x) isgraphics(f, 'figure') && isa(f, 'matlab.ui.Figure');
    check_ax = @(x) isgraphics(ax, 'axes')  && isa(ax, 'matlab.graphics.axis.Axes');
    check_op = @(x) isstring(x) | ischar(x);

    % Create parsing object
    p = inputParser;
    % Set function name
    p.FunctionName = 'ffsp';

    % Check f (current figure handle) 
    addRequired(p, 'f', check_f);
    % Check ax (current axes) 
    addRequired(p, 'ax', check_ax);

    addParameter(p, 'filename', DEFAULT_FILENAME, check_op);
    addParameter(p, 'format',  DEFAULT_FORMAT, @(x) any(validatestring(x, AVAILABLE_FORMATS)));

    parse(p, f, ax, varargin{:});
    
end

% -------------------------------------------------------------------------

function check_filename(INVALID_CHARACTERS)
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
    warning('FFSP:UnknownPlatform', ...
        ['Cannot check if "', filename, '" is a valid/legal filename.'])
end

for i = 1:length(INVALID_CHARACTERS)
    c = INVALID_CHARACTERS(i);
    if contains(filename, c)
        error('FFSP:CheckFilename', [c, ' is an invalid character for ' ...
            'filename on your OS.']);
    end
end

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
