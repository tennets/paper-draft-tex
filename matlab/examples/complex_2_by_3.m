% complex_2_by_3.m
% Generate a complex 2-by-3 grid layout
% Stephan Gahima/paper-draft-tex

% Ref. https://www.mathworks.com/products/matlab/plot-gallery.html

% IDEA: Three plots for the top row, and a sigle plot for bottom row

clear,close all,clc

% Set up LaTex parameters
lw = 17.5875; lh = 22.93674;
addpath('../')

% Left-top plot: Create Logarithmic Axis Plots
x = logspace(0,1);
y = exp(x);
loglog(x,y)
print(gcf, "loglog-without-ffsp", "-dpdf");
ffsp(gcf, gca, lw, lh, 2, 3, filename="loglog-with-ffsp");

% Center-top plot: Display Color-Scaled Images From Arrays 
figure
Z = peaks;         % Create peak data set
im = imagesc(Z);
print(gcf, "peaks-without-ffsp", "-dpdf");
ffsp(gcf, gca, lw, lh, 2, 3, filename="peaks-with-ffsp");

% Right-top plot: Create and Customize Histograms
load("carbig.mat")
barColor = "red";
barTransparency = 0.3;
edges = 5:5:45;                  % Create vector of desired edges
figure
histogram(MPG, edges,...    % Use edges as the second argument
   "FaceColor",barColor,...      % Specify bar color
   "FaceAlpha",barTransparency); % Specify bar transparency between 0 and 1
title("MPG of 406 cars")
xlabel("Miles Per Gallon (MPG)")
ylabel("Number of cars")
print(gcf, "hist-without-ffsp", "-dpdf");
ffsp(gcf, gca, lw, lh, 2, 3, filename="hist-with-ffsp");

% Bottom plot: Visualize Flow Data Using Streamline Plots
[X,Y,U,V] = readWindData;
[xstart, ystart] = getStartCoordinates(X,Y);
figure
s = streamline(X,Y,U,V,xstart,ystart);
hold on
q = quiver(X,Y,U,V);
axis equal
print(gcf, "stream-without-ffsp", "-dpdf");
ffsp(gcf, gca, lw, lh, 2, 1, filename="stream-with-ffsp");

% Helper functions 
function [xstart, ystart] = getStartCoordinates(X,Y)
    xstart = [X(:,1) X(end,:)' X(1,:)'];
    ystart = [Y(:,1) Y(end,:)' Y(1,:)'];
end

function [X,Y,U,V] = readWindData()
    load wind
    X = x(11:22,11:22,1);
    Y = y(11:22,11:22,1);
    U = u(11:22,11:22,1);
    V = v(11:22,11:22,1);
end