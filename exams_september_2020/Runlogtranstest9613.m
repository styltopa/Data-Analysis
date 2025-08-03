clc;
clear;
close all;

%% import and plot the boxplots
data = table2array(readtable('Topic1DataSept2020'));
X = data(:, 1);
Y = data(:, 2);

nX = 20;  
nY = 25;
start = 1;
range = size(X, 1);

inds = start + round(range*rand(nX, 1));
dataX = X(inds);

inds = start + round(range*rand(nY, 1));
dataY = Y(inds);

figure(1);
subplot(1, 2, 1);
boxplot(X);
title('X');

hold on;
subplot(1, 2, 2);
boxplot(Y);
title('Y');
hold off;


%% (b)
[pParam, pLogParam, pBoot, pLogBoot] = logtranstest9613(X, Y);
% for every one of the above if p < a = 0.05 => hypothesis of same mean 
% values is rejected
