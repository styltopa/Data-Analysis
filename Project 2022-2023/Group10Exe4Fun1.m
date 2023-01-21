% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 4

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
x = data(:, 4);
% the fifth column, can be replaced with y
y = data(:, 3);
figure();
scatter(x, y);

%% (a)
% Merging the two columns 
xAndY = [x, y];

% taking out the Nan rows
xAndYNotNan = rmmissing(xAndY); 


%% (b)

% Correlation coefficient of the original sample
corrXY = corr(xAndYNotNan(:, 1), xAndYNotNan(:, 2));

% Parametric ci with Fisher
corrCoefFisher = ...
    0.5.*log((1 + corrXY)./(1 - corrXY));

% the probabilities to calculate the inverse normal values on
alpha = 0.05;
probArr = [alpha/2, 1-alpha/2];
mu = corrCoefFisher;
sigma = sqrt(1/(length(xAndYNotNan(:, 1)) - 3)); 
ciParam = norminv(probArr, mu, sigma);

% Bootstrap ci
B = 1000;
[bootSamCorrCoefCI, bootSamCorrCoefStat] = bootci(B, {@corr, ...
    xAndYNotNan(:, 1), ...
    xAndYNotNan(:, 2)}, 'Alpha', alpha);


%% (c)

% P-value calculation
% (c.1) 
% Parametric method

% length of the vectors without the Nan values
n = length(xAndYNotNan(:, 1));
% formula for the statistic calculated from correlation coefficient r
tStatCorrCoef = corrXY*sqrt((n-2)/(1-corrXY^2));
dof = n - 2;

% p-value of the test
pValTTest = min(tcdf(tStatCorrCoef, dof), 1-tcdf(tStatCorrCoef, dof));


% (c.2) 
% Randomisation method
corrPerm = nan(B, 1);


% for each randomised sample
for i = 1:B
    % includes the i-th randomised nx2 sample
    xAndYNotNanPerm = nan(n, 2);
    
    % permuted indices of the randomised samples
    permInds = randperm(n);
    
    % we randomise only one column of the two (the first in this case)
    % the second one remains as is
    xAndYNotNanPerm = xAndYNotNan(permInds, 1);
    % i-th correlation coefficient
    corrPerm(i) = corr(xAndYNotNanPerm, ...
        xAndYNotNan(:, 2));
end

sortedRandomisedCorr = sort([corrPerm; corrXY]);
rankCorrXY = find(sortedRandomisedCorr == corrXY);
 
if corrXY <= median(sortedRandomisedCorr) 
    pValRandomisation = 2*rankCorrXY/(B+1);
elseif corrXY > median(sortedRandomisedCorr) 
    pValRandomisation = 2*(1 - rankCorrXY/(B+1));
end

figure();
histogram(sortedRandomisedCorr);
xline([corrXY, median(sortedRandomisedCorr)], '-', ...
    {'original sample r', 'median r'});

%% (d)
% bootstrap ci is in a column instead of a row vector
outCI = [ciParam; transpose(bootSamCorrCoefCI)];
outPVal = [pValTTest, pValRandomisation];
outLength = n;
