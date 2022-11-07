% Stelios Topalidis
% AEM: 9613
% Exercise 3.7

clc;
close all;

M = 100;
n = 10;
muX = 0;
sigma = 1;

rng(0);

% each column has a sample of n observations 
x = normrnd(muX, sigma, n, M);

%% (a) 
alpha = 0.05;
%% (a.i) 
% ttest performs a t-test along each column (each one of the M samples)
% ci is a 2xM matrix of confidence intervals
[~, ~, ciParametric, ~] = ttest(x, muX, 'Alpha', alpha);
ciParametricLow = ciParametric(1, :);
ciParametricHigh = ciParametric(2, :);

%% (a.ii)
B = 100;
ciBootstrapLow = NaN(1, M);
ciBootstrapHigh = NaN(1, M);
% calculation of M confidence intervals for the mean of B bootstrap samples
% for each column in the initial sample x 
for i = 1:M
    bootMean = bootstrp(B, @mean, x(:, i));
    indexCiLow = fix((B+1)*alpha/2);
    ciBootstrapLow(i) = bootMean(indexCiLow);
    indexCiHigh = B + 1 - indexCiLow; 
    ciBootstrapHigh(i) = bootMean(indexCiHigh);
end

% plot the low endpoint of the parametric and bootstrap ci
figure(1);
h1 = histogram(ciParametricLow);
title({'Low endpoints of the confidence intervals '...
    'of the mean from the initial sample x'});
hold on;
h2 = histogram(ciBootstrapLow);
legend([h1, h2], {'Parametric', 'Bootstrap'});
hold off;

figure(2);
h3 = histogram(ciParametricHigh);
title({'High endpoints of the confidence intervals ';...
    'of the mean from the initial sample x'});
hold on;
h4 = histogram(ciBootstrapHigh);
legend([h3, h4], {'Parametric', 'Bootstrap'});
hold off;

fprintf('X~N(%.1f, %.1f)\n', mu, sigma);
fprintf('Parametric:\n[mean(ciLow), mean(ciHigh)] = [%.3f, %.3f]\n\n', ...
    mean(ciParametricLow), mean(ciParametricHigh));
fprintf('Bootstrap:\n[mean(ciLow), mean(ciHigh)] = [%.3f, %.3f]\n\n', ...
    mean(ciBootstrapLow), mean(ciBootstrapHigh));


% Notes on (a):
% It seems that the parametric test has wider confidence interval whereas
% the bootstrap one is narrower. The same result remains true even when we 
% assume larger sample size (number of observations (n)) per sample in the 
% initial sample x.

%% (b)
y = x.^2;
alpha = 0.05;
%% (b.i) 
% ttest performs a t-test along each column (each one of the M samples)
% ci is a 2xM matrix of confidence intervals
muY = muX^2;
[~, ~, ciParametric, ~] = ttest(y, muY, 'Alpha', alpha);
ciParametricLow = ciParametric(1, :);
ciParametricHigh = ciParametric(2, :);

%% (b.ii)
B = 100;
ciBootstrapLow = NaN(1, M);
ciBootstrapHigh = NaN(1, M);
% calculation of M confidence intervals for the mean of B bootstrap samples
% for each column in the initial sample x 
for i = 1:M
    bootMean = bootstrp(B, @mean, y(:, i));
    indexCiLow = fix((B+1)*alpha/2);
    ciBootstrapLow(i) = bootMean(indexCiLow);
    indexCiHigh = B + 1 - indexCiLow; 
    ciBootstrapHigh(i) = bootMean(indexCiHigh);
end

% plot the low endpoint of the parametric and bootstrap ci
figure(3);
h1 = histogram(ciParametricLow);
title({'Low endpoints of the confidence intervals '...
    'of the mean from the initial sample y'});
hold on;
h2 = histogram(ciBootstrapLow);
legend([h1, h2], {'Parametric', 'Bootstrap'});
hold off;

figure(4);
h3 = histogram(ciParametricHigh);
title({'High endpoints of the confidence intervals ';...
    'of the mean from the initial sample y'});
hold on;
h4 = histogram(ciBootstrapHigh);
legend([h3, h4], {'Parametric', 'Bootstrap'});
hold off;

fprintf('Y = X^2\n');
fprintf('Parametric:\n[mean(ciLow), mean(ciHigh)] = [%.3f, %.3f]\n\n', ...
    mean(ciParametricLow), mean(ciParametricHigh));
fprintf('Bootstrap:\n[mean(ciLow), mean(ciHigh)] = [%.3f, %.3f]\n', ...
    mean(ciBootstrapLow), mean(ciBootstrapHigh));


% Notes on (b):
% Same things seem to apply on the Y random variable (parametric 
% approach gives wider confidence interval for the mean whereas the 
% bootstrap one is narrower)