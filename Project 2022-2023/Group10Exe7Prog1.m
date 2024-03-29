% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program for exercise 7

% Estimated time to run: ~4 seconds.

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
dataNamesStruct = importdata('Heathrow.xlsx');
dataNames = string(dataNamesStruct.textdata.Sheet1);
dataNamesPeriphrastic = {'Year', 'Mean annual temperature', ...
        'Mean annual maximum temperature', 'Mean annual minimum temperature', ...
        'Total annual rainfall or snowfall', 'Mean annual wind velocity', ...
        'Number of days with rain', 'Number of days with snow', ...
        'Number of days with wind', 'Number of days with fog', ...
        'Number of days with tornado', 'Number of days with hail'};

models = string(["1st degree polynomial (linear) model", ...
    "2nd degree polynomial model", "3rd degree polynomial model", ...
    "Intrinsically linear power law model", ...
    "Intrinsically linear logarithmic model", ...
    "Intrinsically linear exponential model"]);


% Feature index used to explain the fog variable
xIndex = 3;
% Days with fog per year
yIndex = 10;
fogData = data(:, yIndex); 
featureIndexesMat = [2, 3, 4, 5, 6, 7, 8, 9, 12];
fprintf('The best model for %s (%s):\n\n',...
    dataNames(yIndex), string(dataNamesPeriphrastic(yIndex)));
    
for i = 1:length(featureIndexesMat)
    
    featureData = data(:, featureIndexesMat(i));
    [adjR2Max , modelIndex] = Group10Exe7Fun1(featureData, fogData,...
        dataNames(featureIndexesMat(i)), dataNames(yIndex), ...
        dataNamesPeriphrastic(featureIndexesMat(i)));
    fprintf(['Given the feature %s (%s)\n',...
        'is the %s\n',...
        'with adjR2 = %.4f\n\n'], ...
        dataNames(featureIndexesMat(i)), ...
        string(dataNamesPeriphrastic(featureIndexesMat(i))),...
        models(modelIndex), adjR2Max);
end


 
%% Remarks
% The features that seem to explain the FG (Number of days with fog) 
% in the best way are RA (Number of days with rain) with the 2nd degree 
% polynomial model and with adjR2 = 0.3490  
% and then T (Mean annual temperature) with the intrinsically linear 
% logarithmic model with adjR2 = 0.2133
% However, these adjR2 values are quite small making the respective model's
% ability to predict the fog data not reliable enough.
