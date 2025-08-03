clc;
clear;
close all;

data = table2array(readtable('Topic2DataSept2020'));

%% linear model
n = size(data(:,1), 1);
onesCol = ones(n, 1);
x = data(:, 1);
quant = x;
y = data(:, 2);

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
R2 = yModelStruct.Rsquared.Ordinary;
adjR2 = yModelStruct.Rsquared.Adjusted;

%% (a) Plot cost against quantity

figure(1);
scatter(x, y);
hold on;
xlabel('Quantity');
ylabel('Cost');
plot(x, yModel);
title({'Scatter diagram of cost versus quantity';...
    'and fitted linear line'});
hold off;


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


%% Non linear model 
n = size(data(:,1), 1);
onesCol = ones(n, 1);

% gaussMean1 = 470;
% gaussMean2 = 550;

% my suggested ones to better fit the curve
gaussMean1 = 470;
gaussMean2 = 550;

s = std(data(:, 1));
% the data are now exponentially transformed
fx1 = exp(((data(:, 1)- gaussMean1).^2)/(2*s^2));
fx2 = exp(((data(:, 1)- gaussMean2).^2)/(2*s^2));
y = data(:, 2);

x = [fx1, fx2];


% fitlm
yModelStruct = fitlm(x, y);
% Predictions from the model
yModel = yModelStruct.Fitted;
% Estimates of parameters b
b = yModelStruct.Coefficients.Estimate;

% Preciction of another value based on the model derived
% remember the 1 in the predicted data for the intercept
xToEstimateYOn = [1, 500, 500];
yPred = xToEstimateYOn*b;
R2NonLinear = yModelStruct.Rsquared.Ordinary;
adjR2NonLinear = yModelStruct.Rsquared.Adjusted;


%% (a) Plot cost against quantity
figure(3);
scatter(quant, y);
hold on;
xlabel('Quantity');
ylabel('Cost');

[~, inds] = sort(quant);
plot(quant(inds), yModel(inds));
title({'Scatter diagram of cost versus quantity';...
    'and fitted non linear model'});
hold off;


%% (b) Diagnostics plot
errors = y - yModel;
errorsNorm = errors/std(errors);
figure(4);
scatter(quant, errorsNorm);
title('Diagnostics plot of the linear model');
xlabel('Quantity');
ylabel('Standardised normal errors $$e_i^*$$', 'interpreter', 'latex');
yLow = -2;
yUp = 2;

yline([yLow, yUp], '--', 'Color', 'r');
yline(0, '-')
ylim([yLow - 1, yUp + 1]);


