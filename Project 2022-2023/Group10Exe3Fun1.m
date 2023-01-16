% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 3

clc;
clear;
close all;

data = table2array(readtable("Heathrow.xlsx"));

years = data(:, 1);
% example feature
info = data(:, 2);


%% (a) 
discIndex = 0; % Point of discontinuity
%    we assume a single discontinuity point
for i=2:length(years)
    if years(i)>years(i-1)+1
        discIndex = i;
    end
end
%% (b)
B = 1000;
% Ιf discIndex isnt 0 then the function continues
if discIndex ~= 0
    X1 = info(1:discIndex-1);
    X2 = info(discIndex:end);
    X1Nan = isnan(X1);
    X2Nan = isnan(X2);
    
    % P-values from the:
    % parametric test
%     disp(['X1 ', num2str(length(X1))]);
%     disp(['X2 ', num2str(length(X2))]);
    [~,p1] = ttest2(X1,X2);
    % bootstrap test
    % Draw the bootstrap samples
    bootMeanX1 = bootstrp(B, @mean, X1);
    bootMeanX2 = bootstrp(B, @mean, X2);

    originalDiffOfMeans = mean(X1) - mean(X2);
    bootDiffOfMeans = [bootMeanX1 - bootMeanX2; originalDiffOfMeans];
    bootDiffOfMeansSorted = sort(bootDiffOfMeans);

    originalDiffOfMeansIndex = find(bootDiffOfMeansSorted == ...
        originalDiffOfMeans);

    numberOfBootFuncResultsOnTheRight = 1 - originalDiffOfMeansIndex/B;
    % bootstrap p-value
    p2 = 2*numberOfBootFuncResultsOnTheRight;
else
    % do nothing
end 


pArr = [p1, p2];


    