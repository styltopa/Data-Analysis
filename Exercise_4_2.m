% Stelios Topalidis
% AEM: 9613
% Exercise 4.2

clc;
clear;
close all;

% Uncertainty for the length (stdL) and the width (stdW) of the measurement
[stdL, stdW] = deal(5, 5); 

% length and width
[l, w] = deal(500, 300);

%% (a) Uncertainty of the measurement of the area, given length and width 
% a = l*w 
% By law of propagation of error we get:
% stdA^2 = (da/dl * stdL)^2 + (da/dw * stdW)^2
% So the area uncertainty (standard deviation of the area - stdA) equals:
stdA = sqrt((w * stdL)^2 + (l * stdW)^2); 
fprintf(['(a)\nFor (stdL, stdW, l, w) = (%.2f, %.2f, %d, %d):\n',...
    'stdA = %.2f\n\n'], stdL, stdW, l, w, stdA);

areaConst = 1000;
fprintf(['Lengths and widths deriving the same stdA:\n',...
    'Law of propagation of errors:\n',...
    'stdA^2 = (w * stdL)^2 + (l * stdW)^2, (1) for constant stdL, stdW\n',...
    'We want: \n',...
    'stdA^2 = c (2), where c = constant.\n',...
    '(1), (2) => w = sqrt((c - (l*stdW)^2)/stdL^2)) \n',...
    '=> (l, w) = (l, sqrt((c - (l*stdW)^2)/stdL^2))\n',...
    'is the required condition between l and w so that \n',...
    'stdA = constant\n\n']);

%% Example area uncertainty to derive lengths and widths for a specific 
%% desired uncertainty
% Set a value for the desiredAreaUncer such that:
% desiredAreaUncer^2 - (l*stdW)^2 > 0 is satisfied 
% (see w = sqrt((c - (l*stdW)^2)/stdL^2)) above)
% or else w will be negative which is not possible.
desiredAreaUncer = 3000;

fprintf(['Example:\nFor stdA = sqrt(c) = %d, \n',...
    'stdL =  %.2f, stdW = %.2f, l = %d \nthen the width must ',...
    'be such that: \n',...
    'w = sqrt((c - (l*stdW)^2)/stdL^2)) \n',...
    '=> w = %.2f\n\n'], desiredAreaUncer, stdL, stdW, l,...
     sqrt((desiredAreaUncer^2 - (l*stdW)^2)/stdL^2));


%% (b) 3D Plot the area of a rectangle as a function of length and width
% Make sure the ranges of length and width are positive 
rangeStep = 100;
[lRange, wRange] = deal(10:rangeStep:1000, 10:rangeStep:1000);
[l, w] = meshgrid(lRange, wRange);
a = l.*w;
figure(1);
mesh(l, w, a);
title('Area as a function of length and width');
xlabel('Length l');
ylabel('Width w');
zlabel('Area a');   