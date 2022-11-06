% Stelios Topalidis
% AEM: 9613
% Exercise 2.2

clc;
clear;

rng(1);

lamda = 1;
n = 1000;
x = rand(n, 1);
y = -(1/lamda).*log(1-x);

histogram(y, 'Normalization', 'pdf');

hold on

z = 0:0.1:10;
f_z =  lamda.*exp(-lamda.*z);
plot(z, f_z, 'LineWidth', 1.5)

hold off