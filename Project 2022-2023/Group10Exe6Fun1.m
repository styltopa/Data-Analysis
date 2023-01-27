% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 6

clc;
clear;
close all;

%% (a) Remove Nan pair values
data = table2array(readtable('Heathrow.xlsx'));
dataNamesStruct = importdata('Heathrow.xlsx');
dataNames = string(dataNamesStruct.textdata.Sheet1);

[xId, yId] = deal(2, 4);


[x, y] = deal(data(:, xId), data(:, yId));
[xName, yName] = deal(dataNames(xId), dataNames(yId));

% namesPeriphrastically = [Mean annual tempearature
xAndY = [x, y];
xAndYNotNan = rmmissing(xAndY);

%% (b) Fit linear model and calculate adjR^2
% fit linear model on the first variable using the ordinary least squares
% method.
yModelStruct = fitlm(x, y, 'RobustOpts', 'ols');
yModel = yModelStruct.Fitted;

%% (d) Adjusted R^2 is returned
adjR2 = yModelStruct.Rsquared.Adjusted;

%% (c) Scatter diagram, fitted line on the independent variable and adjR^2 
%% shown on plot

figure();
dotSize = 15;
scatter(x, y, dotSize, 'filled');
title({'Scatter diagram between variables:' ; 
    xName + " and " + yName});
xlabel(xName);
ylabel(yName);
hold on;
plot(x, yModel, 'Color', 'r', 'LineWidth', 1.5);
annotationFontSize = 12;
[posX, posY, width, height] = deal(0.65, 0.75, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
hold off




