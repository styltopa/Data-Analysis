% Stelios Topalidis
% AEM: 9613
% Exercise 5.8

clc;
clear;
close all;

data = table2array(readtable('physical.txt'));
sampleSize = size(data, 1);
 
%% Linear model for mass for all 10 variables


y = data(:, 1);

% Vector used so that a constant term is added to the linear model
% (see docimentation of regress).
onesVector = ones(sampleSize, 1);
x = [onesVector, data(:, 2:end)];

% Parameter estimation
b = regress(y, x);

% Variance of errors
errors = y - x*b;
errorVar = var(errors);
% normalised errors
errorsNorm = errors./std(errors);

figure(1);
dotSize = 25;
scatter(y, errorsNorm, dotSize, 'filled');
yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k');

title({'Diagnostic plot:'; ...
    'Normalised errors of the full parameter linear regression model'});
fontSize = 15;
xlabel('$y_i$', 'interpreter', 'latex', 'FontSize', fontSize);
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex', 'FontSize', ...
    fontSize);
ymin = -4;
ymax = 4;
ylim([ymin, ymax]);

hold off;

n = sampleSize;
% k + 1: the number of parameters in the model
k = length(b) - 1;

% R2 and adjR2 
% formula for R2
R2 = 1 - sum((errors).^2)/sum((y-mean(y)).^2);
% formula for adjR2
adjR2 = 1 - (n-1)/(n-(k+1))*sum((errors).^2)/sum((y-mean(y)).^2);

% disp(R2);
% disp(adjR2);

%% Stepwise regression model
x = data(:, 2:end);
numOfFeatures = size(data(:, 2:end), 2);
% vector to keep or not the term in the final model

% Tolerance for the p-value of the features. If the p-values falls below 
% the threshold, the feature is considered significant and is added to the
% model.
PRemoveThreshold = 0.1; % It is the default one.

% Parameter estimation
% finalModelVector: vector with true value if
% the term is in the final model, false otherwise.
% stats.intercept: the constant term evaluated from the stepwisefit
[bStep, ~, ~, finalModelVector, stats] = stepwisefit(x, y, 'PRemove',...
    PRemoveThreshold);

bStepFinal = bStep(finalModelVector);
finalModel = stats.intercept + x(:, finalModelVector) * bStepFinal;

% Variance of errors
errorsStep = y - finalModel;
errorVarStep = var(errorsStep);

errorsStepNorm = errorsStep/std(errorsStep);

figure(2);
dotSize = 25;
scatter(y, errorsStepNorm, dotSize, 'filled');
yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k');

title({'Diagnostic plot:'; ...
    'Normalised errors of the stepwise regression model'});
fontSize = 15;
xlabel('$y_i$', 'interpreter', 'latex', 'FontSize', fontSize);
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex', 'FontSize', ...
    fontSize);
ylim([ymin, ymax]);
hold off;

% ajdR and adjR2 
% k + 1: the number of parameters in the stepwise regression model
k = length(bStepFinal) - 1;
% formula for R2
R2Step = 1 - sum((errorsStep).^2)/sum((y-mean(y)).^2);
% formula for adjR2
adjR2Step = 1 - (n-1)/(n-(k+1))*sum((errorsStep).^2)/sum((y-mean(y)).^2);

%% Comparison, remarks
fprintf(['Multiple Linear Regression model:\nR2: ',...
    '%f\nadjR2: %f\n\n'], R2, adjR2);

fprintf(['Stepwise Linear Regression model:\n',...
    'Number of features in the final model for PRemove = %.3f: %.f\n',... 
    'R2: %f\nadjR2: %f\n'], PRemoveThreshold, k+1, R2Step, adjR2Step);

% Remarks:
% 1) The coefficient of determination R2 is larger for the full multiple
% linear regression model due to the many features used when fitting the 
% data.
% 2) When the penalty of the number of parameters is introduced, the 
% stepwise model is favoured as it a smaller number of variables .
% 3) The diagnostic plots of the two models are quite similar but not the
% same. The same is true about the coefficients of determiantion (plain and
% adjusted one)
