clc;
clear;
close all;

data = table2array(readtable('Topic2DataSept2020'));

%% linear model
n = size(data(:,1), 1);
onesCol = ones(n, 1);
x = data(:, 1);
y = data(:, 2);

% % regress
% linData = [onesCol, x];
% [b, ~, ~, ~, stats] = regress(y, linData);
% yModel  = linData*b;

% fitlm
yModelStruct = fitlm(x, y);
% Predictions from the model
yModel = yModelStruct.Fitted;
% Estimates of parameters b
b = yModelStruct.Coefficients.Estimate;

% Preciction of another value based on the model derived
% remember the 1 in the predicted data for the intercept
xToEstimateYOn = [1, 500];
yPred = xToEstimateYOn*b;
adjR2 = 

%% (a) Plot cost against quantity

figure(1);
scatter(x, y);
xlabel('Quantity');
ylabel('Cost');
hold on;
plot(x, yModel);
title({'Scatter diagram of cost versus quantity';...
    'and fitted linear line'});



%% (b) Diagnostics plot
errors = y - yModel;
errorsNorm = errors/std(errors);
figure(2);
scatter(x, errorsNorm);
title('Diagnostics plot of the linear model');
xlabel('Quantity');
ylabel('Standardised normal errors $$e_i^*$$', 'interpreter', 'latex');
yLow = -2;
yUp = 2;

yline([yLow, yUp], '--', 'Color', 'r');
yline(0, '-')
ylim([yLow - 1, yUp + 1]);


