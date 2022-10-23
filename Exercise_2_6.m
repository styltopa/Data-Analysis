% Stylianos Topalidis
% AEM: 9613

clear;
clc;

%% Simulation of the central limit theorem
% n is the number of variables
n = 100;
% N is the number of samples we get from each 
% random variable X
N = 10000;

% i-th row: has N samples of only the i-th random variable
% j-th column: the j-th sample (100x1 vector) of the n variables
X = rand(n, N);
% Y: mean of the all (N in number) 100x1 vectors of the variables in X
Y = mean(X, 1);
% simulation mean and variance
sMuOfY = mean(Y);
sVarOfY = var(Y);

%% Theoretical analysis according to the the central limit theorem
% - tpdf: theoretical pdf of Y
% - a,b: value interval of the uniformly distributed 
% random variables X
[a, b] = deal(0, 1);
% theoretical mean, variance and standard deviation
tMuOfY = (a+b)/2; 
tVarOfY = ((b-a)/12)/n; 
tSigmaOfY = sqrt(tVarOfY);
% we need around 1000 steps 
% so that the fitting curve of the normal distibution 
% is smooth
ystep = 8*tSigmaOfY/1000;
y = tMuOfY-3*tSigmaOfY:ystep:tMuOfY+3*tSigmaOfY;
tpdf = exp((-(y-tMuOfY).^2)/(2*tVarOfY))./sqrt(2*pi*tVarOfY);

%% Console output
fprintf(['Theoretical central limit theorem:\n',...
    'mean: %f\n',...
    'variance: %f\n\n'],tMuOfY , tVarOfY);
fprintf(['Simulation of the central limit theorem:\n', ...
    'mean: %f\n', ...
    'variance: %f\n\n'], sMuOfY, sVarOfY);

%% Plot
figure(1);
histogram(Y, 'Normalization', 'pdf');
subtitleStr = sprintf('For each variable X: E[X] = (a+b)/2 = %.2f, Var[X] = ((b-a)/12) = %f', tMuOfY, tVarOfY);
title('Histogram of the mean value of 100 variables X~U(0,1)', subtitleStr);
    
hold on;
plot(y, tpdf, 'Linewidth', 2); 
hold off


































