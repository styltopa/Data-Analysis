% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program for Exercise 6

% Estimated time to run: ~16 seconds.

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
dependentFeatureAndAdjR2Arr = cell(9, 5);
    
% take out the years index (1), the tornado index (11) 
dataIndices = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12];
adjR2V = -100*ones(length(dataIndices), 1);
% dependent variable index
for yIndex = 1:length(dataIndices)
    % the column number of the dependent variable in the original data
    yCol = dataIndices(yIndex);
    numberOfLayouts = yIndex;
    figure(yIndex);
    tiledlayout(3, 3);
    sgtitle("Scatter diagrams for the " + ...
        dataNamesPeriphrastic(yCol)+ " (" + dataNames(yCol) + ")");
    subplotCounter = 0;
    adjR2V = -100*ones(length(dataIndices), 1);
    % independent variable index
    for xIndex = 1:size(dataIndices, 2)
        % the column number of the independent variable in the original data
        xCol = dataIndices(xIndex);
        % and the index of the variable itself (xId)
        if xCol == yCol
            continue;
        end
        
        [x, y] = deal(data(:, xCol), data(:, yCol));
        [xName, yName] = deal(dataNames(xCol), dataNames(yCol));
        xNameP = values(M, {xName});
        subplotCounter = subplotCounter + 1;
        ax = nexttile;
        adjR2V(xIndex) = Group10Exe6Fun1(x, y, xName, yName, xNameP, ax); 
    end
 
    % For each feature (dependent variable) 
    % we find the first and second highest adjR2 among all other features 
    % (independent variables) 
    [adjR2VSorted, adjR2SortedInd] = sort(adjR2V);
    % maximum adjR2 among independent features
    maxAdjR2 = adjR2VSorted(end);
    % second maximum adjR2 among independent features
    secondMaxAdjR2 = adjR2VSorted(end-1);
    
    % Indices of independent feature giving linear model with 
    % maximum and second maximum adjR2 
    maxAdjR2Ind = adjR2SortedInd(end);
    secondMaxAdjR2Ind = adjR2SortedInd(end-1);
    
    dependentFeatureAndAdjR2Arr(yIndex, 1) = cellstr(yName);
    dependentFeatureAndAdjR2Arr(yIndex, 2) = ...
        cellstr(dataNames(dataIndices(maxAdjR2Ind)));
    dependentFeatureAndAdjR2Arr(yIndex, 3) = num2cell(maxAdjR2);

    dependentFeatureAndAdjR2Arr(yIndex, 4) = ...
        cellstr(dataNames(dataIndices(secondMaxAdjR2Ind)));
    dependentFeatureAndAdjR2Arr(yIndex, 5) = ...
        num2cell(secondMaxAdjR2);
    
end
fprintf(['The table below contains all features as dependent \n',...
    'variables in the first column.\n',...
    'The other columns contain the two features best explaining\n',...
    'the dependent one and their respective linear models'' adjR2.\n\n']);

disp(' Dependent    Most ''explaining''    AdjR2          Second most          AdjR2');
disp(' Variable          feature                    ''explaining'' feature');

disp(dependentFeatureAndAdjR2Arr);



%% Remarks
%% Pairs of variables explaining one another well
% 1. The mean annual temperature T is easily explained by the maximum 
% annual temperature TM and vice versa which is to be expected. The 
% relative adjR2 is high (~0.9539)
% 2. The number of windy days TS and the number of days with hail (GR) also
% seem to be explaining one another but with a much lower adjR2 (~0.4107)
% which is rather insignificant.

%% All other variables
% All other variables are not explained well by a linear model of just 
% one other variable as the adjR2 falls below what would be a significant 
% threshold (0.8 for example).


