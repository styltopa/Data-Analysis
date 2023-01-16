% Stylianos Topalidis
% AEM: 9613
% Stamatis Harteros
% AEM: 9516
% Project for academic year 2022-2023
% Exercise 2

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
% 
% for the first 9 indexes of the data
% data starts from the second column
years = data(:,1);
rowIndex1973 = find(years == 1973);
dataAfter1973 = data(rowIndex1973:end, :);


featuresIndexes = 2:10;
numOfFeatures = length(featuresIndexes);

ci = nan(numOfFeatures , 2);
ciBoot = nan(numOfFeatures , 2);

% for the first 9 features given
for colIndex = 1:numOfFeatures 
   [ci(colIndex, :), ciBoot(colIndex, :)] = ...
     Group10Exe2Fun1(dataAfter1973(:, colIndex));
end



