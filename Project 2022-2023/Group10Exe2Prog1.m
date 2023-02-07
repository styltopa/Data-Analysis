% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program 1 for Exercise 2

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));


% For the first 9 indexes of the data

years = data(:,1);
rowIndex1973 = find(years == 1973);
dataAfter1973 = data(rowIndex1973:end, :);
index49_59  = find(years >= 1949 & years < 1959);

% Data starts from the second column
featuresIndexes = 2:10;
numOfFeatures = length(featuresIndexes);
ci = nan(numOfFeatures , 2);
ciBoot = nan(numOfFeatures , 2);
featureMeanVal = nan(numOfFeatures , 1);

% For the first 9 features 
idx  = isnan(data);
x = data;
x(idx) = [];
for colIndex = 1:numOfFeatures 
    [ci(colIndex, :), ciBoot(colIndex, :)] = ...
     Group10Exe2Fun1(dataAfter1973(:, colIndex+1));
end

% Data between the years 1949 and 1958
data49_58 = data(index49_59(1):index49_59(end),:);

% Remove Nan values
data49_58(isnan(data49_58))=0;

% Mean values for the first 9 features between the years 1949 and 1958