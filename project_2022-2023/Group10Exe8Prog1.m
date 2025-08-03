% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program for exercise 8

% Estimated time to run: ~85 seconds.

close all;
clear;
clc;

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

adjR2V=nan(length(featureIndexesMat),1);
pVal=nan(length(featureIndexesMat),1);

for i=1:length(featureIndexesMat)
    % Message until all adjR2 are computed
    fprintf("Loading...%i/9\n",i);
    [adjR2 , pvalue] = Group10Exe8Fun1(data(:,featureIndexesMat(i)),fogData);
    adjR2V(i)=adjR2;
    pVal(i)=pvalue;
    
end

[maxPVal, maxPValInd] = max(pVal);
alpha = 0.05;
fprintf('\nTest if %s (%s) is explained from the other features\n\n',...
    dataNames(yIndex),...
    string(dataNamesPeriphrastic(yIndex)));
for i = 1:size(pVal,1)
    fprintf('%s (%s)\n', dataNames(featureIndexesMat(i)),...
        string(dataNamesPeriphrastic(featureIndexesMat(i))));

    fprintf('p-Value: %f\nadjR2: %f\n', pVal(i), adjR2V(i));
    % If the p-value is small, then the adjR2 does not come
    % from randomised samples. This means that this feature explains 
    % the fog data well
    if pVal(i) < alpha
        fprintf(['The adjR2 can be trusted: it does not ',...
            'come from randomised data\n']);
    else
        fprintf(['The adjR2 cannot be trusted: it may ',...
            'come from randomised data\n']);
    end
    fprintf('-----------------------\n');
end

%% Remarks
% The fog data seems to be explained in the best way by the feature
% RA (Number of days with rain) with adjR2: 0.336620 (which is small for a 
% prediction model). 
% Other features that try to explain the data are T (Mean annual 
% temperature), TM (Mean annual maximum temperature), Tm (Mean annual 
% minimum temperature), V (Mean annual wind velocity) but with adjR2 lower
% than 0.2. This means that they cannot predict the fog data with accuracy.
  
