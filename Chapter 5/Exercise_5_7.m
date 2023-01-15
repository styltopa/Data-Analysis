% Stelios Topalidis
% AEM: 9613
% Exercise 5.7

clc;
clear;
close all;

% import data (given in the notes)
dataArr = [0.76, 110;
0.86, 105;
0.97, 100;
1.11, 95;
1.45, 85;
1.67, 80;
1.92, 75;
2.23, 70;
2.59, 65;
3.02, 60;
3.54, 55;
4.16, 50;
4.91, 45;
5.83, 40;
6.94 ,35;
8.31 ,30;
10.00, 25;
12.09, 20;
14.68, 15;
17.96, 10;
22.05, 5;
27.28, 0;
33.89, -5;
42.45, -10;
53.39, -15;
67.74, -20;
86.39, -25;
111.30, -30;
144.00, -35;
188.40, -40;
247.50, -45;
329.20, -50];

r = dataArr(:, 1);
celsiusTemp = dataArr(:, 2);
kelvinTemp = celsiusTemp + 273.15;

logR = log(r);
tempInv = 1./kelvinTemp;

%% (a) Find the best polynomial model based on disgnostic diagram of 
%% the normalised residuals
figure(1);
polyDegree = 1;
dotSize = 25;
scatter(logR, tempInv, dotSize, 'filled');
title({'Scatter diagram of ln(R) and 1/T'; ['Polynomial degree:', ...
    num2str(polyDegree)]});

coeff = polyfit(logR, tempInv, polyDegree);

hold on;
model = coeff(1).*(logR) + coeff(2);
plot(logR, model);
hold off;
n = length(logR);
if polyDegree >= 2    
    k = polyDegree - 1;
elseif polyDegree == 1
    k = 0;
end
    
adjR2 = 1-(n-1)/(n-(k+1))*...
    sum((tempInv-model).^2)/sum((tempInv-mean(model)).^2);
fprintf('For fitting polynomial of degree: %d, adjR^2 = %f\n', ...
    polyDegree, adjR2);


figure(2);
polyDegree = 2;
scatter(logR, tempInv, dotSize, 'filled');
title({'Scatter diagram of ln(R) and 1/T'; ['Polynomial degree:', ...
    num2str(polyDegree)]});
coeff = polyfit(logR, tempInv, polyDegree);
scatter(logR, tempInv, dotSize, 'filled');
hold on;
model = coeff(1).*(logR).^2+coeff(2).*logR+coeff(3);
plot(logR, model);
hold off;
adjR2 = 1-(n-1)/(n-(k+1))*...
    sum((tempInv-model).^2)/sum((tempInv-mean(model)).^2);
fprintf('For fitting polynomial of degree: %d, adjR^2 = %f\n', ...
    polyDegree, adjR2);

figure(3)
polyDegree = 3;
scatter(logR, tempInv, dotSize, 'filled');
title({'Scatter diagram of ln(R) and 1/T'; ['Polynomial degree:', ...
    num2str(polyDegree)]});
coeff = polyfit(logR, tempInv, polyDegree);
hold on;
model = coeff(1).*(logR).^3+coeff(2).*(logR.^2)+coeff(3).*logR+coeff(4);
plot(logR, model);
hold off;
adjR2 = 1-(n-1)/(n-(k+1))*...
    sum((tempInv-model).^2)/sum((tempInv-mean(model)).^2);
fprintf('For fitting polynomial of degree: %d, adjR^2 = %f\n', ...
    polyDegree, adjR2);

%% (b) Compare (with adjR^2 ?) the fitting of the model with the 
%% Steinhart-Hart model (see notes for formula)

