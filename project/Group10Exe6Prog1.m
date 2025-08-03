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

% Cell array with 9 dependent features and 2 columns
% one for the feature name, one for the independent variable explaining in
% the best way the independent one
% and one for the corresponding R2 of the linear model
dependentFeatureAndR2Arr = cell(9, 5);
    
% Take out the years index (1), the tornado index (11) 
dataIndices = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12];
R2V = -100*ones(length(dataIndices), 1);
% Dependent variable index
for yIndex = 1:length(dataIndices)
    % the column number of the dependent variable in the original data
    yCol = dataIndices(yIndex);
    numberOfLayouts = yIndex;
    figure(yIndex);
    tiledlayout(3, 3);
    sgtitle("Scatter diagrams for the " + ...
        dataNamesPeriphrastic(yCol)+ " (" + dataNames(yCol) + ")");
    subplotCounter = 0;
    R2V = -100*ones(length(dataIndices), 1);
    % Independent variable index
    for xIndex = 1:size(dataIndices, 2)
        % The column number of the independent variable in the original data
        xCol = dataIndices(xIndex);
        % The index of the variable itself (xId)
        if xCol == yCol
            continue;
        end
        
        [x, y] = deal(data(:, xCol), data(:, yCol));
        [xName, yName] = deal(dataNames(xCol), dataNames(yCol));
        xNameP = values(M, {xName});
        subplotCounter = subplotCounter + 1;
        ax = nexttile;
        R2V(xIndex) = Group10Exe6Fun1(x, y, xName, yName, xNameP, ax); 
    end
 
    % For each feature (dependent variable) 
    % we find the first and second highest R2 among all other features 
    % (independent variables) 
    [R2VSorted, R2SortedInd] = sort(R2V);
    % Maximum R2 among independent features
    maxR2 = R2VSorted(end);
    % Second maximum R2 among independent features
    secondMaxR2 = R2VSorted(end-1);
    
    % Indices of independent feature giving linear model with 
    % maximum and second maximum R2 
    maxR2Ind = R2SortedInd(end);
    secondMaxR2Ind = R2SortedInd(end-1);
    
    dependentFeatureAndR2Arr(yIndex, 1) = cellstr(yName);
    dependentFeatureAndR2Arr(yIndex, 2) = ...
        cellstr(dataNames(dataIndices(maxR2Ind)));
    dependentFeatureAndR2Arr(yIndex, 3) = num2cell(maxR2);

    dependentFeatureAndR2Arr(yIndex, 4) = ...
        cellstr(dataNames(dataIndices(secondMaxR2Ind)));
    dependentFeatureAndR2Arr(yIndex, 5) = ...
        num2cell(secondMaxR2);
    
end
fprintf(['The table below contains all features as dependent \n',...
    'variables in the first column.\n',...
    'The other columns contain the two features best explaining\n',...
    'the dependent one and their respective linear models'' R2.\n\n']);

disp(' Dependent    Most ''explaining''    R2          Second most            R2');
disp(' Variable          feature                 ''explaining'' feature');

disp(dependentFeatureAndR2Arr);



%% Remarks
%% Pairs of variables explaining one another well
% 1. The mean annual temperature (T) is easily explained by the maximum 
% annual temperature (TM) as its linear function and vice versa 
% which is to be expected. The relative R2 is high (~0.9548)
% 2. The number of windy days (TS) and the number of days with hail (GR) 
% also seem to be explaining one another as a linear model 
% but with a much lower R2 (~0.4218) making for a rather unreliable model 
% to predict with.

%% All other variables
% All other variables are not explained well by a linear model of just 
% one other variable as the R2 falls below what would be a significant 
% threshold (0.8 for example).


