% Stylianos Topalidis
% AEM: 9613
% Stamatis Harteros
% AEM: 9516
% Project for academic year 2022-2023
% Exercise 2

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));

% for the first 9 indexes of the data
for indexes = 1:9
%     confidenceCalc
   [ci, ciBoot] = Group10Exe2Fun1(data(:, 1));
end


