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
% rCount: rejection counter
rCount = 0;
for i = 1:M
    [h, ~] = ttest2(X(:, i), Y(:, i), 'Alpha', alpha);
    if h == 1
        rCount = rCount + 1;
    end
end

% rPercent: rejection percentage
rPercent = rCount/M*100;
fprintf('- Parametric test\n');
fprintf(['The hypothesis that X and Y share the same mean \n',...
    'was rejected %.1f%% of the times.\n'], rPercent);

%% Bootstrap
B = 1000;
% initial X and Y put into a pooled sample (pSam)
pSam = [X; Y];
rCount = 0;
% for each pooled sample
for i = 1:M
    % xCol: the column of the initial sample
    xCol = pSam(:,i);
    % calculation of the pooled bootstrap sample
    [~, pSamIndexes] = bootstrp(B, [], xCol);
    pBootSam = xCol(pSamIndexes);
    
    % separation into bootstrap samples x and y
    pX = pBootSam(1:n, :);
    pY = pBootSam(n+1: n+m, :);

    % calculation of the mean for each bootstrap x, y sample 
    % and the diff of their means
    meanX = mean(pX, 1);
    meanY = mean(pY, 1);
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
        rCount = rCount + 1;
    end
end

% percentage where zero is inside the ci of the difference of the means
rPercent = rCount/M*100;

fprintf('- Bootstrap test\n');
fprintf(['The hypothesis that X and Y share the same mean\n',...
    'was rejected %.1f%% of the times\n'], rPercent);

%% Random Permutation
% X and Y joined into a pooled sample (pSam)
pSam = [X; Y];
randPermSam = nan(n+m, B);
rCount = 0;

for i = 1:M
    % each of the samples is a column (pSamCol) of the pooled sample (pSam)
    pSamCol = pSam(:, i);
    % for each sample derived from a random permutation
    for j = 1:B
       % finding the indices of one of the B samples using random 
       % permutation
       permIndices = randperm(n+m);
       randPermSam(:, j) = pSamCol(permIndices);
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
        rCount = rCount + 1;
    end
end

rPercent = rCount/M*100;

fprintf('- Random permutation test\n');
fprintf(['The hypothesis that X and Y share the same mean\n',...
    'was rejected %.1f%% of the times\n\n'], rPercent);

% Notes: The three tests seem to agree.
