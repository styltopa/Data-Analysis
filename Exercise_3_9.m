% Stelios Topalidis
% AEM: 9613
% Exercise 3.9

clc;
clear;
close all;

%% (a) Calculation of the ci for the difference of the means of...
%%  X and Y ~N(0,1)
% For both methods (the parametric and the bootstrap) 
% the confidence interval is expected to contain the zero value
% (meaning that the mean values of X, Y are the same)

% number of samples
M = 100;
% number of observations per sample
n = 10;
m = 12;
[muX, muY, sigmaX, sigmaY] = deal(0, 0, 1, 1);
alpha = 0.05;

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);
% (i) Parametric method
% the ttest is used for the means of each one of the M samples 
zeroInCiCounter = 0;
for i = 1:M
    [~, ~, ciParam, ~] = ttest2(X(:,i), Y(:, i), 'Alpha', alpha);
    if ciParam(1) < 0 && ciParam(2) > 0 
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;
fprintf(['(a)\nParametric: The means are equal (zero is inside the ci\n',...
    'or diff of means = 0) %.1f%% of the times \n'], zeroInCiPercentage);

% (ii) Bootstrap sampling method
B = 1000;
% 
initialPooledSample = [X; Y];
zeroInCiCounter = 0;
% for each pooled sample
for i = 1:M
    initialSampleCol = initialPooledSample(:,i);
    % calculation of the pooled bootstrap sample
    [~, pooledSampleIndices] = bootstrp(B, [], initialSampleCol );
    pooledBootSam = initialSampleCol(pooledSampleIndices);
    
    % separation into bootstrap samples x and y
    pooledX = pooledBootSam(1:n, :);
    pooledY = pooledBootSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(pooledX, 1);
    meanY = mean(pooledY, 1);
    diffOfMeans = meanX - meanY;
    diffOfMeansSorted = sort(diffOfMeans);
    
    % constains the indexes for the low and high bounds of the ci 
    ciBootIndexes = nan([2, 1]);
    ciBootIndexes(1) = fix((alpha/2)*(B+1));
    k = ciBootIndexes(1);
    ciBootIndexes(2) = B + 1 - k;

    ciBoot = [diffOfMeansSorted(ciBootIndexes(1)),...
              diffOfMeansSorted(ciBootIndexes(2))];
    if ciBoot(1) < mean(X(:,i)) - mean(Y(:,i))  && ...
            ciBoot(2) > mean(X(:,i)) - mean(Y(:,i)) 
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;

fprintf(['Bootstrap: The means are equal (zero is inside the ci \n',...
    'or diff of means = 0) %.1f%% of the times\n\n'],...
    zeroInCiPercentage);

%% (b) Calculation of the ci for the difference of the means of 
%% X^2 and Y^2, where X,Y ~N(0,1)
% Due to the transform, the parametric might give us negative values 
% which is false as X^2 and Y^2 are both positive
[X2, Y2] = deal(X.^2, Y.^2);

% (i) Parametric method
% the ttest is used for the means of each one of the M samples 
zeroInCiCounter = 0;
for i = 1:M
    [~, ~, ciParam, ~] = ttest2(X2(:,i), Y2(:, i), 'Alpha', alpha);
    if ciParam(1) < 0 && ciParam(2) > 0
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;
fprintf(['(b)\nParametric: The means are equal (zero is inside the ci\n',...
    'or diff of means = 0) %.1f%% of the times \n'], zeroInCiPercentage);

% (ii) Bootstrap sampling method
B = 1000;
% 
initialPooledSample = [X2; Y2];
zeroInCiCounter = 0;
% for each pooled sample
for i = 1:M
    initialSampleCol = initialPooledSample(:,i);
    % calculation of the pooled bootstrap sample
    [~, pooledSampleIndices] = bootstrp(B, [], initialSampleCol);
    pooledBootSam = initialSampleCol(pooledSampleIndices);
    
    % separation into bootstrap samples x and y
    pooledX = pooledBootSam(1:n, :);
    pooledY = pooledBootSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(pooledX, 1);
    meanY = mean(pooledY, 1);
    diffOfMeans = meanX - meanY;
    diffOfMeansSorted = sort(diffOfMeans);
    
    % constains the indexes for the low and high bounds of the ci 
    ciBootIndexes = nan([2, 1]);
    ciBootIndexes(1) = fix((alpha/2)*(B+1));
    k = ciBootIndexes(1);
    ciBootIndexes(2) = B + 1 - k;

    ciBoot = [diffOfMeansSorted(ciBootIndexes(1)),...
              diffOfMeansSorted(ciBootIndexes(2))];
    if ciBoot(1) < 0 && ciBoot(2) > 0
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;

fprintf(['Bootstrap: The means are equal (zero is inside the ci \n',...
    'or diff of means = 0) %.1f%% of the times \n\n\n'],...
    zeroInCiPercentage);



%% (c) Repeating the above for Y ~ N(0.2, 1) this time
%% (c.a)
% (i) 
%% Calculation of the ci for the difference of the means of...
%%  X ~N(0,1) and Y ~N(0.2,1)
% For both methods (the parametric and the bootstrap) 
% the confidence interval is expected to contain the zero value
% (meaning that the mean values of X, Y are the same)

% number of samples
M = 100;
% number of observations per sample
n = 10;
m = 12;
[muX, muY, sigmaX, sigmaY] = deal(0, 0.2, 1, 1);
alpha = 0.05;

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);

% (i) Parametric method
% the ttest is used for the means of each one of the M samples 
zeroInCiCounter = 0;
for i = 1:M
    [~, ~, ciParam, ~] = ttest2(X(:,i), Y(:, i), 'Alpha', alpha);
    if ciParam(1) < 0 && ciParam(2) > 0
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;
fprintf(['(c.a)\nParametric: The means are equal (zero is inside the ci\n',...
    'or diff of means = 0) %.1f%% of the times \n'], zeroInCiPercentage);

% (ii) Bootstrap sampling method
B = 1000;
% 
initialPooledSample = [X; Y];
zeroInCiCounter = 0;
% for each pooled sample
for i = 1:M
    initialSampleCol = initialPooledSample(:,i);
    % calculation of the pooled bootstrap sample
    [~, pooledSampleIndices] = bootstrp(B, [], initialSampleCol);
    pooledBootSam = initialSampleCol(pooledSampleIndices);
    
    % separation into bootstrap samples x and y
    pooledX = pooledBootSam(1:n, :);
    pooledY = pooledBootSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(pooledX, 1);
    meanY = mean(pooledY, 1);
    diffOfMeans = meanX - meanY;
    diffOfMeansSorted = sort(diffOfMeans);
    
    % constains the indexes for the low and high bounds of the ci 
    ciBootIndexes = nan([2, 1]);
    ciBootIndexes(1) = fix((alpha/2)*(B+1));
    k = ciBootIndexes(1);
    ciBootIndexes(2) = B + 1 - k;

    ciBoot = [diffOfMeansSorted(ciBootIndexes(1)),...
              diffOfMeansSorted(ciBootIndexes(2))];
    if ciBoot(1) < 0 && ciBoot(2) > 0
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;

fprintf(['Bootstrap: The means are equal (zero is inside the ci \n',...
    'or diff of means = 0) %.1f%% of the times\n\n'],...
    zeroInCiPercentage);

%% (c.b) Calculation of the ci for the difference of the means of 
%% X^2 and Y^2, where X~N(0,1) and Y ~N(0.2,1)
% Due to the transform, the parametric might give us negative values 
% which is false as X^2 and Y^2 are both positive
[X2, Y2] = deal(X.^2, Y.^2);

% (i) Parametric method
% the ttest is used for the means of each one of the M samples 
zeroInCiCounter = 0;
for i = 1:M
    [~, ~, ciParam, ~] = ttest2(X2(:,i), Y2(:, i), 'Alpha', alpha);
    if ciParam(1) < mean(X2(:,i)) - mean(Y2(:,i))  && ...
            ciBoot(2) > mean(X2(:,i)) - mean(Y2(:,i))
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;
fprintf(['(c.b)\nParametric: The means are equal (zero is inside the ci\n',...
    'or diff of means = 0) %.1f%% of the times \n'], zeroInCiPercentage);

% (ii) Bootstrap sampling method
B = 1000;
% 
initialPooledSample = [X2; Y2];
zeroInCiCounter = 0;
% for each pooled sample
for i = 1:M
    initialSampleCol = initialPooledSample(:,i);
    % calculation of the pooled bootstrap sample
    [~, pooledSampleIndices] = bootstrp(B, [], initialSampleCol);
    pooledBootSam = initialSampleCol(pooledSampleIndices);
    
    % separation into bootstrap samples x and y
    pooledX = pooledBootSam(1:n, :);
    pooledY = pooledBootSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(pooledX, 1);
    meanY = mean(pooledY, 1);
    diffOfMeans = meanX - meanY;
    diffOfMeansSorted = sort(diffOfMeans);
    
    % constains the indexes for the low and high bounds of the ci 
    ciBootIndexes = nan([2, 1]);
    ciBootIndexes(1) = fix((alpha/2)*(B+1));
    k = ciBootIndexes(1);
    ciBootIndexes(2) = B + 1 - k;

    ciBoot = [diffOfMeansSorted(ciBootIndexes(1)),...
              diffOfMeansSorted(ciBootIndexes(2))];
    if ciBoot(1) < 0 && ciBoot(2) > 0
        zeroInCiCounter = zeroInCiCounter + 1;
    end
end
% percentage where zero is inside the ci of the difference of the means
zeroInCiPercentage = zeroInCiCounter/M*100;

fprintf(['Bootstrap: The means are equal (zero is inside the ci \n',...
    'or diff of means = 0) %.1f%% of the times \n\n'],...
    zeroInCiPercentage);


