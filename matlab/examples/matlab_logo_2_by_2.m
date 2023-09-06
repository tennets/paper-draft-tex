% matlab_logo_2_by_2.m
% Generate a 2-by-2 grid of Matlab logos
% Stephan Gahima/paper-draft-tex

clear,close all,clc

% Ref. https://www.mathworks.com/help/matlab/visualize/creating-the-matlab-logo.html
L = 160*membrane(1,100);
f = figure;
ax = axes;
s = surface(L);
s.EdgeColor = 'none';
view(3)
ax.XLim = [1 201];
ax.YLim = [1 201];
ax.ZLim = [-53.4 160];
ax.CameraPosition = [-145.5 -229.7 283.6];
ax.CameraTarget = [77.4 60.2 63.9];
ax.CameraUpVector = [0 0 1];
ax.CameraViewAngle = 36.7;
ax.Position = [0 0 1 1];
ax.DataAspectRatio = [1 1 .9];
l1 = light;
l1.Position = [160 400 80];
l1.Style = 'local';
l1.Color = [0 0.8 0.8];
l2 = light;
l2.Position = [.5 -1 .4];
l2.Color = [0.8 0.8 0];
s.FaceColor = [0.9 0.2 0.2];
s.FaceLighting = 'gouraud';
s.AmbientStrength = 0.3;
s.DiffuseStrength = 0.6; 
s.BackFaceLighting = 'lit';
s.SpecularStrength = 1;
s.SpecularColorReflectance = 1;
s.SpecularExponent = 7;
axis off
f.Color = 'black';

print(f, "matlab-logo-without-ffsp", "-dpdf");

% Set up LaTex parameters
lw = 17.5875; lh = 22.93674;
nr = 2; nc = nr;

addpath('../')

ffsp(f, ax, lw, lh, nr, nc, filename="matlab-logo-with-ffsp");

open matlab-logo-with-ffsp.pdf
open matlab-logo-without-ffsp.pdf