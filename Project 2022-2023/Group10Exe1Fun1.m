% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 1

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));

sampleSize = 100;
% the number of unique values should be the quite high for the p-value to
% be computed.
intRange = 9;
intOffset = 1;
% values from intOffset to intOffset + range
smallV = round(intRange *rand(sampleSize , 1)) + intOffset;
largeV = randn(sampleSize , 1);

% Vector samplesize cases (> 10 or < 10)
v = smallV;
%v = largeVSet; 
% v = rmmissing(data(:, 12));


% The discrete values of the vector 
vSet = unique(v, 'sorted');


if length(vSet) <= 10
    probabilityOfSuccess = mean(v)/365;
    numberOfTrials = 365;
    [hBinomial, pBinomial] = chi2gof(v,'CDF',...
        {@binocdf, numberOfTrials, probabilityOfSuccess});
    [hDiscreteUniform, pDiscreteUniform] = chi2gof(v,'cdf',...
        {@unidcdf,max(v)});
    figure();
    X = categorical(v, vSet, cellstr(num2str(vSet)));
    
    histogram(X, 'BarWidth', 0.5);
    title({'Bar graph of values in sample';...
        [ 'p-value for binomial dist.: ', ...
        num2str(pBinomial)];...
        ['p-value for discrete uniform dist.:',...
        num2str(pDiscreteUniform)]});
     xlabel('Values');
    ylabel('Frequencies')
end
