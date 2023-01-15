% Stelios Topalidis
% AEM: 9613
% Exercise 2.3

clc;
clear;

n = 10000;
mu = [0; 0];
% for values of the covariance different 
% from 0 meaning X and Y are , Var[X + Y] != Var[X] + Var[Y]
step = 0.1;
range = 0:step:1;
sumOfVar = zeros(length(range), 1);
varOfSum = zeros(length(range), 1);
indexCounter = 1;

for covValues = range
    sigma = [1 covValues; covValues 1];
    R = mvnrnd(mu, sigma, n);
    x = R(:,1);
    y = R(:,2);
    z = x + y;  
    sumOfVar(indexCounter) = var(x) + var(y);
    varOfSum(indexCounter) = var(x+y);
    indexCounter = indexCounter +1;
end

figure(1)
plot(transpose(range), sumOfVar)
hold on

plot(transpose(range), varOfSum)
hold off
xlabel('Covariance')
title('Variance of X+Y and variance of X plus variance of Y')
legend('Var[X] + Var[Y]', 'Var[X+Y]');
