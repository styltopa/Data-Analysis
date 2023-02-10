% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program for exercise 3

% Estimated time to run: ~1 second.

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
years = data(:,1);

dataNamesStruct = importdata('Heathrow.xlsx');
dataNames = string(dataNamesStruct.textdata.Sheet1);
dataNamesPeriphrastic = {'Year', 'Mean annual temperature', ...
        'Mean annual maximum temperature', 'Mean annual minimum temperature', ...
        'Total annual rainfall or snowfall', 'Mean annual wind velocity', ...
        'Number of days with rain', 'Number of days with snow', ...
        'Number of days with wind', 'Number of days with fog', ...
        'Number of days with tornado', 'Number of days with hail'};


% Map of short names of features to their periphrastic names
M = containers.Map(dataNames, dataNamesPeriphrastic);

% We will analyze the first 9 features of the data
% Note that the first column is the years and we skip it
numOfFeatures = 9; 
featureData = data(:, 2:end);
p1 = nan(numOfFeatures, 1);
p2 = nan(numOfFeatures, 1);


for i=1:numOfFeatures
%        p1 is the p value of the Parametrical analysis 
%        while p2 is for the randomisation analysis
    [p1(i) ,p2(i)] = Group10Exe3Fun1(years,featureData(:,i)); 
end
p(1,:) = p1;
p(2,:) = p2;

discIndex = nan;
for i=2:length(years)
    if years(i) ~= years(i-1)+1
        discIndex = i;
%         We assume a single discontinuity point
%         On the first discontinuity point we find, 
%         we leave the for loop.
        continue;
    end
end
periods = [years(1), years(discIndex-1); ...
    years(discIndex), years(end)];
fprintf(['Tests for the null hypothesis that the mean values \n',...
    'of the feature for the two periods %d - %d and %d - %d\n',...
    'are equal ',...
    '(The p-values are as high as the likelihood \nof the periods ',...
    'having the same mean):\n\n'], periods(1,1), periods(1, 2),...
    periods(2, 1), periods(2, 2));

% data names without the year (first column)
featureDataNames = dataNames(2:end);

% String array containing the acceptance or rejection of the null
% hypothesis. The first column regards the parametric and the second the 
% bootstrap test.
rejectionStrMat = strings(numOfFeatures, 2);

for i=1:numOfFeatures
    namePeriphrastic = string(values(M, {featureDataNames(i)}));
    fprintf('For feature %s (%s):\n', featureDataNames(i), namePeriphrastic);
%     If the returned p values are equal to 10 it means that our 
%     feature data vector was completely empty before or after the year 
%     break
    if isnan(p1(i)) || isnan(p2(i))
        fprintf(['Data does not exist before or after the ',...
            'discontinuity point. Tests cannot be done.\n']);
        fprintf('-----------------------------------\n\n');
        
    else
        if p1(i) < 0.05 
            rejectionStrMat(i, 1) = 'Rejection';
        elseif p1(i) >= 0.05 
            rejectionStrMat(i, 1) = 'Acceptance';
        end
        if p2(i) < 0.05 
            rejectionStrMat(i, 2) = 'Rejection';
        elseif p2(i) >= 0.05 
            rejectionStrMat(i, 2) = 'Acceptance';
        end
        
        fprintf('Parametric: p(%i) = %d  (%s)\n', i, p1(i), ...
            rejectionStrMat(i, 1));
        fprintf('Randomisation method: p(%i) = %d  (%s)\n', i, p2(i), ...
            rejectionStrMat(i, 2));
        fprintf('-----------------------------------\n\n');
    end 
end


% We find the lowest p-value for both the parametrical and 
% the randomisation test

fprintf(['Largest difference between means \n',...
    'in the periods ',...
    '%d - %d and %d - %d \nfor the two tests:\n'], ...
    periods(1,1), periods(1, 2), periods(2, 1), periods(2, 2));

[minP1, minIndex1] = min(p1);
minIndexFeatureDataName = string(values(M, {featureDataNames(minIndex1)}));
fprintf(['- Parametric test:\nis for ',...
    'feature %s (%s) \nwith p value = %d\n'], ...
    featureDataNames(minIndex1), minIndexFeatureDataName , minP1);

[minP2, minIndex2] = min(p2);
minIndexFeatureDataName = string(values(M, {featureDataNames(minIndex2)}));
fprintf(['- Randomisation test:\nis for ',...
    'feature %s (%s) \nwith p value = %d\n\n'], ...
    featureDataNames(minIndex2), minIndexFeatureDataName , minP2);

% We check if the two tests agree on the feature with the largest
% difference in the two periods
if minIndex1 == minIndex2
    fprintf(['The parametric and randomisation test seem to agree\n',...
        'on which the feature with the maximum difference of means ',...
        'in the two periods is.\n']);
else
    fprintf(['The parametric and randomisation test do not seem to agree\n',...
        'on which the feature with the maximum difference of means ',...
        'in the two periods is.\n']);
end

%% Remarks
% The tests for the equality of means in the two periods agree on 4 out 
% of the 9 features 
