% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Program 1 for Exercise 8

close all;
clear;
clc;


data = table2array(readtable('Heathrow.xlsx'));
[xId, yId] = deal([2, 10]);
x = data(:, xId);
% Fog data
y = data(:, yId);

%% (a) Remove Nan values
xAndYNotNan = rmmissing([x, y]);
x = xAndYNotNan(:, 1);
y = xAndYNotNan(:, 2);

%% (b) Fit a model using OLS

%% Polynomial model
%% 3rd degree polynomial model 
    
X  =[x, x.^2, x.^3];

yModelStruct3 = fitlm(X, y, 'RobustOpts', 'ols');
yModel3 = yModelStruct3.Fitted;
adjR2Poly = yModelStruct3.Rsquared.Adjusted;

% dotSize = 15;
% scatter(x, y, dotSize, 'filled');
% hold on;
% 
% [X, I] =sort(x);
% 
% Y = yModel3(I);   
% ax = plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
% title('3rd degree polynomial model')
% hold off;
    
    

 

%% (c) Randomisation test for adjR^2
nSamples = 1000;
% vector with the adjR2 values of the randomised samples
adjR2V = nan(nSamples, 1);

for i = 1:nSamples
    randPermIndices = randperm(size(x, 1));
    % only y is randomised
    randSample = [x(randPermIndices), y];
    yModelStruct3 = fitlm(randSample(:, 1), randSample(:, 2), ...
        'RobustOpts', 'ols');
    yModel3 = yModelStruct3.Fitted;
    adjR2V(i) = yModelStruct3.Rsquared.Adjusted;
end

adjR2VSorted = sort([adjR2V; adjR2Poly]);
medianAdjR2 = median(adjR2VSorted);

rank = round(mean(find(adjR2VSorted == adjR2Poly)));
% Calculate the p-value
if rank <= median(adjR2VSorted)
	pVal = 2*(rank/(nSamples+1)); 
else
	pVal = 2*(1-rank/(nSamples+1));
end


