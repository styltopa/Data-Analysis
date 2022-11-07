% Stelios Topalidis
% AEM: 9613
% Exercise 3.8

clc;
close all;

M = 100;
n = 10;
muX = 0;
sigmaX = 1;

% rng(0); % for reproducibility

% each column has a sample of n observations 
x = normrnd(muX, sigmaX, n, M);

%% (a) 
alpha = 0.05;
%% (a.i) 
% vartest performs a  variance test along each column (each one of the M 
% samples)
% ciParametric is a 2xM matrix of confidence intervals
[~, ~, ciParametric, ~] = vartest(x, sigmaX^2, 'Alpha', alpha);
ciParametricLow = sqrt(ciParametric(1, :));
ciParametricHigh = sqrt(ciParametric(2, :));

%% (a.ii)
B = 100;
ciBootstrapLow = NaN(1, M);
ciBootstrapHigh = NaN(1, M);
% calculation of M confidence intervals for the mean of B bootstrap samples
% for each column in the initial sample x 
for i = 1:M
    bootMean = bootstrp(B, @std, x(:, i));
    bootMeanSorted = sort(bootMean);
    indexCiLow = fix((B+1)*alpha/2);
    ciBootstrapLow(i) = bootMeanSorted(indexCiLow);
    indexCiHigh = B + 1 - indexCiLow; 
    ciBootstrapHigh(i) = bootMeanSorted(indexCiHigh);
end

% plot the low endpoint of the parametric and bootstrap ci
figure(1);
h1 = histogram(ciParametricLow);
title({'Low endpoints of the confidence intervals '...
    'of the standard deviation from the initial sample x'});
hold on;
h2 = histogram(ciBootstrapLow);
legend([h1, h2], {'Parametric', 'Bootstrap'});
hold off;

figure(2);
h3 = histogram(ciParametricHigh);
title({'High endpoints of the confidence intervals ';...
    'of the standard deviation from the initial sample x'});
hold on;
h4 = histogram(ciBootstrapHigh);
legend([h3, h4], {'Parametric', 'Bootstrap'});
hold off;

fprintf('X~N(%.1f, %.1f)\n', muX, sigmaX);
fprintf(['Parametric:\nMean for the standard deviations: [mean(ciLow), '...
    'mean(ciHigh)] = [%.3f, %.3f]\n\n'], ...
    mean(ciParametricLow), mean(ciParametricHigh));
fprintf(['Bootstrap:\nMean for the standard deviations: [mean(ciLow), ',...
    'mean(ciHigh)] = [%.3f, %.3f]\n\n'], ...
    mean(ciBootstrapLow), mean(ciBootstrapHigh));


% Notes on (a):
% It seems that the parametric test for the standard deviation is shifted 
% to the right in comparison to the standard deviation of the bootstrap 
% samples. 
% The confidence interval width remains somewhat the same for 
% both approaches (see figures).
% The same goes if we assume larger sample size (number of observations 
% (n)) per sample in the initial sample x.

%% (b)
y = x.^2;
alpha = 0.05;
%% (b.i) 
% varest performs a  variance test along each column (each one of the M 
% samples)
% ciParametric is a 2xM matrix of confidence intervals
muY = muX^2;
% the X^2 has 3*sigmaX^2 as variance
[~, ~, ciParametric, ~] = vartest(y, 3*sigmaX^2, 'Alpha', alpha);
ciParametricLow = sqrt(ciParametric(1, :));
ciParametricHigh = sqrt(ciParametric(2, :));

%% (b.ii)
B = 100;
ciBootstrapLow = NaN(1, M);
ciBootstrapHigh = NaN(1, M);
% calculation of M confidence intervals for the std of B bootstrap samples
% (columns in the initial sample x)
for i = 1:M
    bootMean = bootstrp(B, @std, y(:, i));
    indexCiLow = fix((B+1)*alpha/2);
    bootMeanSorted = sort(bootMean);
    ciBootstrapLow(i) = bootMeanSorted(indexCiLow);
    indexCiHigh = B + 1 - indexCiLow; 
    ciBootstrapHigh(i) = bootMeanSorted(indexCiHigh);
end

% plot the low endpoint of the parametric and bootstrap ci
figure(3);
h1 = histogram(ciParametricLow);
title({'Low endpoints of the confidence intervals '...
    'of the standard deviation from the transformed sample (x^2)'},...
    'interpreter', 'tex');
hold on;
h2 = histogram(ciBootstrapLow);
legend([h1, h2], {'Parametric', 'Bootstrap'});
hold off;

% plot the high endpoint of the parametric and bootstrap ci
figure(4);
h3 = histogram(ciParametricHigh);
title({'High endpoints of the confidence intervals ';...
    'of the standard deviation from the transformed sample (x^2)'},...
    'interpreter', 'tex');
hold on;
h4 = histogram(ciBootstrapHigh);
legend([h3, h4], {'Parametric', 'Bootstrap'});
hold off;

fprintf('Y = X^2\n');
fprintf(['Parametric:\nMean for the standard deviations: [mean(ciLow), '...
    'mean(ciHigh)] = [%.3f, %.3f]\n\n'], ...
    mean(ciParametricLow), mean(ciParametricHigh));
fprintf(['Bootstrap:\nMean for the standard deviations: [mean(ciLow), ',...
    'mean(ciHigh)] = [%.3f, %.3f]\n'], ...
    mean(ciBootstrapLow), mean(ciBootstrapHigh));


% Notes on (b):
% For the low endpoint of the confidence interval the parametric one seems 
% to be lerger than the bootstrap one. For the high endpoint, the two
% histograms share close values of for the estimation of the std.