% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 4

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
x = data(:, 4);
% the fifth column, can be replaced with y
y = data(:, 3);

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
outLength = nan(numOfCombos, 2);
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
        disp(comboArr(comboCounter, :));
        [outCIParam(comboCounter, :), ...
           outCIBoot(comboCounter, :), ...
           outPVal(comboCounter, :), ...
           outLength(comboCounter, :)] = ciPvalsAndLength(x, y);
        
    end
end


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
    [bootSamCorrCoefCI, bootSamCorrCoefStat] = bootci(B, {@corr, ...
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
        % includes the i-th randomised nx2 sample
        xAndYNotNanPerm = nan(n, 2);

        % permuted indices of the randomised samples
        permInds = randperm(n);

        % we randomise only one column of the two (the first in this case)
        % the second one remains as is
        xAndYNotNanPerm = xAndYNotNan(permInds, 1);
        % i-th correlation coefficient
        corrPerm(i) = corr(xAndYNotNanPerm, ...
            xAndYNotNan(:, 2));
    end

    sortedRandomisedCorr = sort([corrPerm; corrXY]);
    rankCorrXY = find(sortedRandomisedCorr == corrXY);

    if corrXY <= median(sortedRandomisedCorr) 
        pValRandomisation = 2*rankCorrXY/(B+1);
    elseif corrXY > median(sortedRandomisedCorr) 
        pValRandomisation = 2*(1 - rankCorrXY/(B+1));
    end
%     disp(["pValTTest:", size(pValTTest)]);
%     disp(["pValRandomisation", size(pValRandomisation)]);
    if size(pValTTest) ~= size(pValRandomisation)
%        disp("iteration:", pValRandomisation); 
       disp("pValRandomisation:", pValRandomisation);
    end
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