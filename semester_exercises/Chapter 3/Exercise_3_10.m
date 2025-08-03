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
% rCount: rejection counter 

rCount = 0;
mu = 0;
for i = 1:M
    [h, p(i)] = ttest(X(:, i), mu, 'Alpha', alpha);
    if h == 1
        rCount = rCount + 1;
    end
end
% rPercent: rejection percentage
rPercent = rCount/M*100;

fprintf('(a)\n(a.i) Parametric:\n');
fprintf(['The hypothesis that E[x] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n'], mu, rPercent);

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
rCount = 0;
mu = 0.5;
for i = 1:M
    [h, p(i)] = ttest(X(:, i), mu, 'Alpha', alpha);
    if h == 1
        rCount = rCount + 1;
    end
end

rPercent = rCount/M*100;

fprintf(['The hypothesis that E[x] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n\n'], mu, rPercent);


figure(2);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the parametric method']});

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');



%% (ii) Bootstrap
% Note: I  used the parametric ttest to calculate the p-values of x
B = 1000;
    
% Check of the hypothesis that mean = 0
p = nan(M, 1);
mu = 0;
% mu = 100;
rCount = 0;

% mean of B p-values for each column (M in total) in the initial sample
% p-value boot mean
for i = 1:M
    % iSamCol
    iSamCol = X(:, i);
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamInd] = bootstrp(B, [], iSamCol);
    bootSam = iSamCol(bootSamInd);
    % computing the means for all B bootstrap samples
%     bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [~, pbArr] = ttest(bootSam, mu, 'Alpha', alpha);
    p(i) = mean(pbArr);
    %     if the null hypothesis is rejected
    if p(i) < alpha
        rCount = rCount + 1;
    end
end



rPercent = rCount/M*100;
fprintf('(a.ii) Bootstrap:\n');
fprintf(['The hypothesis that E[x] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n'], mu, rPercent);


figure(3);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the bootstrap method']});

% Check of the hypothesis that mean = 0.5
p = nan(M, 1);
mu = 0.5;
rCount = 0;

% mean of B p-values for each column (M in total) in the initial sample
% p-value boot mean
for i = 1:M
    % iSamCol
    iSamCol = X(:, i);
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamInd] = bootstrp(B, [], iSamCol);
    bootSam = iSamCol(bootSamInd);
    % computing the means for all B bootstrap samples
%     bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [~, pbArr] = ttest(bootSam, mu, 'Alpha', alpha);
    p(i) = mean(pbArr);
   %     if the null hypothesis is rejected
    if p(i) < alpha
        rCount = rCount + 1;
    end
end



rPercent = rCount/M*100;
fprintf(['The hypothesis that E[x] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n\n'], mu, rPercent);


figure(4);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x] = ', num2str(mu), ...
    ' using the bootstrap method']});


% Find the percentage of rejection for the hypotheses

%% (b) Calculation of p-values for each sample
%% (i) Parametric
X2 = X.^2;
% Check of the hypothesis that mean = 1
mu = 1;
p = nan(M, 1);
% rCount: rejection counter
rCount = 0;

for i = 1:M
    [h, p(i)] = ttest(X2(:, i), mu, 'Alpha', alpha);
    if h == 1
        rCount = rCount + 1;
    end
end
% rPercent: rejection percent
rPercent = rCount/M*100;

fprintf('(b.i) Parametric:\n');
fprintf(['The hypothesis that E[x^2] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n'], mu, rPercent);

figure(5);
nbins  = M/10;
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the parametric method']});
% seems to be following a uniform distribution

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');

% Check of the hypothesis that mean = 2
rCount = 0;
mu = 2;
for i = 1:M
    [h, p(i)] = ttest(X2(:, i), mu, 'Alpha', alpha);
    if h == 1
        rCount = rCount + 1;
    end
end

rPercent = rCount/M*100;

fprintf(['The hypothesis that E[x^2] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n\n'], mu, rPercent);


figure(6);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the parametric method']});

lowPValue = 0.05;
xline(lowPValue, '-', 'Low enough p-value');


%% (ii) Bootstrap
B = 1000;
    
% Check of the hypothesis that mean = 1
p = nan(M, 1);
mu = 1;
% mu = 100;
rCount = 0;

% mean of B p-values for each column (M in total) in the initial sample
% p-value boot mean
for i = 1:M
    % iSamCol
    iSamCol = X(:, i);
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamInd] = bootstrp(B, [], iSamCol);
    bootSam = iSamCol(bootSamInd);
    % computing the means for all B bootstrap samples
%     bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    
    [~, pbArr] = ttest(bootSam, mu, 'Alpha', alpha);
    p(i) = mean(pbArr);
%     if the null hypothesis is rejected
    if p(i) < alpha
        rCount = rCount + 1;
    end
end



rPercent = rCount/M*100;
fprintf('(b.ii) Bootstrap:\n'); 
fprintf(['The hypothesis that E[x^2] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n'], mu, rPercent);


figure(7);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the bootstrap method']});

% Check of the hypothesis that mean = 2
p = nan(M, 1);
mu = 2;
rCount = 0;

% mean of B p-values for each column (M in total) in the initial sample
% p-value boot mean
pbMean = 0;
for i = 1:M
    % iSamCol
    iSamCol = X(:, i);
    % get the bootstrap sample for each of the M initial samples
    [~, bootSamInd] = bootstrp(B, [], iSamCol);
    bootSam = iSamCol(bootSamInd);
    % computing the means for all B bootstrap samples
%     bootSamMean = mean(bootSam, 1);
    % testing if the zero value belongs to the bootstrap samples with 
    % 95% confidence 
    [~, pbArr] = ttest(bootSam, mu, 'Alpha', alpha);
    p(i) = mean(pbArr);
%     if the null hypothesis is rejected
    if p(i) < alpha
        rCount = rCount + 1;
    end
end



rPercent = rCount/M*100;
fprintf(['The hypothesis that E[x^2] = %.2f \nwas rejected ',...
    '%.2f%% of the times.\n'], mu, rPercent);


figure(8);
histogram(p, nbins);
title({['Histogram of the p-values of M = ', num2str(M), ' samples'];...
    ['for the hypothesis that E[x^2] = ', num2str(mu), ...
    ' using the bootstrap method']});



% Notes: 
% (i) In the case of the normal distributed samples, the parametric test is
% more strict (higher rejection rate) 
% on the acceptance of the null hypothesis for both tested
% values for the mean (0, 0.5) than the bootstrap test.

% (ii) In the case of the squared samples, the bootstrap seems to be more strict
% (higher rejection rate)