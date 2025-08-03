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
index49_59  = find(years > 1949 & years < 1959);
index49_59Range =  min(index49_59):max(index49_59);

featureStart = 2;
featureEnd = 10;
featuresIndexes = featureStart:featureEnd;
numOfFeatures = length(featuresIndexes);
ci = nan(numOfFeatures , 2);
ciBoot = nan(numOfFeatures , 2);
featureMeanVal = nan(numOfFeatures , 1);

    
% for the first 9 features given
for colIndex = featureStart:featureEnd
    [ci(colIndex, :), ciBoot(colIndex, :)] = ...
     Group10Exe2Fun1(dataAfter1973(:, colIndex));
%     nanInds = is
 %     calculate the mean for years 1949-1958
    featureMeanVal(colIndex) = mean(data(index49_59Range, colIndex));
end



