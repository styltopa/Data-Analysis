% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 4

clc;
clear;
close all;

data = table2array(readtable('Heathrow.xlsx'));
years = data(:, 1);
% the fifth column, can be replaced with y
PP = data(:, 5);

%% (a)
% Merging the two columns 
yearsAndPP = [years, PP];

% taking out the Nan rows
yearsAndPPNotNan = rmmissing(yearsAndPP); 


%% (b)

% Correlation coefficient of the original sample
corrXY = corr(yearsAndPPNotNan(:, 1), yearsAndPPNotNan(:, 2));

% Parametric ci with Fisher
corrCoefFisher = ...
    0.5.*log((1 + corrXY)./(1 - corrXY));

% the probabilities to calculate the inverse normal values on
alpha = 0.05;
probArr = [alpha/2, 1-alpha/2];
mu = corrCoefFisher;
sigma = sqrt(1/(length(yearsAndPPNotNan(:, 1)) - 3)); 
ciParam = norminv(probArr, mu, sigma);

% Bootstrap ci
B = 1000;
[bootSamCorrCoefCI, bootSamCorrCoefStat] = bootci(B, {@corr, ...
    yearsAndPPNotNan(:, 1), ...
    yearsAndPPNotNan(:, 2)}, 'Alpha', alpha);


%% (c)

% P-value calculation
% (c.1) 
% Parametric method

% length of the vectors without the Nan values
n = length(yearsAndPPNotNan(:, 1));
% formula for the statistic calculated from correlation coefficient r
tStatCorrCoef = corrXY*sqrt((n-2)/(1-corrXY^2));
dof = length(yearsAndPPNotNan(:, 1)) - 2;

% p-value of the test
pValTtest = min(tcdf(tStatCorrCoef, dof), 1-tcdf(tStatCorrCoef, dof));


% (c.2) 
% Randomisation method
corrPerm = nan(B, 1);


% for each randomised sample
for i = 1:B
    % includes the i-th randomised nx2 sample
    yearsAndPPNotNanPerm = nan(n, 2);
    
    % permuted indices of the randomised samples
    permInds = randperm(n);
    
    % we randomise only one column of the two (the first in this case)
    % the second one remains as is
    yearsAndPPNotNanPerm = yearsAndPPNotNan(permInds, 1);
    % i-th correlation coefficient
    corrPerm(i) = corr(yearsAndPPNotNanPerm, ...
        yearsAndPPNotNan(:, 2));
end

sortedRandomisedCorr = sort([corrPerm; corrXY]);
rankCorrXY = find(sortedRandomisedCorr == corrXY);
 
median
pValRandomisation = 2*min(rankCorrXY,  B-rankCorrXY)/B;



%% (d)
