% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 1

clc;
clear;
close all;

sampleSize = 100;
intRange = 2;
intOffset = 1;
% values from intOffset to intOffset + range
smallV = round(intRange *rand(sampleSize , 1)) + intOffset;
largeV = randn(sampleSize , 1);

% The discrete values of the vector should be more or less than 10
smallV = unique(smallV, 'stable');
largeVSet = unique(largeV, 'stable');

% Samplesize cases (> 10 or < 10)
v = smallV;
%v = largeVSet; 
data = table2array(readtable('Heathrow.xlsx'));
disp(data(5))
if length(v) <= 10
    probabilityOfSuccess = mean(v)/365;
    numberOfTrials = 365;
    [hBinomial, pBinomial] = chi2gof(v,'cdf',{@binocdf,numberOfTrials,probabilityOfSuccess});
    [hDiscreteUniform, pDiscreteUniform] = chi2gof(v,'cdf',{@unidcdf,max(v)});
    figure();
    bar(v);
    title({'Bar graph of values in sample';[ 'p-value for binomial dist.: ', ...
        num2str(pBinomial)];...
        ['p-value for discrete uniform dist.:', num2str(pDiscreteUniform)]});
     xlabel('Values');
    ylabel('Frequencies')
end
