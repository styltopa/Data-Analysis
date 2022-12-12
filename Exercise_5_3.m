% Stelios Topalidis
% AEM: 9613
% Exercise 5.3

clear;
clc;
close all;

% Data import
rainData = readtable('rainThes59_97.dat');
tempData = readtable('tempThes59_97.dat');

% Table data -> array data
rainData = table2array(rainData);
tempData = table2array(tempData);

% Rows: years, cols: months
numOfCols = length(rainData(1, :)); 
numOfRows = length(rainData(:, 1));
corrCoefPerMonthOriginal = NaN(numOfCols, 1);

% Calculation of monthly sample correlation coefficients (r) from the
% original sample
for monthKey = 1:numOfCols
    corrCoefPerMonthMat = corrcoef(rainData(:, monthKey), tempData(:, monthKey));
    corrCoefPerMonthOriginal(monthKey) = corrCoefPerMonthMat(1, 2);
% % Uncomment this section to plot the scatter diagrams of the original
% % sample rain - temperature data
%     figure();
%     scatter(rainData(:, month), tempData(:, month));
%     xlabel('Rain');
%     ylabel('Temperature');
%     hold off
end

% Significance level for the tests
alpha = 0.05;
% Mapping numbers to months
keySet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]; 
valueSet = {'January', 'February', 'March', 'April', 'May', 'June', ...
    'July', 'August', 'September', 'October', 'November', 'December'};
num2MonthMap = containers.Map(keySet,valueSet);


%% Parametric test
% Transformation of sample correlation coefficients (r) into statistic t
% following the student distribution
% the degrees of freedom of the studentised statistic is equal to 
% the number of observations on which the correlation coefficient
% is calculated.
dof = numOfRows-2;

corrCoefPerMonthTransformed = ...
    corrCoefPerMonthOriginal.*sqrt((numOfRows-2)./(1-corrCoefPerMonthOriginal.^2));
% disp('corrCoefPerMonthTransformed:');
% disp(corrCoefPerMonthTransformed);
% disp('length(corrCoefPerMonthTransformed):')
% disp(length(corrCoefPerMonthTransformed));

tBoundOnXAxis = 5; 
tStep = 0.1;
    
% for each month
for monthKey = 1:length(corrCoefPerMonthTransformed)
    % Console output for the parametric test per month
    if monthKey == 1
        fprintf('Parametric test\n')
        fprintf(['Month\tParametric ci\tOriginal sample r\tHypothesis '...
            'test\n'])
    end
%     if monthKey == 2
%         error('Check if the first title is correct'); 
%     end
    % If the statistic is inside  the parametric ci, the paramertic 
    % hypothesis test is rejected if the real value of the statistic lies
    % outside
    corrCoefLow = tinv(alpha/2, dof);
    corrCoefHigh = tinv(1-alpha/2, dof);
    if corrCoefPerMonthTransformed(monthKey) < corrCoefLow ...
        || corrCoefPerMonthTransformed(monthKey) > corrCoefHigh
        rejectionTestStr = 'rejected';
    else
        rejectionTestStr = 'not rejected';
    end

    fprintf('%s:\t[%.3f, %.3f]\t%.3f\t%s\n', num2MonthMap(monthKey),...
        corrCoefLow, corrCoefHigh, corrCoefPerMonthTransformed(monthKey),...
        rejectionTestStr);
    fprintf('p-value: %.4f\n', ...
        2*min([tcdf(corrCoefPerMonthTransformed(monthKey), dof),...
        1- tcdf(corrCoefPerMonthTransformed(monthKey), dof)]))
    if monthKey == length(corrCoefPerMonthTransformed)        
        fprintf('\n\n');
    end
    
    
    % Student distribution plot for the monthly r
    figure();
    % the values of x to calculate the t statistic on (values of the 
    % student distribution)
    tStatisticRange = -tBoundOnXAxis:tStep:tBoundOnXAxis;
    tPdfValues = tpdf(tStatisticRange, dof);
    plot(tStatisticRange, tPdfValues);
    title({['T-statistic derived from the transformation of ',...
        'r_{rain, temperature} for ', num2MonthMap(monthKey)]; ...
        ['The ', ...
        num2str(100*(1-alpha)) ,...
        '% ci is noted by the two vertical lines']});
    xline([corrCoefLow, corrCoefHigh], '-', ...
        {'$\frac{a}{2}\%$','(1-$\frac{a}{2})\%$'} , 'Color', 'r', ...
        'interpreter', 'latex', 'LabelOrientation', 'Horizontal');
    xline(corrCoefPerMonthTransformed(monthKey), '-', ...
        {'Original sample r'}, 'Color', 'k');
    
end


%% Random permutation test
% to check if r_(rain, temperature) = 0 (=> (rain, temp) = uncorrelated)
% number of random permutated samples

% Number of randomised samples
L = 1000;


% Dims: (L samples) x (Number of months)
% (i, j) contains the correlation coefficient of the i-th randomised sample 
% of the j-th month
corrCoefPerMonth = NaN(L, numOfCols);

% Random permutation test for each month
for monthKey = 1:numOfCols
    % Calculate r for all L new randomised bivariate samples (rain, temp)
    % for a single month
    for sample = 1:L
        rainDataRandPerm = rainData(randperm(numOfRows), monthKey);
        % the corrCoef is calculated for the permutated rain samples and 
        % the original temperatures (see Ex.5.2)
        corrCoefPerMonthMat = corrcoef(rainDataRandPerm, ...
            tempData(:, monthKey));
        corrCoefPerMonth(sample, monthKey) = corrCoefPerMonthMat(1, 2);
    end
    
    % Sort the correlation coefficients calculated for the month
    corrCoefPerMonthSorted = sort(corrCoefPerMonth(:, monthKey));
    
    % Calculate the (a/2)% and (1-a/2)% percentiles 
    corrCoefLow = corrCoefPerMonthSorted(round(L*alpha/2));
    corrCoefHigh = corrCoefPerMonthSorted(round(L*(1-alpha/2)));

    % Histogram of the correlation coefficient per month for L = 1000
    % randomised samples
    figure();
    histogram(corrCoefPerMonth(:, monthKey));
    title(['Sample r_{rain, temperature} for L = ', num2str(L), ...
        ' random samples for ', num2MonthMap(monthKey)], ['The ', ...
        num2str(100*(1-alpha)) ,...
        '% ci is noted by the two vertical lines']);
    xline([corrCoefLow, corrCoefHigh], '-', ...
        {'$\frac{a}{2}\%$','(1-$\frac{a}{2})\%$'} , 'Color', 'r', ...
        'interpreter', 'latex', 'LabelOrientation', 'Horizontal');
    xline(corrCoefPerMonthOriginal(monthKey), '-', ...
        {'Original sample r'}, 'Color', 'k');
    
    % Console output for the random permutation test per month
    if monthKey == 1
        fprintf('Random permutation test\n')
        fprintf('Month\tSample ci\tOriginal sample r\tHypothesis test\n')
    end
    if corrCoefPerMonthOriginal(monthKey) < corrCoefLow ...
        || corrCoefPerMonthOriginal(monthKey) > corrCoefHigh
        rejectionTestStr = 'rejected';
    else
        rejectionTestStr = 'not rejected';
    end
    
    fprintf('%s:\t[%.3f, %.3f]\t%.3f\t%s\n', num2MonthMap(monthKey),...
        corrCoefLow, corrCoefHigh, corrCoefPerMonthOriginal(monthKey),...
        rejectionTestStr);
end


% Note: Each sample is comprised of n = numOfCols (39) observations 
% (rain, temp) coming from the original sample with the rain values 
% being permutated (rainDataRandPerm) whereas the temperature data 
% remain as are to eliminate the correlation (make the data 
% according to the null hypothesis.

% Notes: for alpha = 0.1, the 