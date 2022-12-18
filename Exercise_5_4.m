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
speedOfLight = speedOfLightNormalized + 299000; 


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

fprintf(['(b)\nb.1 The linear model estimation for the variables ',...
        'is: \nc = %.2f*d + (%.2f))\n'], b1, b0);

plot(airDensity, b0 + b1*airDensity);
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

fprintf('b.2\nParametric ci for b0: [%3.f, %.3f]\n', b0CILow, b0CIHigh);
fprintf('Parametric ci for b1: [%3.f, %.3f]\n\n', b1CILow, b1CIHigh);

%% (c)
%% (c.1) Graph the linear model on the scatter diagram, estimation limits 
%% for the mean light speed with 95% confidence and for a single 
%% sobservation

%% (c.2) Make a prediction based on the model for a specific air 
%% density value
%% Do the same for a single observation


%% (d) 
%% (d.1) Check if the real values of each paremeter of the linear model is 
%% inside the ci calculated from the bivariate sample

%% (d.2) Is the real mean value of the speed of light inside the ci for the
%% mean of the light speed calculated on the interval of the air densities?

