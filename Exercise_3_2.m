% Stelios Topalidis
% AEM: 9613
% Exercise 3.2

clc;
%% (a) Proof that the maximum likelihood estimator of lamda of the 
% exponential distribution is equal to the inverse of the sample mean 
%
% x = [x_1, x_2, ..., x_n]
% L(x; lamda) = f_X(x_1)*f_X(x_2)*...*f_X(x_n)
% L(x; lamda) = lamda * exp(-lamda*x_1) * lamda * exp(-lamda*x_2) *...
%               lamda * exp(-lamda*x_n); 
% L(x; lamda) = lamda^n * exp(-lamda * (sum of x_i from i=1 to i=n))
% 
% 
% dL/d(lamda) = 0 => 
%
% n * lamda^(n-1) * exp(-lamda * (sum of x_i from i=1 to i=n)) + 
% lamda^n * (sum of x_i from i=1 to i=n) * 
% exp(-*lamda * (sum of x_i from i=1 to i=n)

% lamda^(n-1) * exp(-lamda * (sum of x_i from i=1 to i=n)) * 
% (n - lamda * (sum of x_i from i=1 to i=n)) = 0
% 
% => (n - lamda * (sum of x_i from i=1 to i=n)) = 0
% lamda = n/(sum of x_i from i=1 to i=n)
% lamda = ((sum of x_i from i=1 to i=n)/n)^(-1)
% lamda = (sample mean)^(-1)
% => max likelihood estimator of lamda: lamda = (sample mean of x_i)^-1

%% (b)
clc;

[n, M, mu] = deal(100, 500, 10);
x = poissrnd(mu, n, M);
% y: the mean for each sample of n observations
y = mean(x, 1);

% From central limit theorem, the mean of the M variables
% following the poisson distibution should follow the normal distribution
% with mean equal to the mean of all means.
meanY = mean(y);

clf;
figure(1);
histogram(y);
% the mean of the exponential distribution is equal to 1/lamda
% theoretical mean is mu in the sense that the data are sampled from an
% exponential distribution
xline([meanY mu], '-', {'sample mean', 'theoretical mean'})
titleStr = 'Histogram of mean values of samples of the poisson distribution';
subtitleStr = ['M:', num2str(M), '  n:', num2str(n), '  mu:', num2str(mu)];
title(titleStr, subtitleStr);

% theoretical mean is the one used as the parameter of the exponential 
% distribution
fprintf(['Theoretical mean (equal to 1/lamda): ',...
    '\t%.5f\nSample mean (mean of y):\t %.5f\n'], mu, meanY);