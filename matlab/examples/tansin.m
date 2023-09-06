% tansin.m
% Generate a 4-by-4 grid of plots with two y-axes
% Stephan Gahima/paper-draft-tex

clear,close all,clc

x = linspace(0,2*pi,100);
y1 = tan(x);
y2 = sin(x);
xlabel('$x$', 'Interpreter', 'latex');
yyaxis left
plot(x,y1)
ylabel('$tan(x)$', 'Interpreter', 'latex');
yyaxis right
plot(x,y2)
ylabel('$sin(x)$', 'Interpreter', 'latex');
axis tight

print(gcf, "tansin-without-ffsp", "-dpdf");

% Set up LaTex parameters
lw = 17.5875; lh = 22.93674;
nr = 4; nc = nr;

addpath('../')

ffsp(gcf, gca, lw, lh, nr, nc, filename="tansin-with-ffsp");

open tansin-without-ffsp.pdf
open tansin-with-ffsp.pdf