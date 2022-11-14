% Stelios Topalidis
% AEM: 9613
% Exercise 3.10

clc;
clear;
close all;

M = 100;
n = 10;
muX = 0;
sigmaX = 1;
X = normrnd(muX, sigmaX, n, M);

alpha = 0.05;

%% (a) Calculation of p-values for each sample
%% (i) Parametric
% Check of the hypothesis that mean = 0
p = nan(M, 1);
rejectCount = 0;
mu = 0;
for i = 1:M
    [h, p(i)] = ttest(X(:, i), mu, 'Alpha', alpha);
    if h == 1
        rejectCount = rejectCount + 1;
    end
end
rejectPercent = rejectCount/M*100;

fprintf('(a)\n(a.i) Parametric:\n');
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x] = %.2f: %.2f%% of the times.\n'], mu, rejectPercent);

figure(1);
nbins  = M/10;
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the parametric method']});
% seems to be following a uniform distribution

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');

% Check of the hypothesis that mean = 0.5
rejectCount = 0;
mu = 0.5;
for i = 1:M
    [h, p(i)] = ttest(X(:, i), mu, 'Alpha', alpha);
    if h == 1
        rejectCount = rejectCount + 1;
    end
end

rejectPercent = rejectCount/M*100;

fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x] = %.2f: %.2f%% of the times.\n\n'], mu, rejectPercent);


figure(2);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the parametric method']});

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');



%% (ii) Bootstrap
B = 1000;
    
% Check of the hypothesis that mean = 0
p = nan(M, 1);
mu = 0;
% mu = 100;
rejectCount = 0;

% get the p-value for each of the M samples using bootstrap
for i = 1:M
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamIndices] = bootstrp(B, [], X(:, i));
    bootSam = X(bootSamIndices);
    % computing the means for all B bootstrap samples
    bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [h, p(i)] = ttest(bootSamMean, mu, 'Alpha', alpha); 
    if h == 1
        rejectCount = rejectCount + 1;
    end
end



rejectPercent = rejectCount/M*100;
fprintf('(a.ii) Bootstrap:\n');
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x] = %.2f: %.2f%% of the times.\n'], mu, rejectPercent);


figure(3);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the bootstrap method']});

% Check of the hypothesis that mean = 0.5
p = nan(M, 1);
mu = 0.5;
rejectCount = 0;

% get the p-value for each of the M samples using bootstrap
for i = 1:M
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamIndices] = bootstrp(B, [], X(:, i));
    bootSam = X(bootSamIndices);
    % computing the means for all B bootstrap samples
    bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [h, p(i)] = ttest(bootSamMean, mu, 'Alpha', alpha); 
    if h == 1
        rejectCount = rejectCount + 1;
    end
end



rejectPercent = rejectCount/M*100;
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x] = %.2f: %.2f%% of the times.\n\n'], mu, rejectPercent);


figure(4);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the bootstrap method']});


% Find the percentage of rejection for the hypotheses

%% (b) Calculation of p-values for each sample
%% (i) Parametric
X2 = X.^2;
% Check of the hypothesis that mean = 0
p = nan(M, 1);
rejectCount = 0;
mu = 0;
for i = 1:M
    [h, p(i)] = ttest(X2(:, i), mu, 'Alpha', alpha);
    if h == 1
        rejectCount = rejectCount + 1;
    end
end
rejectPercent = rejectCount/M*100;

fprintf('(b.i) Parametric:\n');
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x^2] = %.2f: %.2f%% of the times.\n'], mu, rejectPercent);

figure(5);
nbins  = M/10;
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the parametric method']});
% seems to be following a uniform distribution

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');

% Check of the hypothesis that mean = 0.5
rejectCount = 0;
mu = 0.5;
for i = 1:M
    [h, p(i)] = ttest(X2(:, i), mu, 'Alpha', alpha);
    if h == 1
        rejectCount = rejectCount + 1;
    end
end

rejectPercent = rejectCount/M*100;

fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x^2] = %.2f: %.2f%% of the times.\n\n'], mu, rejectPercent);


figure(6);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the parametric method']});

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');


%% (ii) Bootstrap
B = 1000;
    
% Check of the hypothesis that mean = 0
p = nan(M, 1);
mu = 1;
% mu = 100;
rejectCount = 0;

% get the p-value for each of the M samples using bootstrap
for i = 1:M
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamIndices] = bootstrp(B, [], X2(:, i));
    bootSam = X2(bootSamIndices);
    % computing the means for all B bootstrap samples
    bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [h, p(i)] = ttest(bootSamMean, mu, 'Alpha', alpha); 
    if h == 1
        rejectCount = rejectCount + 1;
    end
end



rejectPercent = rejectCount/M*100;
fprintf('(b.ii) Bootstrap:\n'); 
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x^2] = %.2f: %.2f%% of the times.\n'], mu, rejectPercent);


figure(7);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the bootstrap method']});

% Check of the hypothesis that mean = 0.5
p = nan(M, 1);
mu = 0.5;
rejectCount = 0;

% get the p-value for each of the M samples using bootstrap
for i = 1:M
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamIndices] = bootstrp(B, [], X2(:, i));
    bootSam = X(bootSamIndices);
    % computing the means for all B bootstrap samples
    bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [h, p(i)] = ttest(bootSamMean, mu, 'Alpha', alpha); 
    if h == 1
        rejectCount = rejectCount + 1;
    end
end



rejectPercent = rejectCount/M*100;
fprintf(['Number of rejections of the hypothesis that\n',...
    'E[x^2] = %.2f: %.2f%% of the times.\n'], mu, rejectPercent);


figure(8);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the bootstrap method']});



% Find the percentage of rejection for the hypotheses
