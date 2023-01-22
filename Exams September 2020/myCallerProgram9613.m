clc;
clear;
close all;

mu = [10, 15];
sigma = [4, 0; 0, 2];
n = 100;
xAndY = mvnrnd(mu, sigma, n);
X = xAndY(:, 1);
Y = xAndY(:, 2);

[pA, pB, pC, pD] = logtranstest9613(X, Y);