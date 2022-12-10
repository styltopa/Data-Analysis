% Stelios Topalidis
% AEM: 9613
% Exercise 5.3

clear;
clc;
close all;

% Data import
rainData = readtable('rainThes59_97.dat');
tempData = readtable('tempThes59_97.dat');

% Rows: years, cols: months
rainData = table2array(rainData);
tempData = table2array(tempData);

numOfCols = length(rainData(1, :)); % equals 12 (the number of months) 
% instead of the first row (1) of the array, whichever else can be used.
numOfRows = length(rainData(:, 1));
corrCoefPerMonth = NaN(numOfCols, 1);

% Calculation of monthly sample correlation coefficients (r)
for month = 1:numOfCols
    corrCoefPerMonthMat = corrcoef(rainData(:, month), tempData(:, month));
    corrCoefPerMonth(month) = corrCoefPerMonthMat(1, 2);
%     figure(i);
%     scatter(rainData(:, i), tempData(:, i));
%     xlabel('Rain');
%     ylabel('Temperature');
%     hold off
end

%% Transformation of sample correlation coefficients (r) into statistic t
%% following the student distribution

%% Random permutation test to check if r_(rain, temperature) = 0 
%% (uncorrelated)
% number of random permutated samples
L = 1000;

% number of samples (to calculate the corrCoef) x months
corrCoefPerMonth = NaN(L, numOfCols);

alpha = 0.05;

% mapping numbers to months
keySet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; 
valueSet = {'January', 'February', 'March', 'April', 'May', 'June', ...
    'July', 'August', 'September', 'Obtober', 'November', 'December'};
M = containers.Map(keySet,valueSet);

% for each month
for month = 1:numOfCols
    % for each new bivariate sample (rain, temp) with n = 39 (the initial
    % number of) observations each
    for sample = 1:L
        rainDataRandPerm = rainData(randperm(numOfRows), month);
        % the corrCoef is calculated for the permutated rain samples and 
        % the original temperatures (see Ex.5.2)
        corrCoefPerMonthMat = corrcoef(rainDataRandPerm, ...
            tempData(:, month));
        corrCoefPerMonth(sample, month) = corrCoefPerMonthMat(1, 2);
        
        % a/2% and (1-a/2)% Percentiles 
        corrCoefLow = corrCoefPerMonth(round(L*alpha/2), month);
        corrCoefHigh = corrCoefPerMonth(round(L*(1-alpha/2)), month);
        
        figure(month);
        title(['Sample $r_{rain, temperature} for L = ', num2str(L), ...
            ' random samples for ', M(month)], ['The ', ...
            num2str(100*(1-alpha/2)) ,...
            ' ci is noted by the two vertical lines']);
        histogram(corrCoefPerMonth(:, month));
        xline([corrCoefLow, corrCoefHigh], '-', ...
            {'$\frac{a,2}$%','1-$\frac{a,2}$%'}, 'Color', 'r', ...
            'interpreter', 'latex'); 
    end
end


