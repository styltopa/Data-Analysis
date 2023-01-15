% Stelios Topalidis
% AEM: 9613
% Exercise 5.9

clc;
clear;
close all;

data = table2array(readtable('hospital.txt'));

%% Simple multiple linear regression model
y = data(:, 1);
sampleSize = size(data, 1);
% vector for the constant term in regress (see dicumentation)
onesVector = ones(sampleSize, 1);
x = [onesVector, data(:, 2:end)];

b = regress(y, x);
errors = y - x*b;
errorsNorm = errors/std(errors);

n = sampleSize;
% k + 1: the number of parameters in the model.
k = length(b) - 1;
R2 = 1 - sum(errors.^2)/sum((y-mean(y)).^2);
adjR2 = 1 - (n-1)/(n-(k+1))*sum(errors.^2)/sum((y-mean(y)).^2);

figure(1);
dotSize = 20;
scatter(y, errorsNorm, dotSize, 'filled');
title({'Diagnostic plot: Normalised errors';['Full parameter linear ',...
    'regression model']});
fontSize = 15;
xlabel('$y_i$', 'interpreter', 'latex', 'FontSize', fontSize);
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex', 'FontSize', ...
    fontSize );
yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k');
[ymin, ymax] = deal(-4, 4);
ylim([ymin, ymax]);


annotationFontSize = 12;
[posX, posY, width, height] = deal(0.65, 0.75, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    {"$R^2$: "+ R2, "$AdjR^2$: "+ adjR2}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);

hold off


%% Stepwise linear regression model
x = data(:, 2:end);
[bStep, ~, ~, finalModelVector, stats] = stepwisefit(x, y);

% only some of the features are used on the model.
finalModel = stats.intercept + x(:, finalModelVector)*bStep(finalModelVector);

errorsStep = y - finalModel;
errorsStepNorm = errorsStep/std(errorsStep);


% k + 1: the number of parameters in the model.
k = length(bStep) - 1;
R2Step = 1 - sum(errorsStep.^2)/sum((y-mean(y)).^2);
adjR2Step = 1 - (n-1)/(n-(k+1))*sum(errorsStep.^2)/sum((y-mean(y)).^2);

figure(2);
dotSize = 20;
scatter(y, errorsStepNorm, dotSize, 'filled');
title({'Diagnostic plot: Normalised errors';['Stepwise linear ',...
    'regression model']});
fontSize = 15;
xlabel('$y_i$', 'interpreter', 'latex', 'FontSize', fontSize);
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex', 'FontSize', ...
    fontSize );
yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k');

annotationFontSize = 12;
[posX, posY, width, height] = deal(0.65, 0.75, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    {"$R^2$: "+ R2Step, "$AdjR^2$: "+ adjR2Step}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);

ylim([ymin, ymax]);
hold off

% Remarks/Comparison:
% The full parameter linear regression model has a higher coefficient of
% determination (R^2). This is because it uses parameters for more features 
% making the fitting more accurate.
% Nonetheless, it is the stepwise linear regression one that has a 
% the highest adjusted coefficient of determination (adjR^2).
% This is due to the fact that the more parameters used in the plain full 
% parameter regression model are added as a penalty to this score.


%% Check for multicolinearity problem of the features
feature2 = data(:, 2);
feature3 = data(:, 3);
feature4 = data(:, 4);
strFeatures = string(["Cases", "Eligible", "OpRooms"]);

%% Cases, eligible
figure(3)
scatter(feature2, feature3, dotSize, 'filled');
title(strFeatures(1)+ " - "+ strFeatures(2));
corrCoefMat = corrcoef(feature2, feature3);
corrCoef = corrCoefMat(1, 2);
[posX, posY, width, height] = deal(0.60, 0.2, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    "r: "+ corrCoef, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
xlabel(strFeatures(1));
ylabel(strFeatures(2));

%% Eligible, OpRooms
figure(4)
scatter(feature3, feature4, dotSize, 'filled');
title(strFeatures(2)+ " - "+ strFeatures(3));
corrCoefMat = corrcoef(feature3, feature4);
corrCoef = corrCoefMat(1, 2);
[posX, posY, width, height] = deal(0.60, 0.2, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    "r: "+ corrCoef, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
xlabel(strFeatures(2));
ylabel(strFeatures(3));

%% OpRooms, Cases
figure(5)
scatter(feature4, feature2, dotSize, 'filled');
title(strFeatures(3)+ " - "+ strFeatures(1));
corrCoefMat = corrcoef(feature4, feature2);
corrCoef = corrCoefMat(1, 2);
[posX, posY, width, height] = deal(0.60, 0.2, 0.1, 0.1); 
annotPosAndDims = [posX, posY, width, height];
annotation('textbox', annotPosAndDims, 'String', ...
    "r: "+ corrCoef, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
xlabel(strFeatures(3));
ylabel(strFeatures(1));

% Remarks
% The high correlation coefficient between all the variables
% is indicative of some of their being redundant and can be omitted when
% deriving the model. This is indeed the case with stepwise regression
% which uses only the Cases and the OpRooms as features which is the 
% feature pair with the smallest correlation coefficient.