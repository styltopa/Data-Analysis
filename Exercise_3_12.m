% Stelios Topalidis
% AEM: 9613
% Exercise 3.12

% clc;
% clear;
% close all;

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
% pooled sample
pSam = [X; Y];
rejectCount = 0;

B = 1000;
% for each of the M samples
for i = 1:M
   % mean value of the initial pooled (x, y) sample
   mZ = mean(pSam(:, i), 1);
   mX = mean(X(:, i), 1);
   mY = mean(Y(:, i), 1);
   
   % x and y derived from the separation of the pooled sample
   pX = pSam(1:n, :);
   pY = pSam(n+1:n+m, :);
   
   % centered x and y 
   cX = pX - mX - mZ;
   cY = pY - mY - mZ;
   
   % centered samples x and y into a pooled sample cpSam (centered pooled
   % sample)
   cpSam = [cX; cY];
   cpCol = cpSam(:,i);
   [~, pSamIndexes] = bootstrp(B, [], cpCol);
   pBootSam = cpCol(pSamIndexes);
 

   % separation into bootstrap samples x and y
   pX = pBootSam(1:n, :);
   pY = pBootSam(n+1: n+m, :);

   % calculation of the mean for each bootstrap x, y sample 
   % and the diff of their means
   mX = mean(pX, 1);
   mY = mean(pY, 1);
   diffOfMeans = mX - mY;
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