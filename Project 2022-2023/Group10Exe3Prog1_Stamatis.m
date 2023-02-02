% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 3

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
years = data(:,1);

%We will analyze the first 11 features of the data
% Note that the first column is the years and we skip it
numOfFeatures = 11; 

p1 = nan(numOfFeatures, 1);
p2 = nan(numOfFeatures, 1);

for i=1:numOfFeatures
%        p1 is the p value of the parametrical analysis 
%        while p2 is for the resampling analysis
    [p1(i) ,p2(i)] = Group10Exe3Fun1_Stamatis(years,data(:,i)); 
end
p(1,:) = p1;
p(2,:) = p2;

fprintf('
for i=1:numOfFeatures
    fprintf('For feature %i:\n',i)
%     if the returned p values are equal to 10 it means that our 
%     data was completely empty before or after the year break
    if p1(i)==10 
        fprintf('Sample is empty before or after the breaking point\n'); 
    else
        if p1(i) < 0.05
            fprintf(['PARAMETRIC: it seems that there IS a difference ',...
                'between the 2 periods p(%i) =%d\n'], i, p1(i));
        else
            fprintf(['PARAMETRIC: it seems there ISN''T difference ',...
                'between the 2 periods p(%i) =%d\n'], i, p1(i));
        end
        if p2(i)<0.05
            fprintf(['RESAMPLING METHOD: it seems there IS a ',...
                'difference between the 2 periods p(%i) =%d\n'], i, p2(i));
        else
            fprintf(['RESAMPLING ANALYSIS: it seems there ISN''T ',...
                'difference between the 2 periods p(%i) =%d\n'], i, p2(i));
        end
    end 
end

%we find the lowest p value for both parametrical and resampling analysis
[minP1, minIndex1] = min(p1);
fprintf(['\nParametricaly Biggest difference seems to be for feature ',...
    '%i , with p value = %d\n'], minIndex1, minP1);
[minP2, minIndex2] = min(p2);
fprintf(['With resampling Biggest difference seems to be for feature ',...
    '%i , with p value = %d\n'],minIndex2, minP2);
%we test if the two results agree
if minIndex1 == minIndex2
    fprintf('\nThe parametric and resampling analysis seem to agree');
else
    fprintf(['The parametric and resampling analysis don''t ',...
        'produce the same results']);
end

