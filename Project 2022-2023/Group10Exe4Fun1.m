% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 4

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

[xId, yId] = deal(3, 4);
x = data(:, xId);
% the fifth column, can be replaced with y
y = data(:, yId);

% without the year column
numOfCols = size(data, 2);
comboCounter = 0;

numOfCombos = nchoosek(numOfCols-1, 2);
% array containing the indexes of the data columns to be checked for linear
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
           outLength(comboCounter)] = ciPvalsAndLength(x, y);
        
    end
end

alpha = 0.05;

% check if the four tests agree on if the variables are linearly correlated
% 0 means that the null hypothesis is not rejected
% 1 means that the test of the column 
% (fisher parametric, bootstrap, student parametric, randomisation) 
% rejects the null hypothesis

testArray = nan(numOfCombos, 4);
% the vector element equals 1 if the tests agree
agreementVector = nan(numOfCombos, 1);

for comboCounter = 1:numOfCombos
    % bootstrap testing for zero correlation
    if 0 < outCIBoot(comboCounter, 1)  || 0 > outCIBoot(comboCounter, 2)  
        testArray(comboCounter, 1) = 1;
    else
        testArray(comboCounter, 1) = 0;
    end
    % parametric test based on the Fisher transform of r
    if 0 < outCIBoot(comboCounter, 1)  || 0 > outCIBoot(comboCounter, 2)   
        testArray(comboCounter, 2) = 1;
    else
        testArray(comboCounter, 2) = 0;
    end
    % parametric test based on the student statistic of r
    if outPVal(comboCounter, 1) < alpha   
        testArray(comboCounter, 3) = 1;
    else
        testArray(comboCounter, 3) = 0;
    end
    % randomisation test 
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

fprintf("The tests agree on %d out of the %d feature combinations.\n", ...
     length(find(agreementVector==1)), numOfCombos);
       
% to find the minimum p values for the null hypothesis that the data 
% are uncorrelaated meaning the variables which are most likely to be
% linearly correlated
[pValParamSorted, indicesParam] = sort(outPVal(:, 1));
[pValRandomisedSorted, indicesRandomised] = sort(outPVal(:, 2));

minPValParamCombos = comboArr(indicesParam(1:3), :);
minPValRandomisedCombos  = comboArr(indicesRandomised(1:3), :);

minPValParamCombosNames = dataNames(minPValParamCombos); 
minPValRandomisedCombosNames = dataNames(minPValRandomisedCombos); 

function [outCIParam, outCIBoot, outPVal, outLength] = ciPvalsAndLength(x, y)
    %% (a) Find the Nan pair values and remove them
    % Merging the two columns 
    xAndY = [x, y];

    % taking out the Nan rows
    xAndYNotNan = rmmissing(xAndY); 

    %% (b) 95% ci with parametric (Fisher) and bootstrap

    % Correlation coefficient of the original sample
    corrXY = corr(xAndYNotNan(:, 1), xAndYNotNan(:, 2));

    % Parametric ci with Fisher
    % Fisher transform
    corrCoefFisher = ...
        0.5.*log((1 + corrXY)./(1 - corrXY));

    % the probabilities to calculate the inverse normal values on
    alpha = 0.05;
    probArr = [alpha/2, 1-alpha/2];
    mu = corrCoefFisher;
    sigma = sqrt(1/(length(xAndYNotNan(:, 1)) - 3)); 
    ciParam = norminv(probArr, mu, sigma);

    % Bootstrap ci
    B = 1000;
    bootSamCorrCoefCI = bootci(B, {@corr, ...
        xAndYNotNan(:, 1), ...
        xAndYNotNan(:, 2)}, 'Alpha', alpha);


    %% (c) Parametric test (student) and randomisation test

    % P-value calculation
    % (c.1) 
    % Parametric method

    % length of the vectors without the Nan values
    n = length(xAndYNotNan(:, 1));
    % formula for the student statistic calculated from the 
    % correlation coefficient r
    tStatCorrCoef = corrXY*sqrt((n-2)/(1-corrXY^2));
    dof = n - 2;

    % p-value of the test
    pValTTest = min(tcdf(tStatCorrCoef, dof), 1-tcdf(tStatCorrCoef, dof));


    % (c.2) 
    % Randomisation method
    corrPerm = nan(B, 1);


    % for each randomised sample
    for i = 1:B
        % permuted indices of the randomised samples
        permInds = randperm(n);

        % we randomise only one column of the two (the first in this case)
        % the second one remains as is
        % includes the i-th randomised nx2 sample
        xAndYNotNanPerm = xAndYNotNan(permInds, 1);
        % i-th correlation coefficient
        corrPerm(i) = corr(xAndYNotNanPerm, ...
            xAndYNotNan(:, 2));
    end

    sortedRandomisedCorr = sort([corrPerm; corrXY]);
    % get the mean index of all 
    rankCorrXY = find(sortedRandomisedCorr == corrXY, 1);
    if size(rankCorrXY) ~= 1
        % if many indices with the same value exist, 
        % then we get the mean of those indices and round it to 
        % get the actual rank of the matrix.
        rankCorrXY = round(mean(rankCorrXY));
    end
    
    if corrXY <= median(sortedRandomisedCorr) 
        pValRandomisation = 2*rankCorrXY/(B+1);
    elseif corrXY > median(sortedRandomisedCorr) 
        pValRandomisation = 2*(1 - rankCorrXY/(B+1));
    end
%     disp(["pValTTest:", size(pValTTest)]);
%     disp(["pValRandomisation", size(pValRandomisation)]);
%     if size(pValTTest) ~= size(pValRandomisation)
%        disp("iteration:", pValRandomisation); 
%        disp("pValRandomisation:")
%        disp(pValRandomisation);
%     end
%     figure();
%     histogram(sortedRandomisedCorr);
%     xline([corrXY, median(sortedRandomisedCorr)], '-', ...
%         {'original sample r', 'median r'});

    %% (d)
    % bootstrap ci is in a column instead of a row vector
    outCIParam = ciParam; 
    outCIBoot = transpose(bootSamCorrCoefCI);
    
    outPVal = [pValTTest, pValRandomisation];
    outLength = n;
end