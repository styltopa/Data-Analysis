% Stelios Topalidis
% AEM: 9613
% Exercise 5.4

clc;
clear;
close all;

importArray = importdata('lightair.dat');
airDensity = importArray(:, 1);
% Attention for the values of the speed of light.
% They are the differences from the speed of light in vacuum
speedOfLightNormalized = importArray(:, 2);
scaleDownVal = 299000;
speedOfLight = speedOfLightNormalized + scaleDownVal; 


%% (a)
%% (a.1) Scatter diagram between speed of light and air density

figure();
dotSize = 25;
scatter(airDensity, speedOfLight, dotSize, 'filled');
title('Scatter diagram between the air density and the speed of light');
xlabel('Air density (kg/m^3)', 'interpreter', 'tex');
ylabel('Speed of light (km/sec)');
hold on;

%% (a.2) Correlation coefficient
corrCoefMat = corrcoef(airDensity, speedOfLight);
corrCoef = corrCoefMat(1, 2);
fprintf(['(a)\n The correlation coefficient between the air density \n',...
    'and the speed of light equals: %.3f\n\n'], ...
    corrCoef);


%% (b) 
%% (b.1) Linear model estimation using the MSE parameter method
covMat = cov(airDensity, speedOfLight);
airDSpeedOfLightCov = covMat(1, 2); 
b1 = airDSpeedOfLightCov /var(airDensity);
b0 = mean(speedOfLight) - b1*mean(airDensity);

fprintf(['(b)\nb.1\nThe linear model estimation for the variables ',...
        'is: \nc = %.2f*d + (%.2f))\n'], b1, b0);

lineWidthVal = 1.5;
plot(airDensity, b0 + b1*airDensity, 'Linewidth', lineWidthVal);
hold on;

%% (b.2) 95% parametric ci for b0, b1
% Significance level
alpha = 0.05;
% Number of bivariate observations
n = length(airDensity);
% degrees of freedom
dof = n - 2;
tVal = tinv(1- alpha/2, dof);

% Formula for sigmaE (standard deviation of model errors) 
varE = (n-1)/(n-2)*(var(speedOfLight) - ...
    b1^2*var(airDensity));
sigmaE = sqrt(varE);

% Formula for the ci of the b0 and b1
sigmaB0 = sigmaE*sqrt(1/n+(mean(airDensity)^2)/var(airDensity));
b0CILow = b0 - tVal * sigmaB0;
b0CIHigh = b0 + tVal * sigmaB0;

sigmaB1 = sigmaE/std(airDensity);
b1CILow = b1 - tVal * sigmaB1;
b1CIHigh = b1 + tVal * sigmaB1;

fprintf('b.2\nParametric ci for b0: [%3.f, %.3f] + %d\n', ...
    b0CILow-scaleDownVal, b0CIHigh-scaleDownVal, scaleDownVal);
fprintf('Parametric ci for b1: [%3.f, %.3f]\n\n', b1CILow, b1CIHigh);

%% (c)
%% (c.1) Graph the linear model on the scatter diagram, estimation limits 
%% for the mean light speed with 95% confidence and for a single 
%% sobservation

% CI prediction for the mean speed of light for a specific value of the air
% density
ciOfMeanSpeedOfLightLow = b0 + b1*airDensity - tVal * sigmaE * ...
    sqrt(1/n+((airDensity - mean(airDensity)).^2)/var(airDensity));
ciOfMeanSpeedOfLightHigh = b0 + b1*airDensity + tVal * sigmaE * ...
    sqrt(1/n+((airDensity - mean(airDensity)).^2)/var(airDensity));

% CI prediction for a single observation of the speed of light for a 
% specific value of the air density
ciOfSpeedOfLightLow = b0 + b1*airDensity - tVal * sigmaE * ...
    sqrt(1+ 1/n+((airDensity - mean(airDensity)).^2)/var(airDensity));
ciOfSpeedOfLightHigh = b0 + b1*airDensity + tVal * sigmaE * ...
    sqrt(1+ 1/n+((airDensity - mean(airDensity)).^2)/var(airDensity));


plot(airDensity, ciOfSpeedOfLightLow, '--', 'Color', 'r', 'Linewidth', ...
    lineWidthVal);
plot(airDensity, ciOfSpeedOfLightHigh, '--', 'Color', 'r', 'Linewidth', ...
    lineWidthVal);
plot(airDensity, ciOfMeanSpeedOfLightLow, '--', 'Color', 'k', ...
    'Linewidth', lineWidthVal);
plot(airDensity, ciOfMeanSpeedOfLightHigh, '--', 'Color', 'k', ...
    'Linewidth', lineWidthVal);

legend('', 'Linear model', 'CI limits for a new speed of light value', ...
    '', 'CI limits for the mean speed of light', '');
hold off;

%% (c.2) Make a prediction of a single observation of the speed of light 
%% and its mean for a specific air density value based on the model. 
%% Calculate the ci limits for the single observation and the mean as well.
airDensityVal = 1.29;
speedOfLightPred = b0 + b1*airDensityVal;

predCILow = b0 + b1*airDensityVal - tVal * sigmaE * ...
    sqrt(1 + 1/n+((airDensityVal - ...
    mean(airDensity)).^2)/var(airDensity));
predCIHigh = b0 + b1*airDensityVal + tVal * sigmaE * ...
    sqrt(1 + 1/n+((airDensityVal - ...
    mean(airDensity)).^2)/var(airDensity));

predCILowForMean = b0 + b1*airDensityVal - tVal * sigmaE * ...
    sqrt(1/n+((airDensityVal - ...
    mean(airDensity)).^2)/var(airDensity));
predCIHighForMean = b0 + b1*airDensityVal + tVal * sigmaE * ...
    sqrt(1/n+((airDensityVal - ...
    mean(airDensity)).^2)/var(airDensity));

fprintf(['(c)\nc.2\n%.2f%% prediction of the ',...
    'speed of light for \nair density = %.3f km/m^3: %.3f + %d ',...
    'km/sec\n'], ...
    (1-alpha)*100,...
    airDensityVal, speedOfLightPred - scaleDownVal, scaleDownVal);

fprintf(['CI for the mean of the speed of light: ',...
    '[%.3f, %.3f] + %d\n'], predCILowForMean-scaleDownVal, ...
    predCIHighForMean-scaleDownVal, scaleDownVal);

fprintf(['CI for a single observation of the speed of light: ',...
    '[%.3f, %.3f] + %d\n\n'], predCILow-scaleDownVal, ...
    predCIHigh-scaleDownVal, scaleDownVal);



%% (d) 
%% (d.1) Real linear model between air density and speed of light:
c = 299792.458;
beta0 = c;
d0 = 1.29;
beta1 = c*(-0.00029/d0);
fprintf(['(d)\nd.1\nReal model between air density and speed of ',...
    'light:\n',...
    'c = %.3f * d + %.3f, where d is the air density\n'], beta1, beta0);


%% (d.2) Check if the real values of each paremeter of the linear model is 
%% inside the ci calculated from the bivariate sample
if beta0 > b0CILow && beta0 < b0CIHigh
    fprintf(['d.2\nThe real value of beta0 = %.3f is inside \n',...
        'the %.2f%% ',...
        'ci [%.3f, %.3f] (calculated from ',...
        'the sample)\n'], beta0, (1-alpha)*100, b0CILow, b0CIHigh);
else
fprintf(['The real value of beta0 = %.3f is not inside \nthe %.2f%% ',...
        'ci [%.3f, %.3f] (calculated from ',...
        'the sample)\n'], beta0, (1-alpha)*100, b0CILow, b0CIHigh);
end
   

if beta1 > b1CILow && beta1 < b1CIHigh
    fprintf(['The real value of beta1 = %.3f is inside \nthe %.2f%% ',...
        'ci [%.3f, %.3f] (calculated from ',...
        'the sample)\n'], beta1, (1-alpha)*100, b1CILow, b1CIHigh);
else
fprintf(['The real value of beta1 = %.3f is not inside \nthe %.2f%% ',...
        'ci [%.3f, %.3f] (calculated from ',...
        'the sample)\n'], beta1, (1-alpha)*100, b1CILow, b1CIHigh);
end

%% (d.3) Is the real mean value of the speed of light inside the ci for the
%% mean of the light speed calculated on the interval of the air densities?

figure();
plot(airDensity, beta0+beta1.*airDensity, 'Linewidth', lineWidthVal);
title(['Real linear model between c and d and prediction limits ',...
    'for the mean']);
xlabel('Air density d(kg/m^3)', 'interpreter', 'tex');
ylabel('Speed of light c(km/sec)');
hold on
plot(airDensity, ciOfMeanSpeedOfLightLow, '--', 'Color', 'k', ...
    'Linewidth', lineWidthVal);
plot(airDensity, ciOfMeanSpeedOfLightHigh, '--', 'Color', 'k', ...
    'Linewidth', lineWidthVal);
legend('Real linear model between air density and speed of light', ...
    '', 'Ci of mean of speed of light based on the sample');

fprintf('d.3\nThe limits for the mean contain the real linear model\n');

