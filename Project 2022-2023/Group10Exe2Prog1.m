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
dataNamesStruct = importdata('Heathrow.xlsx');
dataNames = string(dataNamesStruct.textdata.Sheet1);



% 
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

for i=1:numOfFeatures
    mean49_58(i) = mean(data49_58(1:end,i+1));
end

for i = 1:numOfFeatures
    if i~=4
        fprintf("The mean of %s between 1949 and 1958: \n%.4f\n",dataNames(i+1),mean49_58(i))
        if mean49_58(i)>ci(i,1) && mean49_58(i)<ci(i,2)
            fprintf("is between [%.4f , %.4f] of the parametrical confidence interval\n",ci(i,1),ci(i,2))
        else
            fprintf("is not between [%.4f , %.4f] of the parametrical confidence interval\n",ci(i,1),ci(i,2))
        end
        if mean49_58(i)>ciBoot(i,1) && mean49_58(i)<ciBoot(i,2)
            fprintf("is between [%.4f , %.4f] of the Boostrap confidence interval\n\n",ciBoot(i,1),ciBoot(i,2))
        else
            fprintf("is not between [%.4f , %.4f] of the Boostrap confidence interval\n\n",ciBoot(i,1),ciBoot(i,2))
        end
    else
        fprintf("For %s the matrix is empty on years between 1949 and 1958\n\n",dataNames(i+1))
    end
end

%%We notice that the 2 confidence intervals are not significantly different
%amongst themselves for any of the indicators. We notice a large change in the middle
%value of the period 1949-1958 for the indicators "Number of days with rain"
%and "Number of days with fog"



