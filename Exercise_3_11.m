% Stelios Topalidis
% AEM: 9613
% Exercise 3.11

clc;
clear;
close all;

% number of samples
M = 100;
% number of observations per sample
n = 10;
m = 12;
[muX, muY, sigmaX, sigmaY] = deal(0, 0, 1, 1);
% alpha = 0.05;
alpha = 0.1;

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);
fprintf('For significance level a = %.3f:\n', alpha);

%% Parametric
% check the hypothesis of the variables sharing the same mean for 
% each sample
rejectCount = 0;
for i = 1:M
    [h, ~] = ttest2(X(:, i), Y(:, i), 'Alpha', alpha);
    if h == 1
        rejectCount = rejectCount + 1;
    end
end

rejectPercent = rejectCount/M*100;
fprintf('Parametric test\n');
fprintf(['The hypothesis that X and Y share the same mean \n',...
    'was rejected %.1f%% of the times.\n'], rejectPercent);

%% Bootstrap
B = 1000;
% 
initialPooledSample = [X; Y];
rejectCount = 0;
% for each pooled sample
for i = 1:M
    % calculation of the pooled bootstrap sample
    [~, pooledSampleIndices] = bootstrp(B, [], initialPooledSample(:,i));
    pooledBootSam = initialPooledSample(pooledSampleIndices);
    
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
    if mean(X(:,i)) - mean(Y(:,i))  < ciBoot(1) || ...
            mean(X(:,i)) - mean(Y(:,i)) > ciBoot(2) 
        rejectCount = rejectCount + 1;
    end
end

% percentage where zero is inside the ci of the difference of the means
rejectPercent = rejectCount/M*100;

fprintf('Bootstrap test\n');
fprintf(['The hypothesis that X and Y share the same mean\n',...
    'was rejected %.1f%% of the times\n'], rejectPercent);

%% Random Permutation
% the indices of the sample using random permutation
pooledSam = [X; Y];
randPermSam = nan(n+m, B);
rejectCount = 0;

for i = 1:M
    for j = 1:B
       permIndices = randperm(n+m);       
       randPermSam(:, j) = pooledSam(permIndices); 
    end
    % separation into random permuted samples x and y
    randPermX = randPermSam(1:n, :);
    randPermY = randPermSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(randPermX, 1);
    meanY = mean(randPermY, 1);
    diffOfMeans = meanX - meanY;
    diffOfMeansSorted = sort(diffOfMeans);
    
    % constains the indexes for the low and high bounds of the ci 
    % the calculation of the ci is the same as with the bootstrap
    ciBootIndexes = nan([2, 1]);
    ciBootIndexes(1) = fix((alpha/2)*(B+1));
    k = ciBootIndexes(1);
    ciBootIndexes(2) = B + 1 - k;

    ciBoot = [diffOfMeansSorted(ciBootIndexes(1)),...
              diffOfMeansSorted(ciBootIndexes(2))];
    if mean(X(:,i)) - mean(Y(:,i))  < ciBoot(1) || ...
            mean(X(:,i)) - mean(Y(:,i)) > ciBoot(2) 
        rejectCount = rejectCount + 1;
    end
end

rejectPercent = rejectCount/M*100;

fprintf('Random permutation test\n');
fprintf(['The hypothesis that X and Y share the same mean\n',...
    'was rejected %.1f%% of the times\n\n'], rejectPercent);

% Notes: The three test seem to agree.
