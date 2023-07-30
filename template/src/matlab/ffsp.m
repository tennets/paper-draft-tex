function ffsp(varargin)
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
%   FFSP(..., TRANSPARENT) format the figure to have transparent
%   background. All the previous options are valid.
%
%   FFSP(VERSION) print the version of this software.
%
%   FFSP(HELP) print this help message.
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
%                        '-eps'   Encapsulated PostScript (EPS) format.
%                        '-pdf'   Portable Document Format (PDF).
%
%   TRANSPARENT          Set the figure background to be transparent.
%
%   -v, -V, --version    Print current version.
%
%   -h, -H, --help       Print help message.
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

% Software information
CURRENT_VERSION = 0.1;
VERSION_FORMAT  = "%.1f";
% Use CHAR to display nicely on the command window
RELEASE_DATE    = char(datetime("today", "Format", "d-MM-y"));

% PARSING ---
opts = parse_args(nargin);

if opts.version
    disp(['ffsp version ', num2str(CURRENT_VERSION, VERSION_FORMAT), ...
        ' (', RELEASE_DATE, ')'])
    return
end

if opts.help
    disp('usage : ffsp <f> <ax> [filename] [format] [transparent]   ')
    disp('                      [-h, -H, --help] [-v, -V, --version]')
    return
end

% MAIN ---


% SAVE ---

% LOCAL FUNCTIONS ---------------------------------------------------------

function opts = parse_args(n)
%PARSE_ARGS parse the input arguments.

    VERSION_TOKENS    = {"-v", "--version"};
    HELP_TOKENS       = {"-h", "--version"};
    AVAILABLE_FORMATS = {"-eps", "-pdf"};
    HANDLES           = {"figure", "axes"};
    DEFAULT_FILENAME  = "formatted_figure";
    DEFAULT_FORMAT    = "-pdf";
    DEFAULT_PATH      = "./";
    
    % Initialize options
    opts.fig_handle  = false;
    opts.ax_handle   = false;
    opts.transparent = false;
    opts.version     = false;
    opts.help        = false;
    opts.format      = DEFAULT_FORMAT;
    opts.filename    = DEFAULT_FILENAME;
    opts.path        = DEFAULT_PATH;

    % Loop over the inputs
    for i = 1:n

        arg = varargin{i};

        if strcmpi(arg, VERSION_TOKENS{1}) || strcmpi(arg, VERSION_TOKENS{2})
            opts.version = true;
        elseif strcmpi(arg, HELP_TOKENS{1}) || strcmpi(arg, HELP_TOKENS{2})
            opts.help = true;
        elseif strcmpi(arg, AVAILABLE_FORMATS{1}) || strcmpi(arg, AVAILABLE_FORMATS{2})
            opts.format = arg;
        elseif strcmpi(arg, "transparent")
            opts.transparent = true;
        elseif strcmp(get(arg, 'type'), HANDLES{1})
            opts.fig_handle = true;
        elseif strcmp(get(arg, 'type'), HANDLES{2})
            opts.ax_handle = true;
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
