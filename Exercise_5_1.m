% Stelios Topalidis
% AEM: 9613
% Exercise 5.1

clc;
clear;
close all;

% some value for reproducibility (so that consistent results are given for 
% different values of n (part c))
rng(454);
%% For (c) comment/uncomment one of the option below to select the number of
%% observations in each sample.
[M, n] = deal(1000, 20);
% [M, n] = deal(1000, 200);
[sigmaX, sigmaY, muX, muY] = deal(1, 1, 0, 0);
muV = [muX, muY];
% the actual rho between X and Y, and their true covariance
% rho can be however long vector we want
rho = [0, 0.5];
covXY = rho*sigmaX*sigmaY;


%% (a) (1-alpha)% Theoretical and sample confidence interval 
%% for the correlation coefficient rho
% sample rho
sRho = nan(M, length(rho));

alpha = 0.05;
% formula for the ci of rho transformed through fisher
critVal =  norminv(1-alpha/2);

% for the different values of rho
for j = 1:length(rho)
    % covMat is different for different values of rho
    sigmaMat = [sigmaX^2, covXY(j);...
            covXY(j), sigmaY^2];
    % calculate the sample rho from all M samples
    for i = 1:M
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
        sRho(i, j) = sCovXY/(sSigmaX*sSigmaY);    
    end

    % sRhoFisher follows a normal distribution and therefore tests for its mean
    % can be performed.
    sRhoFisher = atanh(sRho(:, j));
    sRhoFisherLow = sRhoFisher - critVal*sqrt(1/(n-3));
    sRhoFisherHigh = sRhoFisher + critVal*sqrt(1/(n-3));
    % invert fisher transform back to the original values of the 
    % correlation coefficient
    sRhoLow = (exp(2*sRhoFisherLow)-1)./(exp(2*sRhoFisherLow)+1);
    sRhoHigh = (exp(2*sRhoFisherHigh)-1)./(exp(2*sRhoFisherHigh)+1);

    rhoInsideTheCICounter = 0;
    for i = 1:M
        if rho(j) > sRhoLow(i) && rho(j) < sRhoHigh(i)
            rhoInsideTheCICounter = rhoInsideTheCICounter + 1;
        end
    end

    rhoInsideTheCIPercent = rhoInsideTheCICounter/M;

    if j == 1
        fprintf('(a)\n');
    end
    fprintf(['For rho = %.2f:\nPercentage of rho being inside the ',...
        'ci:\n'], rho(j));
    % theoretical meaning taken from the parametric confidence intervals
    % see variable critVal 
    fprintf('Theoretical: %.2f%%\n', 100*(1-alpha));
    fprintf('Sample: %.2f%%  (M = %d samples)\n\n', ...
        100*rhoInsideTheCIPercent, M);

    figure(j);
    histogram(sRhoLow);
    xline(mean(sRhoLow), '-', {'$\bar{r}_{low}$'}, 'FontSize', 12,...
        'LineWidth', 2,...
         'color', 'r',...
        'LabelOrientation', 'horizontal', 'interpreter', 'latex');

    hold on
    histogram(sRhoHigh);
    xline(mean(sRhoHigh), '-', {'$$\bar{r}_{high}$'}, 'FontSize', 12,...
        'LineWidth', 2,...
         'color', 'r',...
        'LabelOrientation', 'horizontal', 'interpreter', 'latex');

    legend('Low bound', '', 'High bound', '');
    % r is the sample correlation coefficient
    title(['M = ', num2str(M), ' samples of ', num2str(100*(1-alpha)),...
        ' ci bounds of $r_{X,Y}$'],...
        ['X,Y are sampled from a distribution with $\rho_{X,Y}$= ', ...
        num2str(rho(j))], 'Interpreter', 'latex');
end


%% (b) Hypothesis testing of correlation coefficient of X, Y equal to zero
%% null hypothesis is expected to be rejected (alpha)% of the times

% for the different values of rho that we want to check
for j = 1:length(rho)
    
    % transform the sample rho to follow the student distribution
    sRhoStudentTransformed = sRho(:, j).*sqrt((M-2)./(1-sRho(:, j).^2));
%     [h, p] = ttest(sRhoStudentTransformed, rho(j));
    
    [h, p] = ttest(sRhoStudentTransformed, ...
        rho(j)*sqrt((M-2)./(1-rho(j)^2)));
    if j == 1
        fprintf('(b)\n');
    end
    fprintf('For rho = %.2f:\n', rho(j));
    figure(length(rho) + j);
    histogram(sRhoStudentTransformed);
    fprintf(['The null hypothesis that rho = %.2f can be rejected \n',...
    '(p-value) %.4f%% of the times.\n\n'], rho(j),...
    100*p);
end

% Notes: 
% 1) the p-value (percentage of rejection of the null hypothesis) changes 
% in every iteration 
% of the experiment and is not consistent as far as the relative rejection
% rate goes (the rejection rate for rho=0 might be higher than for rho=0.5 
% one time and the smaller the next one).
% 2) Even when rng(0) for reproducibility is introduced, there is still not
% the convergence to alpha expected. (different seeds give different
% results for n=20 and n=200


%% (d) 

%% (a) (1-alpha)% Theoretical and sample confidence interval 
%% for the correlation coefficient rho
% sample rho
sRho = nan(M, length(rho));

alpha = 0.05;
% formula for the ci of rho transformed through fisher
critVal =  norminv(1-alpha/2);

% for the different values of rho
for j = 1:length(rho)
    % covMat is different for different values of rho
    sigmaMat = [sigmaX^2, covXY(j);...
            covXY(j), sigmaY^2];
    % calculate the sample rho from all M samples
    for i = 1:M
        jointSample = mvnrnd(muV, sigmaMat, n);
        X2 = jointSample(:, 1).^2;
        Y2 = jointSample(:, 2).^2;
        % sample covariance matrix
        sCovMat2 = cov(X2, Y2);
        % extraction of sample stds and covariance from the covariance matrix
        sSigmaX2 = sqrt(sCovMat(1, 1));
        sSigmaY2 = sqrt(sCovMat(2, 2));
        sCovXY2 = sCovMat2(1, 2);
        % sample correlation coefficient
        sRho(i, j) = sCovXY/(sSigmaX2*sSigmaY2);    
    end

    % sRhoFisher follows a normal distribution and therefore tests for its mean
    % can be performed.
    sRhoFisher = atanh(sRho(:, j));
    sRhoFisherLow = sRhoFisher - critVal*sqrt(1/(n-3));
    sRhoFisherHigh = sRhoFisher + critVal*sqrt(1/(n-3));
    % invert fisher transform back to the original values of the 
    % correlation coefficient
    sRhoLow = (exp(2*sRhoFisherLow)-1)./(exp(2*sRhoFisherLow)+1);
    sRhoHigh = (exp(2*sRhoFisherHigh)-1)./(exp(2*sRhoFisherHigh)+1);

    rhoInsideTheCICounter = 0;
    for i = 1:M
        if rho(j) > sRhoLow(i) && rho(j) < sRhoHigh(i)
            rhoInsideTheCICounter = rhoInsideTheCICounter + 1;
        end
    end

    rhoInsideTheCIPercent = rhoInsideTheCICounter/M;

    if j == 1
        fprintf('(d.a)\nFor X^2 and Y^2\n');
    end
    fprintf(['For X, Y having rho = %.2f:\nPercentage of rho being inside the ',...
        'ci:\n'], rho(j));
    % theoretical meaning taken from the parametric confidence intervals
    % see variable critVal 
    fprintf('Theoretical: %.2f%%\n', 100*(1-alpha));
    fprintf('Sample: %.2f%%  (M = %d samples)\n\n', ...
        100*rhoInsideTheCIPercent, M);

    figure(4+j);
    histogram(sRhoLow);
    xline(mean(sRhoLow), '-', {'$$\bar{r}_{low}$'}, 'FontSize', 12,...
        'LineWidth', 2,...
         'color', 'r',...
        'LabelOrientation', 'horizontal', 'interpreter', 'latex');

    hold on
    histogram(sRhoHigh);
    xline(mean(sRhoHigh), '-', {'$$\bar{r}_{high}$'}, 'FontSize', 12,...
        'LineWidth', 2,...
         'color', 'r',...
        'LabelOrientation', 'horizontal', 'interpreter', 'latex');

    legend('Low bound', '', 'High bound', '');
    % r is the sample correlation coefficient
    title(['M = ', num2str(M), ' samples of ', num2str(100*(1-alpha)),...
        ' ci bounds of $r_{X^2,Y^2}$'],...
        ['X,Y are sampled from a distribution with $\rho_{X,Y}$= ', ...
        num2str(rho(j))], 'Interpreter', 'latex');
end


%% (b) Hypothesis testing of correlation coefficient of X, Y equal to zero
%% null hypothesis is expected to be rejected (alpha)% of the times

% for the different values of rho that we want to check
for j = 1:length(rho)
    
    % transform the sample rho to follow the student distribution
    sRhoStudentTransformed = sRho(:, j).*sqrt((M-2)./(1-sRho(:, j).^2));
%     [h, p] = ttest(sRhoStudentTransformed, rho(j));
    
    [h, p] = ttest(sRhoStudentTransformed, ...
        rho(j)*sqrt((M-2)./(1-rho(j)^2)));
    if j == 1
        fprintf('(d.b)\n');
    end
    fprintf('For X, Y having rho = %.2f:\n', rho(j));
    figure(4 + length(rho) + j);
    histogram(sRhoStudentTransformed);
    fprintf(['The null hypothesis that rho = %.2f can be rejected \n',...
    '(p-value) %.4f%% of the times.\n\n'], rho(j),...
    100*p);
end

