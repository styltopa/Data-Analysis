% Stelios Topalidis
% AEM: 9613
% Exercise 3.1


%% (a) Proof that the maximum likelihood estimator of lamda of the 
% poisson distribution is equal to the sample mean 
%
% x = [x_1, x_2, ..., x_n]
% L(x; lamda) = f_X(x_1)*f_X(x_2)*...*f_X(x_n)
% L(x; lamda) = exp(-lamda)*lamda^x_1/x_1! * exp(-lamda)*lamda^x_2/x_2! *...
%               exp(-lamda)*lamda^x_n/x_n! 
% L(x; lamda) = exp(-n*lamda) * lamda^(sum of x_i from i=1 to i=n) /...
%               product of x_i! from i=1 to i=n
% 
% dL/d(lamda) = 0 => 
%
% {[-n*exp(-n*lamda)*lamda^(sum of x_i from i=1 to i=n) + 
% + exp(-n*lamda)*lamda^((sum of x_i from i=1 to i=n) - 1)]
% / (product of of x_i! from i=1 to i=n)} = 0
% 
% numerator/denominator = 0 => numerator = 0
% 
% exp(-n*lamda)*lamda^(sum of x_i from i = 1 to i = n) *
% [-n + (sum of x_i from i =1 to i=n)*lamda^(-1)] = 0
% 
% => [-n + (sum of x_i from i =1 to i=n)*lamda^(-1)] = 0
% => lamda^(-1) = n/(sum  of x_i from i =1 to i=n)
% => lamda = (sum  of x_i from i =1 to i=n)/n
% => max likelihood estimator of lamda: lamda = sample mean of x_i

%% (b)
clc;

[n, M, lamda] = deal(100, 500, 10);
x = poissrnd(lamda, n, M);
% y: the mean for each sample of n observations
y = mean(x, 1);

% From central limit theorem, the mean of the M variables
% following the poisson distibution should follow the normal distribution
% with mean equal to the mean of all means.
meanY = mean(y);

clf;
figure(1);
histogram(y);
% lamda is equal to the thoretical mean that the sample must have
xline([meanY lamda], '-', {'sample mean', 'theoretical mean (\lambda)'})
titleStr = 'Histogram of mean values of samples of the poisson distribution';
subtitleStr = ['M:', num2str(M), '  n:', num2str(n), '  \lambda:', num2str(lamda)];
title(titleStr, subtitleStr);

fprintf(['Theoretical mean (equals lamda): \t%.5f\n',...
    'Sample mean (mean of y):\t %.5f\n'], lamda, meanY);