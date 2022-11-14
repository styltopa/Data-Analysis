% Stelios Topalidis
% AEM: 9613
% Exercise 3.12

clc;
clear;
close all;

% number of samples
M = 100;
% number of observations per sample
n = 10;
m = 12;
[muX, muY, sigmaX, sigmaY] = deal(0, 0, 1, 2);
alpha = 0.05;
% alpha = 0.1;

X = normrnd(muX, sigmaX, n, M);
Y = normrnd(muY, sigmaY, m, M);
pooledSam = [X; Y];
rejectCount = 0;

B = 1000;
% for each of the M samples
for i = 1:M
   % mean value of the initial pooled (x, y) sample
   meanZ = mean(pooledSam(:, i), 1);
   meanX = mean(X(:, i), 1);
   meanY = mean(Y(:, i), 1);
   
   pooledX = pooledSam(1:n, :);
   pooledY = pooledSam(n+1:n+m, :);
   
   centeredX = pooledX - meanX - meanZ;
   centeredY = pooledY - meanY - meanZ;
   
  
   centeredPooledSample = [centeredX; centeredY];
   [~, pooledSampleIndices] = bootstrp(B, [], centeredPooledSample(:,i));
   pooledBootSam = centeredPooledSample(pooledSampleIndices);

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
rejectPercentage = rejectCount/M*100;

fprintf(['Bootstrap: The means of the centered samples are equal\n',...
    '(zero is inside the ci of the percentiles) \n',...
    '%.1f%% of the times \n'],...
    rejectPercentage);