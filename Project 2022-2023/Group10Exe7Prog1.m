% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023

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

    
% x = data(:, 2); 
% y = data(:, 4);

% problematic case for exponential
x = data(:, 2); 
y = data(:, 8);


xAndY = [x, y];  %removing NaN values
xAndYNotNan = rmmissing(xAndY);
x= xAndYNotNan(:,1);
y= xAndYNotNan(:,2);

% %% Polynomial regression model
% x2  = [x(:) x(:).^2 x(:).^3];
% yModelStruct = fitlm(x2, y, 'RobustOpts', 'ols');
% yModel = yModelStruct.Fitted;
% adjR2 = yModelStruct.Rsquared.Adjusted;
% 
% 
% dotSize = 15;
% scatter(x, y, dotSize, 'filled');
% % the title regards the independent variable (horizontal axis)
% 
% [X, I] =sort(x);
% Y = nan(size(X, 1), 1);
% for i=1:length(I)
%     Y(i) = yModel(I(i));
% end
% 
% hold on;
% plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
% 
% 
% annotationFontSize = 12;
% xOffset = 0.1;
% yOffset = 0.05;
% [posX, posY, width, height] = deal(0.65, 0.7, 0.1 ,0.1); 
% annotPosAndDims = [posX, posY, width, height];
% annotation('textbox', annotPosAndDims, 'String', ...
%     {"$AdjR^2$: "+ adjR2}, ...
%     'interpreter', 'latex', ...
%     'FontSize', ...
%     annotationFontSize);
% 
% hold off

%% Inherently linear exponential model
xTransformed = x;
yTransformed = log(y);

yModelStructTransformed = fitlm(xTransformed, yTransformed, 'RobustOpts', 'ols');
yModelTransformed = yModelStructTransformed.Fitted;


bTransformed = yModelStructTransformed.Coefficients.Estimate;
b = bTransformed;
b(1) = exp(bTransformed(1));

yModel = b(1)*exp(b(2)*x);

[X, I] =sort(x);
Y = yModel(I);

dotSize = 15;
scatter(x, y, dotSize, 'filled');
title('Exponential inherent model');
hold on;
plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
hold off;


