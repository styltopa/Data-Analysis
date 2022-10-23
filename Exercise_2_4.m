% Stylianos Topalidis
% AEM: 9613

clear;
clc;

[xmin, xmax] = deal(1, 2); %Case 1
% [xmin, xmax] = deal(0, 1); %Case 2
% [xmin, xmax] = deal(-1, 1); %Case 3
[nmin, nmax, nstep]  = deal(10, 100000, 1000);
nrange = nmin:nstep:nmax;

[oneOverMeanOfX , meanOfOneOverX] = deal(zeros(length(nrange), 1)); 
nCounter = 1;
 
X = xmin + (xmax-xmin)*rand(nmax, 1);

for n = nrange
    oneOverMeanOfX(nCounter) = 1/mean(X(1:n));
    meanOfOneOverX(nCounter) = mean(1/X(1:n));
    nCounter = nCounter + 1;
end

figure(1)
horAxis = transpose(nrange);
plot(horAxis, meanOfOneOverX, 'LineWidth', 2)
hold on
plot(horAxis, oneOverMeanOfX, 'LineWidth', 2)
hold off
legend('E[1/X]', '1/E[X]');
titleStr = sprintf(['1/E[X] and E[1/X] for various ', ...
    'numbers of observations(n)']);
subtitleStr = sprintf('X ~ U(%d, %d)', xmin, xmax);
title(titleStr, subtitleStr);
xlabel('Number of observations n')
ylabel('E[1/X], 1/E[X]');

lengthOfMeanMatrices = length(nrange);
fprintf('For n = %d:\n1/E[X] = %.4f\nE[1/X] = %d\n', nmax, ...
    oneOverMeanOfX(lengthOfMeanMatrices), meanOfOneOverX(lengthOfMeanMatrices));