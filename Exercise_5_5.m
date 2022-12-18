% Stelios Topalidis
% AEM: 9613
% Exercise 5.5

clc;
clear;
close all;


importArray = importdata('lightair.dat');
airDensity = importArray(:, 1);
% Attention for the values of the speed of light.
% They are the differences from the speed of light in vacuum
speedOfLightNormalized = importArray(:, 2);
scaleDownVal = 299000;
speedOfLight = speedOfLightNormalized + scaleDownVal; 

% bootSam from the bivariate sample (airDensity, speedOfLight)
% use bootSam function to derive the bootstrap samples.

% calculation of b0boot, b1Boot of all (M) the bootstrap samples.

% sorting of the b0Boot, b1Boot and calculation of the bootstrap ci limits 

% compare the derived bootstrap ci with the parametric ci