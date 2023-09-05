function ffsp(f, ax, varargin)
%FFSP formats Matlab-generated figures to produce high-quality LaTeX-ready
%figures.
%
%   FFSP(f, ax) format the figure using the default settings. It saves the
%   figure as FORMATTED_FIGURE.pdf.
%
%   FFSP(..., FILENAME) format the figure and save it as FILENAME.pdf.
%
%   FFSP(..., FORMAT) format the figure to have FORMAT extension. It saves
%   the figure as FORMATTED_FIGURE.FORMAT. 
%
%   FFSP(..., FILENAME, FORMAT) format the figure to have FORMAT extension,
%   and saves it as FORMATTED_FIGURE.FORMAT. 
%
%   INPUTS:
%   F                    To be formatted figure handle. See GCF (built-in).
%
%   AX                   To be formatted axes handle. See GCA (built-in).
%
%   FILENAME             String with the desired output filename (full or 
%                        relative path) for the figure. If no path is 
%                        specified, FFSP saves as FILENAME in the 
%                        current folder. FFSP uses the default name 
%                        'formatted_figure' if FILENAME is empty.
%
%   FORMAT               String(s) containing the output file extension(s). 
%                        Specify one (or more) of the following options:
%
%                        'eps'   Encapsulated PostScript (EPS) format.
%                        'pdf'   Portable Document Format (PDF).
%
%   NOTE
%   To arrange figures for a LaTeX document using FFSP, use the SUBFIGURE 
%   within the FIGURE environment to create an N-by-M grid format.
%   FFSP assumes N, and M range from 1 to 4. If that is not the case, the 
%   results are not guaranteed.
%   We recommend using the LaTeX template at https://github.com/tennets/paper-draft-tex. 
%
% ffsp.m
% produce high-quality LaTex-ready figures
% paper-draft-tex/src/matlab
%
% Inspired by https://github.com/altmany/export_fig and https://github.com/plotly/plotly_matlab.

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

% Unpack 
filename = parse_args().Results.filename;
format   = parse_args().Results.format;

check_filename();
 
% MAIN ---

% Work in centimeters
set(ax, 'Units', 'centimeters'); 
set(f, 'PaperUnits', 'centimeters', 'Units', 'centimeters');

% A4 size is 21 cm x 29,7 cm

ax_pos = get(ax, 'Position');
inset  = get(ax, 'TightInset');

% left   = ax_pos(1)-inset(1);
% bottom = ax_pos(2)-inset(2);
width  = sum(ax_pos([1, 3]))+inset(3);
height = sum(ax_pos([2, 4]))+inset(4);

% Ref. https://undocumentedmatlab.com/articles/axes-looseinset-property/
set(ax, 'LooseInset', [0, 0, 0, 0]); % inset);

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
