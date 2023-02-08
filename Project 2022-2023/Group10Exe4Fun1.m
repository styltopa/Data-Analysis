% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function for exercise 4

function [outCIParam, outCIBoot, outPVal, outLength] = Group10Exe4Fun1(x, y)
    %% (a) Find the Nan pair values and remove them
    % Merging the two columns 
    xAndY = [x, y];

    % taking out the Nan rows
    xAndYNotNan = rmmissing(xAndY); 

    %% (b) 95% ci with parametric (Fisher) and bootstrap

    % Correlation coefficient of the original sample
    corrXY = corr(xAndYNotNan(:, 1), xAndYNotNan(:, 2));

    % Parametric ci with Fisher
    % Fisher transform
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
    bootSamCorrCoefCI = bootci(B, {@corr, ...
        xAndYNotNan(:, 1), ...
        xAndYNotNan(:, 2)}, 'Alpha', alpha);


    %% (c) Parametric test (student) and randomisation test

    % P-value calculation
    % (c.1) 
    % Parametric method

    % length of the vectors without the Nan values
    n = length(xAndYNotNan(:, 1));
    % formula for the student statistic calculated from the 
    % correlation coefficient r
    tStatCorrCoef = corrXY*sqrt((n-2)/(1-corrXY^2));
    dof = n - 2;

    % p-value of the test
    pValTTest = min(tcdf(tStatCorrCoef, dof), 1-tcdf(tStatCorrCoef, dof));


    % (c.2) 
    % Randomisation method
    corrPerm = nan(B, 1);


    % for each randomised sample
    for i = 1:B
        % permuted indices of the randomised samples
        permInds = randperm(n);

        % we randomise only one column of the two (the first in this case)
        % the second one remains as is
        % includes the i-th randomised nx2 sample
        xAndYNotNanPerm = xAndYNotNan(permInds, 1);
        % i-th correlation coefficient
        corrPerm(i) = corr(xAndYNotNanPerm, ...
            xAndYNotNan(:, 2));
    end

    sortedRandomisedCorr = sort([corrPerm; corrXY]);
    % get the mean index of all 
    rankCorrXY = find(sortedRandomisedCorr == corrXY, 1);
    if size(rankCorrXY) ~= 1
        % if many indices with the same value exist, 
        % then we get the mean of those indices and round it to 
        % get the actual rank of the matrix.
        rankCorrXY = round(mean(rankCorrXY));
    end
    
    if corrXY <= median(sortedRandomisedCorr) 
        pValRandomisation = 2*rankCorrXY/(B+1);
    elseif corrXY > median(sortedRandomisedCorr) 
        pValRandomisation = 2*(1 - rankCorrXY/(B+1));
    end

    %% (d)
    % bootstrap ci is in a column instead of a row vector
    outCIParam = ciParam; 
    outCIBoot = transpose(bootSamCorrCoefCI);
    
    outPVal = [pValTTest, pValRandomisation];
    outLength = n;
end