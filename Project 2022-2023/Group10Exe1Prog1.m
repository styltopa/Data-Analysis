% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM:9516
% Project for academic year 2022-2023
% Program for exercise 1
clc;
close all;

data = table2array(readtable('Heathrow.xlsx'));


p = zeros(11,2);
for i = 2:12
    [p(i,1),p(i,2)] = Group10Exe1Fun1(data(:,i));
end
