% Stelios Topalidis
% AEM: 9613
% Exercise 5.2

clc;
clear;
close all;

% the larger the sample size the more accurate the prediction for the
% correlation coefficient
[M, n] = deal(1000, 20);
% [M, n] = deal(1000, 200);
[sigmaX, sigmaY, muX, muY] = deal(1, 1, 0, 0);
muV = [muX, muY];
% the actual rho between X and Y, and their true covariance
% rho can be however long vector we want
rho = [0, 0.5];
covXY = rho*sigmaX*sigmaY;

% sample r
originalSRho = nan(length(rho), 1);
originalSRhoStudentised = nan(length(rho), 1);

% samples of the randomly permuted variables
L = 1000;
% rho of randomly permutated variable X 
randomPermSRho = nan(L, 1);
% application of the student transform on the r_X,Y
randomPermSRhoStudentised = nan(L, 1);
alpha = 0.05;


%% Non parametric test to check if  
%% X and Y are correlated (if r_(X,Y) != 0 or == 0).

% for the different values of rho
for j = 1:length(rho)
    % covMat is different for different values of rho
    sigmaMat = [sigmaX^2, covXY(j);...
            covXY(j), sigmaY^2];
    % calculate the sample r from all M samples

    jointSample = mvnrnd(muV, sigmaMat, n);
    X = jointSample(:, 1);
    Y = jointSample(:, 2);
    % sample covariance matrix
    sCovMat = cov(X, Y);
    % extraction of sample stds and covariance from the covariance matrix
    sSigmaX = sqrt(sCovMat(1, 1));
    sSigmaY = sqrt(sCovMat(2, 2));
    sCovXY = sCovMat(1, 2);
    % sample correlation coefficient
    originalSRho(j) = sCovXY/(sSigmaX*sSigmaY);    
    originalSRhoStudentised(j) = ...
    originalSRho(j)*sqrt((L-2)/(1-originalSRho(j)^2));
    
    for i = 1:L
        % creation of L randomly permuted samples
        Xr = X(randperm(n));
        sCovMat = cov(Xr, Y);
        % extraction of sample stds and covariance from the covariance matrix
        sSigmaX = sqrt(sCovMat(1, 1));
        sSigmaY = sqrt(sCovMat(2, 2));
        sCovXY = sCovMat(1, 2);
        % sample correlation coefficient
        randomPermSRho(i) = sCovXY/(sSigmaX*sSigmaY); 
        % transform into student
        randomPermSRhoStudentised(i) ...
            = randomPermSRho(i)*sqrt((L-2)/(1-randomPermSRho(i)^2));
    end
    
    randomPermSRhoStudentised = sort(randomPermSRhoStudentised);
    
    sRhoLowInd = round(L*(alpha/2));
    sRhoHighInd = round(L*(1-alpha/2));
    sRhoLow = randomPermSRhoStudentised(sRhoLowInd);
    sRhoHigh = randomPermSRhoStudentised(sRhoHighInd);
    
    if j == 1
        fprintf('Check for the r_(X,Y)\n');
    end
    % rho is the correlation coefficient of the original distribution 
    fprintf('%d) For rho_(X,Y): %.2f\n', j, rho(j));
    
    %     CI from the L*(a/2), L*(1-a/2) percentiles (alpha = 0.05)
    fprintf('%.2f%% CI for the studentised statistic t\nis: [%.2f, %.2f]\n', 100*(1-alpha), sRhoLow, ...
            sRhoHigh);    
    if originalSRhoStudentised(j) > sRhoLow && ...
            originalSRhoStudentised(j) < sRhoHigh
        fprintf(['Original sample r_(X,Y) (studentised): %.2f is inside the %.2f%% ',...
            'ci\n\n'], originalSRhoStudentised(j), 100*(1-alpha));
    else
        fprintf(['Original sample r_(X,Y): %.2f is not inside the %.2f%% ',...
            'ci\n\n'], originalSRho(j), 100*(1-alpha));
    end
    if j == length(rho)
        fprintf('-----------------------\n');
    end
    
    figure(j);
    histogram([randomPermSRhoStudentised; originalSRhoStudentised(j)]);
    title(['L = ', num2str(L), ' samples of studentised $r_{X,Y}$ ',...
        'from randomly ',...
        'permuted initial variable X'], ['$\rho_{X,Y}$ = ', ...
        num2str(rho(j))], 'interpreter', 'latex');
    xline([sRhoLow, sRhoHigh], '-' ,{'L*(alpha/2)',  'L*(1-alpha/2)'}, ...
        'Color', 'r');
    xline(originalSRhoStudentised(j), '-', {'original sample r'});
    
end


% Notes:
% 1) The original sample r_X,Y is inside the 
% 95% ci (alpha = 0.05) of the L samples most of the times meaning the 
% hypothesis that they are uncorrelated is not rejected. 

% (Further note: This is to be expected since it was taken from a bivariate distribution 
% (X, Y) with rho = 0.
% This means that the X, Y in the original sample are truly uncorrelated.)

% 2) Similarly, the hypothesis that rho_X,Y=0.5 is rejected.

% (Further note: The random permutation of X (Xr) makes the samples (Xr, Y)
% uncorrelated. Therefore, since the original sample r_X,Y value falls 
% outside of the L*(a/2), L*(1-a/2) percentiles (for the most runs of the 
% program, which likelihood increases when n also increases 
% e.g: n:20 -> 200), the hypothesis that they
% are correlated with r_X,Y = 0.5 is rejected. )


%% Non parametric test to check if  
%% X^2 and Y^2 are correlated (if r_(X^2,Y^2) != 0 or == 0).

% for the different values of rho
for j = 1:length(rho)
    % covMat is different for different values of rho
    sigmaMat = [sigmaX^2, covXY(j);...
            covXY(j), sigmaY^2];
    % calculate the sample r from all M samples

    jointSample = mvnrnd(muV, sigmaMat, n);
    X = jointSample(:, 1).^2;
    Y = jointSample(:, 2).^2;
    % sample covariance matrix
    sCovMat = cov(X, Y);
    % extraction of sample stds and covariance from the covariance matrix
    sSigmaX = sqrt(sCovMat(1, 1));
    sSigmaY = sqrt(sCovMat(2, 2));
    sCovXY = sCovMat(1, 2);
    % sample correlation coefficient
    originalSRho(j) = sCovXY/(sSigmaX*sSigmaY);    
    originalSRhoStudentised(j) = ...
    originalSRho(j)*sqrt((L-2)/(1-originalSRho(j)^2));
    
    for i = 1:L
        % creation of L randomly permuted samples
        Xr = X(randperm(n));
        sCovMat = cov(Xr, Y);
        % extraction of sample stds and covariance from the covariance matrix
        sSigmaX = sqrt(sCovMat(1, 1));
        sSigmaY = sqrt(sCovMat(2, 2));
        sCovXY = sCovMat(1, 2);
        % sample correlation coefficient
        randomPermSRho(i) = sCovXY/(sSigmaX*sSigmaY); 
        % transform into student
        randomPermSRhoStudentised(i) ...
            = randomPermSRho(i)*sqrt((L-2)/(1-randomPermSRho(i)^2));
    end
    
    randomPermSRhoStudentised = sort(randomPermSRhoStudentised);
    
    sRhoLowInd = round(L*(alpha/2));
    sRhoHighInd = round(L*(1-alpha/2));
    sRhoLow = randomPermSRhoStudentised(sRhoLowInd);
    sRhoHigh = randomPermSRhoStudentised(sRhoHighInd);
    
    if j == 1
        fprintf('Check for the r_(X^2,Y^2)\n');
    end
    % rho is the correlation coefficient of the original distribution 
    fprintf('%d) For rho_(X,Y): %.2f\n', j, rho(j));
    
    %     CI from the L*(a/2), L*(1-a/2) percentiles (alpha = 0.05)
    fprintf(['%.2f%% CI for the studentised statistic t\nis: ',...
        '[%.2f, %.2f]\n'], 100*(1-alpha), sRhoLow, ...
            sRhoHigh);    
    if originalSRhoStudentised(j) > sRhoLow && ...
            originalSRhoStudentised(j) < sRhoHigh
        fprintf(['Original sample r_(X^2,Y^2) (studentised): ',...
            '%.2f is inside the %.2f%% ',...
            'ci\n\n'], originalSRhoStudentised(j), 100*(1-alpha));
    else
        fprintf(['Original sample r_(X^2,Y^2) (studentised): %.2f is ',...
            'not inside the %.2f%% ',...
            'ci\n\n'], originalSRho(j), 100*(1-alpha));
    end
    if j == length(rho)
        fprintf('-----------------------\n');
    end
    
    figure(length(rho) + j);
    histogram([randomPermSRhoStudentised; originalSRhoStudentised(j)]);
    title(['L = ', num2str(L), ' samples of studentised $r_{X,Y}$ ',...
        'from randomly ',...
        'permuted initial variable X'], ['$\rho_{X,Y}$ = ', ...
        num2str(rho(j))], 'interpreter', 'latex');
    xline([sRhoLow, sRhoHigh], '-' ,{'L*(alpha/2)',  'L*(1-alpha/2)'}, ...
        'Color', 'r');
    xline(originalSRhoStudentised(j), '-', {'original sample r'});
    
end

% Notes: most of the times, what holds for X,Y also holds for X^2 and Y^2. 
% For rho_X,Y = 0, the hypothesis that r_X^2,Y^2 = 0 is not rejected 
% (value inside the percentiles).
% For rho_X,Y = 0.5, the hypothesis that r_X^2,Y^2 = 0.5 is
% rejected (value outside the percentiles).

% Also, if the hypothesis that X,Y have rho_(X,Y) = 0.5 is rejected, this
% might not be the case with rho_(X^2,Y^2) and vice versa.
