% Stylianos Topalidis
% AEM: 9613
% Stamatis Harteros
% AEM: 
% Project for academic year 2022-2023
% Function 1 for exercise 1

clc;
clear;
close all;

smallV = randn(10, 1);
largeV = randn(100, 1);

% The discrete values of the vector should be more or less than 10
smallVSet = unique(smallV, 'stable');
largeVSet = unique(largeV, 'stable');

% Samplesize cases
% v = smallVSet;
v = largeVSet; 

if length(v) <= 10
    error('Small sample size to derive a histogram for');
else 
    figure();
    histogram(v);
end
