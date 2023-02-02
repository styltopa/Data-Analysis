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
numOfFeatures = 9; %We will analyze the first 9 features of the data
                    %NOTE THAT THE FIRST COLUMN IS THE YEARS AND WE SKIP IT
for i=1:numOfFeatures
    [p1(i) ,p2(i)] = Group10Exe3Fun1(years,data(:,i+1)); %P1 is the pvalue of the parametrical analysis while p2 is for the resampling analysis
end
p(1,:) = p1;
p(2,:) = p2;
for i=1:numOfFeatures
    fprintf("For feature %i:\n",i)
    %if the returned p values are equal to 10 it means that our data was completely empty before or after the year break
    if p1(i)==10 
        fprintf("sample is empty before or after the breaking point\n") 
    else
        if p1(i)<0.05
            fprintf("PARAMETRICAL: it seems there IS a difference between the 2 periods p(%i) =%d\n",i,p1(i))
        else
            fprintf("PARAMETRICAL: it seems there ISN'T difference between the 2 periods p(%i) =%d\n",i,p1(i))
        end
        if p2(i)<0.05
            fprintf("RESAMPLING ANALYSIS: it seems there IS a difference between the 2 periods p(%i) =%d\n",i,p2(i))
        else
            fprintf("RESAMPLING ANALYSIS: it seems there ISN'T difference between the 2 periods p(%i) =%d\n",i,p2(i))
        end
      end
        
    
end
%we find the lowest p value for both parametrical and resampling analysis
[minP1,minIndex1] = min(p1);
fprintf("\nParametricaly Biggest difference seems to be for feature %i , with p value = %d\n",minIndex1,minP1)
[minP2,minIndex2] = min(p2);
fprintf("With resampling Biggest difference seems to be for feature %i , with p value = %d\n",minIndex2,minP2)
%we test if the two results agree
if minIndex1 == minIndex2
    fprintf("\nThe parametrical and resampling analysis seem to agree")
else
    fprintf("The parametrical and resampling analysis dont produce the same results")
end

