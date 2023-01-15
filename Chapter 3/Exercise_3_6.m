% Stelios Topalidis
% AEM: 9613
% Exercise 3.6

clc;
close all;

%% (a) histogram of bootstrap samples' means
n = 10;
x = randn(n, 1);

B = 1000;
% bootMeansX: vector with the means of each bootstrap sample
% bootSamplesIndicesX: the indices of the values of the initial sample from 
% which the bootstrap samples were drawn.
[bootMeansX, bootSamplesIndicesX] =  bootstrp(B, @mean, x);
% the actual bootstrap samples of the initial sample x
bootSamplesX = x(bootSamplesIndicesX);

clf;
figure(1);
histogram(bootMeansX);
title(['Histogram of the sample mean ($$\bar{x}$$) for B = ',...
    num2str(B),' bootstrap samples'], ['skewness: ',...
    num2str(skewness(bootMeansX), 2)], 'interpreter', 'latex');
ylabel('Relative frequencies');
xline(mean(x), '-', 'Initial sample mean', 'LineWidth', 2, ...
    'Color', 'r', 'LabelOrientation', 'horizontal');

%% (b) standard error of mean from bootstrap samples and 
% from initial sample


fprintf(['(b)\nStandard error (standard deviation) of the initial sample: ',...
 '%.3f\n\n'], std(x));
fprintf(['Bootstrap estimation of standard error (standard ', ...
    'deviation)\nof the sample mean of x: %.3f\n\n'], std(bootMeansX));
% Note: The means of the bootstrap samples are (more or 
% less) similar to one another since the samples are close to the initial 
% one due to the same probability of the initial elements to be resampled.
% Therefore, it is expected that 
% their std will be smaller than the one in the initial sample
 fprintf('RatioX: %.3f\n\n', std(x)/std(bootMeansX));

%% (c) % steps (a) and (b) for y = e^x
%% (c.a)
% y is the transformed initial sample x 
y = exp(x);
% NOTE: I transformed the elements of the bootstrap samples (bootSamplesX)
% calculated in a) (did not resample the initial sample)
bootSamplesY = exp(bootSamplesX);
bootMeansY = mean(bootSamplesY);


figure(2);
histogram(bootMeansY);
title(['Histogram of the sample mean ($$\bar{y}$$) for B = ',...
    num2str(B),' bootstrap samples'], ['skewness: ',...
    num2str(skewness(bootMeansY), 2)],'interpreter', 'latex');
ylabel('Relative frequencies');
xline(mean(bootMeansY), '-', 'Initial sample mean', 'LineWidth', 2, ...
    'Color', 'r', 'LabelOrientation', 'horizontal');
% Note: skewness increases (histogram shifts to the left 
% with the y = e^x transform


%% (c.b)

fprintf(['(c)\nStandard error (standard deviation) of the initial sample: ',...
 '%.3f\n\n'], std(y));
fprintf(['Bootstrap estimation of standard error (standard ', ...
    'deviation)\nof the sample mean of y: %.3f\n\n'], std(bootMeansY));
fprintf('RatioY: %.3f\n\n', std(y)/std(bootMeansY));
