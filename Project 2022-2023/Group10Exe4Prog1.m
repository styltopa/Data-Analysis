% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program for Exercise 4

% Estimated time to run: ~12 seconds.

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

% [xId, yId] = deal(3, 4);
% x = data(:, xId);
% % the fifth column, can be replaced with y
% y = data(:, yId);

% Without the year column
numOfCols = size(data, 2);
comboCounter = 0;

numOfCombos = nchoosek(numOfCols-1, 2);
% comboArr contains the indexes of the data columns to be checked for linear
% correlation
comboArr = nan(numOfCombos, 2);

outCIParam = nan(numOfCombos, 2);
outCIBoot = nan(numOfCombos, 2);
outPVal = nan(numOfCombos, 2);
outLength = nan(numOfCombos, 1);
for comboElem1 = 2:numOfCols
    for comboElem2 = comboElem1:numOfCols
        if comboElem1 == comboElem2
            continue
        end
        comboCounter = comboCounter + 1;
        comboArr(comboCounter, 1) = comboElem1;
        comboArr(comboCounter, 2) = comboElem2;
        x = data(:, comboArr(comboCounter, 1));
        y = data(:, comboArr(comboCounter, 2));
        [outCIParam(comboCounter, :), ...
           outCIBoot(comboCounter, :), ...
           outPVal(comboCounter, :), ...
           outLength(comboCounter)] = Group10Exe4Fun1(x, y);
        
    end
end

alpha = 0.05;

% Check if the four tests agree on if the variables are linearly correlated
% 0 means that the null hypothesis is not rejected
% 1 means that the test of the column 
% (fisher parametric, bootstrap, student parametric, randomisation) 
% rejects the null hypothesis

testArray = nan(numOfCombos, 4);
% The vector element equals 1 if the tests agree
agreementVector = nan(numOfCombos, 1);

for comboCounter = 1:numOfCombos
    % Bootstrap test for zero correlation
    if 0 < outCIBoot(comboCounter, 1)  || 0 > outCIBoot(comboCounter, 2)  
        testArray(comboCounter, 1) = 1;
    else
        testArray(comboCounter, 1) = 0;
    end
    % Parametric test based on the Fisher transform of r
    if 0 < outCIBoot(comboCounter, 1)  || 0 > outCIBoot(comboCounter, 2)   
        testArray(comboCounter, 2) = 1;
    else
        testArray(comboCounter, 2) = 0;
    end
    % Parametric test based on the student statistic of r
    if outPVal(comboCounter, 1) < alpha   
        testArray(comboCounter, 3) = 1;
    else
        testArray(comboCounter, 3) = 0;
    end
    % Randomisation test 
    if outPVal(comboCounter, 2) < alpha   
        testArray(comboCounter, 4) = 1;
    else
        testArray(comboCounter, 4) = 0;
    end
    
    % check if the four tests agree
    if testArray(comboCounter, :) == ones(1, 4)
        agreementVector(comboCounter) = 1;
    elseif testArray(comboCounter, :) == zeros(1, 4)
        agreementVector(comboCounter) = 1;
    else
        agreementVector(comboCounter) = 0;
    end
end

fprintf(['The four zero linear correlation tests all agree on %d ',...
    'out of the %d feature ', ...
    'combinations.\n\n'],...
     length(find(agreementVector==1)), numOfCombos);
       
% Find the minimum p values for the null hypothesis that the features
% are uncorrelated (meaning the features that are most 
% likely to be correlated)
[pValParamSorted, indicesParam] = sort(outPVal(:, 1));
[pValRandomisedSorted, indicesRandomised] = sort(outPVal(:, 2));

minPValParamCombos = comboArr(indicesParam(1:3), :);
minPValRandomisedCombos  = comboArr(indicesRandomised(1:3), :);


fprintf(['Most significant linearly dependent pairs \n', ...
    '(rejection of the zero correlation) according to the:\n']);
% Pairs of features with the most significant non zero correlation   
% according to the parametric test
fprintf(['Parametric test (student transformation of the correlation ',...
    'coefficient)\n',...
    '--------------------------------------\n']);
for i = 1:3
    fprintf(['%s and %s rejecting the zero ',...
        'correlation with p-value = %f \n'], ...
        dataNames(minPValParamCombos(i, 1)), ...
        dataNames(minPValParamCombos(i, 2)), ...
        outPVal(indicesParam(i), 1));
end

% Pairs of features with the most significant non zero correlation   
% according to the randomisation test
fprintf(['\nRandomisation test\n',...
    '--------------------------------------\n']);
for i = 1:3
    fprintf(['%s and %s rejecting the zero ',...
        'correlation hypothesis with p-value = %f \n'], ...
        dataNames(minPValRandomisedCombos(i, 1)), ...
        dataNames(minPValRandomisedCombos(i, 2)), ...
        outPVal(indicesRandomised(i), 2));
end 


%% Remarks
%% 1. Number of agreement on all zero correlation tests among all 
%% combinations
% The zero linear correlation tests do not agree on all combinations of
% features (see console).

%% Most significant linearly correlated pairs according to the 
%% 2. Parametric test
% The parametric test rejects the zero correlation between the temperature 
% and the maximum temperature (T and TM), the number of windy days and the 
% number of days with hail (TS and GR) and the mean annual temperature and
% the days with snowfall (T and SN) (see console)


%% 3. Randomisation test
% The randomisation test does not yield the same results for the p-value
% for every execution of the code.
% It seems to agree with the parametric on the case of 
% T and TM for all runs of the code.
% However, the other two pairs with significant linear correlation are
% sometimes TS and GR (same as with the parametric test), PP and RA 
% (rainfall or snowfall and number of rainy days respectively), V and FG 
% (wind velocity and number of days with fog) and others.
