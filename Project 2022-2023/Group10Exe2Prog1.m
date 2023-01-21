% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Exercise 2

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));


% for the first 9 indexes of the data
% data starts from the second column
years = data(:,1);
rowIndex1973 = find(years == 1973);
dataAfter1973 = data(rowIndex1973:end, :);
index49_59  = find(years >= 1949 & years < 1959);


featuresIndexes = 2:10;
numOfFeatures = length(featuresIndexes);
ci = nan(numOfFeatures , 2);
ciBoot = nan(numOfFeatures , 2);
featureMeanVal = nan(numOfFeatures , 1);

% for the first 9 features given
idx  = isnan(data);
x = data;
x(idx) = [];
for colIndex = 1:numOfFeatures 
    [ci(colIndex, :), ciBoot(colIndex, :)] = ...
     Group10Exe2Fun1(dataAfter1973(:, colIndex+1));
end
%array that contains the data between the years 1949 and 1958
data49_58 = data(index49_59(1):index49_59(end),:);
%      removing Nan values
data49_58(isnan(data49_58))=0;
%mean values for the first 9 features between the years 1949 and 1958