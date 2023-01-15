% Stelios Topalidis
% AEM: 9613
% Exercise 5.5

clc;
clear;
close all;


importArray = importdata('lightair.dat');
% d is the air density
d = importArray(:, 1);
% Attention for the values of the speed of light.
% They are the differences from the speed of light in vacuum
cNormalized = importArray(:, 2);
scaleDownVal = 299000;
% c is the speed of light
c = cNormalized + scaleDownVal; 

nBoot = 100;
b0Estimates = nan(nBoot, 1); 
b1Estimates = nan(nBoot, 1);

%% Bootstrap samples from the bivariate sample (airDensity, speedOfLight)

% - The command below is the same as [~, bootSamIndices] = 
% bootstrp(nBoot, [], c);
% as we get the corresponding bivariate observations from the original 
% samples (d[i], c[i]) (as they were observed)
% and not (d[i], c[j]) (non corresponding values)
% - M: number of bootstrap samples
M = 1000;
[~, bootSamIndices] = bootstrp(M, [], d);

bootD = d(bootSamIndices);
bootC = c(bootSamIndices);

% Calculation of b0boot, b1Boot of all (M) bivariate (d, c)
% bootstrap samples.
% (b0Boot and b1Boot are row vectors)
b1Boot = nan(1, M);
% calculate the estimate b1 for every bootstrap sample
for bootSamCount = 1:M
    bootCovMat = cov(bootD(:, bootSamCount), bootC(:, bootSamCount));
    bootCov = bootCovMat(1, 2);
    b1Boot(bootSamCount) =  bootCov/var(bootD(:, bootSamCount));
end

% unless b1Boot is set to be a row vector as some lines above, the 
% element wise multiplication below will be of dimensions
% (1000x1)x(1X1000) => (1000,1000)
b0Boot = mean(bootC, 1) - b1Boot.*mean(bootD, 1);

% Significance level 
alpha = 0.05;

% Sort b0Boot, b1Boot and calculate the bootstrap ci limits 
b0BootSorted = sort(b0Boot);
b1BootSorted = sort(b1Boot);

% The bootstrap ci indexes are the same for both parameters of the linear
% model b0, b1. 
ciLowIndex = fix(M*(alpha/2));
ciHighIndex = M + 1 - ciLowIndex;

% Bootstrap ci values for b0, b1
[b0BootCILow, b0BootCIHigh] = deal(b0BootSorted(ciLowIndex), ...
    b0BootSorted(ciHighIndex));

[b1BootCILow, b1BootCIHigh] = deal(b1BootSorted(ciLowIndex), ...
    b1BootSorted(ciHighIndex));


% Real values of beta0 and beta1 
realC = 299792.458;
beta0 = realC;
d0 = 1.29;
beta1 = realC*(-0.00029/d0);

% 95% Parametric CI for b0 and b1 (taken from exercise 5.4)
% b0
[b0ParametricCILow, b0ParametricCIHigh] = deal(299756.902, 299826.983);
% b1
[b1ParametricCILow, b1ParametricCIHigh] = deal(-102.087, -33.025);


%% Graph of the estimations of b0 from the M bootstrap samples 
figure();
histogram(b0Boot);
title({'Estimations $b_0$ of parameter $\beta_0$ of the linear model'; ...
    ['for M = ', num2str(M), ...
    ' bootstrap samples of the original sample (d, c)']}, 'LineWidth', 2, ...
    'interpreter', 'latex');
xlabel('$\beta_0$', 'Color', 'k', 'interpreter', 'latex');
xline([b0BootCILow, b0BootCIHigh], '-', {'$\frac{\alpha}{2}\%$', ...
    '$1-\frac{\alpha}{2}\%$'}, 'Color', 'r', 'LineWidth', 2, ...
    'interpreter', 'latex');
xline(beta0, '-', {'Real value of $\beta_0$'}, 'interpreter', 'latex',...
    'LineWidth', 2);

% % Uncomment the code below to include the parametric ci for b0
% % in the graph 
% xline([b0ParametricCILow, b0ParametricCIHigh], '-', ...
%     {'$\frac{\alpha}{2}\%$', ...
%     '$1-\frac{\alpha}{2}\%$'}, 'Color', 'g', 'LineWidth', 2, ...
%     'interpreter', 'latex');
% legend('','Bootstrap CI', '', '', 'Parametric CI');




%% Graph of the estimations of b1 from the M bootstrap samples
figure();
histogram(b1Boot);
title({'Estimations $b_1$ of parameter $\beta_1$ of the linear model'; ...
    ['for M = ', num2str(M), ...
    ' bootstrap samples of the original sample (d, c)']}, 'LineWidth', 2, ...
    'interpreter', 'latex');
xlabel('$\beta_1$', 'Color', 'k', 'interpreter', 'latex');
xline([b1BootCILow, b1BootCIHigh], '-', {'$\frac{\alpha}{2}\%$', ...
    '$1-\frac{\alpha}{2}\%$'}, 'Color', 'r', 'LineWidth', 2, ...
    'interpreter', 'latex');
xline(beta1, '-', {'Real value of $\beta_1$'}, 'interpreter', 'latex',...
    'LineWidth', 2);

% % Uncomment the code below to include the parametric ci for b1 
% % in the graph 
% xline([b1ParametricCILow, b1ParametricCIHigh], '-', ...
%     {'$\frac{\alpha}{2}\%$', ...
%     '$1-\frac{\alpha}{2}\%$'}, 'Color', 'g', 'LineWidth', 2, ...
%     'interpreter', 'latex');
% legend('','Bootstrap CI', '', '', 'Parametric CI');



%% Comparison between the bootstrap and the parametric ci for b0 and b1
fprintf(['Parametric vs non parametric (bootstrap) method\n',...
    'for %.2f%% confidence:\n'], 100*(1-alpha));
% b0
fprintf('- b0\n');
fprintf('Real beta0 value: %.3f + %.3f\n', beta0 -scaleDownVal, scaleDownVal);
fprintf('Bootstrap ci: [%.3f, %.3f] + %.3f\n', ...
     b0BootCILow-scaleDownVal, b0BootCIHigh-scaleDownVal,...
     scaleDownVal);


fprintf('Parametric ci: [%.3f, %.3f] + %.3f\n\n', ...
     b0ParametricCILow-scaleDownVal, ...
     b0ParametricCIHigh-scaleDownVal, scaleDownVal);

% b1
fprintf('- b1\n');
fprintf('Real beta1 value: %.3f \n', beta1);
fprintf('Bootstrap ci: [%.3f, %.3f] \n', ...
     b1BootCILow, b1BootCIHigh);

fprintf('Parametric ci: [%.3f, %.3f]\n\n', ...
     b1ParametricCILow, b1ParametricCIHigh);



% Notes: 
% 1. The 95% parametric ci for the linear parameters was taken from 
% exercise 5.4.
% The parametric ci for b0 is [299756.902, 299826.983] 
% and the one for b1 is [-102.087, -33.025] 
% 2. The bootstrap ci is narrower (/stricter) than the parametric one.