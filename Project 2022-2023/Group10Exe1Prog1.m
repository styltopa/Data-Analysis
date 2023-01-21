% Stylianos Topalidis
% AEM: 9613
% Stamatis Harteros
% AEM: 9516
% Project for academic year 2022-2023
% Exercise 1

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));


[ci, ciBoot] = confidenceCalc(data);
function[CI ,CIbootstrap] = confidenceCalc(x)
	idx  = isnan(x);
    x(idx) = [];

    alpha = 0.05;
    [~, ~, CI, ~] = ttest(x, mean(x), 'Alpha', alpha);
    
    nboot = 1000;
    CIbootstrap = bootci(nboot, @mean, x);
end