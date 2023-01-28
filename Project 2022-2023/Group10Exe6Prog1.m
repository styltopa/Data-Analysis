% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Program for exercise 6


clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
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

% cell array with 9 dependent features and 2 columns
% one for the feature name, one for the independent variable explaining in
% the best way the independent one
% and one for the corresponding adjR2 of the linear model
dependentFeatureAndAdjR2Arr = cell(9, 3);
    
% take out the years index (1), the tornado index (11) 
dataIndicesToConsider = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12];
% dependent variable index
for yIndex = 1:size(dataIndicesToConsider, 2)
    % the column number of the dependent variable in the original data
    yCol = dataIndicesToConsider(yIndex);
    numberOfLayouts = yIndex;
    figure(yIndex);
    tiledlayout(3, 3);
    sgtitle("Scatter diagrams for the " + ...
        dataNamesPeriphrastic(yCol)+ " (" + dataNames(yCol) + ")");
    subplotCounter = 0;
    % independent variable index
    for xIndex = 1:size(dataIndicesToConsider, 2)
        % the column number of the independent variable in the original data
        xCol = dataIndicesToConsider(xIndex);
        % and the index of the variable itself (xId)
        if xCol == yCol
            continue;
        end
        
        [x, y] = deal(data(:, xCol), data(:, yCol));
        [xName, yName] = deal(dataNames(xCol), dataNames(yCol));
        xNameP = values(M, {xName});
        subplotCounter = subplotCounter + 1;
        ax = nexttile;
        adjR2 = Group10Exe6Fun1(x, y, xName, yName, xNameP, ax);
        
        
        % initialize the maximum adjR2 and find its maximum
        % value among all independent variable for
        % a specific variable
        if subplotCounter == 1
            maxAdjR2 = adjR2;
            maxAdjR2IndependentVar = xCol;
            dependentFeatureAndAdjR2Arr(yIndex, 1) = cellstr(yName);
            dependentFeatureAndAdjR2Arr(yIndex, 2) = cellstr(xName);
            dependentFeatureAndAdjR2Arr(yIndex, 3) = num2cell(adjR2);
        end
        if maxAdjR2 < adjR2
            maxAdjR2 = adjR2;
            maxAdjR2IndependentVar = xCol;   
            dependentFeatureAndAdjR2Arr(yIndex, 1) = cellstr(yName);
            dependentFeatureAndAdjR2Arr(yIndex, 2) = cellstr(xName);
            dependentFeatureAndAdjR2Arr(yIndex, 3) = num2cell(adjR2);
        end 
    end
end
disp(' Dependent      Most significant       AdjR2');
disp(' Variable    independent variable');
disp(dependentFeatureAndAdjR2Arr);

%% Remarks
%% T and TM
% The temperature T is mostly dependent on the maximum temperature TM 
% and vice versa which is to be expected. 

%% All other variables
% All other variables are not explained well by a linear model of just 
% one other variable as the adjR2 falls below what would be a significant 
% threshold (0.8 for example).

%% Outliers in the distribution of the variables
% It must be noted that in the case of the minimum temperature Tm and 
% the days with fog, there seem to exist outliers which reduce the adjR2 
% value for all independent
% variables that try to explain it (see subplots in figure 3 and 9).
% All other variables seem to not have significant outliers.


