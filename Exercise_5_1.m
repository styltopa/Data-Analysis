% Stelios Topalidis
% AEM: 9613
% Exercise 5.1

clc;
clear;
close all;

% some value for reproducibility (so that consistent results are given for 
% different values of n (part c))
% rng(454);
%% For (c) comment/uncomment one of the option below to select the number of
%% observations in each sample.
% [M, n] = deal(1000, 20);
[M, n] = deal(1000, 200);
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
        corrCoefMat = corrcoef(X, Y);
        sRho(i, j) = corrCoefMat(1, 2);
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

    
    rejectionCounter = 0;
    for i = 1:M
        if rho(j) < sRhoLow(i) || rho(j) > sRhoHigh(i)
            rejectionCounter = rejectionCounter + 1;
        end
    end

    rejectionPercent = rejectionCounter/M;

    if j == 1
        fprintf('For n = %d observations per sample:\n', n);
        fprintf('(a)\n');
    end
    fprintf(['For rho_(X,Y) = %.2f:\nPercentage of rho being inside the ',...
        'ci:\n'], rho(j));
    % theoretical meaning taken from the parametric confidence intervals
    % see variable critVal 
    fprintf('Theoretical: %.2f%%\n', 100*(1-alpha));
    fprintf('Sample: %.2f%%  (M = %d samples)\n\n', ...
        100*(1-rejectionPercent), M);

    figure(j);
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
        ' ci bounds of $r_{X,Y}$'],...
        ['X,Y are sampled from a distribution with $\rho_{X,Y}$= ', ...
        num2str(rho(j))], 'Interpreter', 'latex');
end

% Notes on (a): the fisher transform gives rejection rates (or non
% rejection rates - it's the same) similar to the expected: (1-alpha)%


%% (b) Hypothesis testing of correlation coefficient of X, Y equal to zero
%% null hypothesis is expected to be rejected (alpha)% of the times
rhoStudentised = rho.*sqrt((M-2)./(1-rho.^2));

% for the different values of rho that we want to check
for j = 1:length(rho)
    
    % transform the sample rho to follow the student distribution
    sRhoStudentised = sRho(:, j).*sqrt((M-2)./(1-sRho(:, j).^2));
%     [h, p] = ttest(sRhoStudentTransformed, rho(j));
    
    [h, p] = ttest(sRhoStudentised, ...
        rho(j)*sqrt((M-2)./(1-rho(j)^2)));
    if j == 1
        fprintf('(b)\n');
    end
    fprintf('For rho_(X,Y) = %.2f:\n', rho(j));
    figure(length(rho) + j);
    histogram(sRhoStudentised);
    title(['M = ', num2str(M), ' samples of studentised $r_{X,Y}$'], ...
        ['$\rho_{X,Y}$ = ', num2str(rho(j))], 'interpreter', 'latex');
    xline(rhoStudentised(j), '-', {'actual rho (studentised)'});
    fprintf(['The null hypothesis that rho = %.2f cannot be rejected \n',...
    '(1 - p-value) %.4f%% of the times.\n\n'], rho(j),...
    100*(1-p));
    if j == length(rho)
        fprintf('---------------------\n');
    end
end

% Notes on (b): 
% 1) For n = 20, the hypothesis that rho_X,Y = 0 gives incosistent 
% p-values meaning incosistent rejection rates of the hypothesis.
% The hypothesis that rho_X,Y = 0.5 gives more stable rejection rates
% (higher than the ones with the fisher transform)

% 2) For n = 200, the results of the rejection rates are totally
% incosistent. Some executions of the program result in close rejection
% rates to the ones 

% Notes on (c):
% The results are not consistent as far as the increase in n goes.
% What I mean by this is that it is expected that more observations per
% sample would account for rejection rates converging to the real ones.
% This does not seem to be the case (probably some error of the
% calculations?).


%% (d)
% some value for reproducibility (so that consistent results are given for 
% different values of n (part c))
% rng(454);
%% For (c) comment/uncomment one of the option below to select the number of
%% observations in each sample.
% [M, n] = deal(1000, 20);
[M, n] = deal(1000, 200);
[sigmaX, sigmaY, muX, muY] = deal(1, 1, 0, 0);
muV = [muX, muY];
% the actual rho between X and Y, and their true covariance
% rho can be however long vector we want
rho = [0, 0.5];
covXY = rho*sigmaX*sigmaY;


%% (d.a) (1-alpha)% Theoretical and sample confidence interval 
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
        X = jointSample(:, 1).^2;
        Y = jointSample(:, 2).^2;
        corrCoefMat = corrcoef(X, Y);
        sRho(i, j) = corrCoefMat(1, 2);
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

    
    rejectionCounter = 0;
    for i = 1:M
        if rho(j) < sRhoLow(i) || rho(j) > sRhoHigh(i)
            rejectionCounter = rejectionCounter + 1;
        end
    end

    rejectionPercent = rejectionCounter/M;

    if j == 1
        fprintf('For n = %d observations per sample:\n', n);
        fprintf('(d.a)\n');
    end
    fprintf(['For rho_(X,Y) = %.2f:\nPercentage of rho being inside the ',...
        'ci:\n'], rho(j));
    % theoretical meaning taken from the parametric confidence intervals
    % see variable critVal 
    fprintf('Theoretical: %.2f%%\n', 100*(1-alpha));
    fprintf('Sample: %.2f%%  (M = %d samples)\n\n', ...
        100*(1-rejectionPercent), M);

    figure(2*length(rho)+j);
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

% Notes on (a): the fisher transform gives rejection rates (or non
% rejection rates - it's the same) similar to the expected: (1-alpha)%


%% (d.b) Hypothesis testing of correlation coefficient of X, Y equal to zero
%% null hypothesis is expected to be rejected (alpha)% of the times
rhoStudentised = rho.*sqrt((M-2)./(1-rho.^2));

% for the different values of rho that we want to check
for j = 1:length(rho)
    
    % transform the sample rho to follow the student distribution
    sRhoStudentised = sRho(:, j).*sqrt((M-2)./(1-sRho(:, j).^2));
%     [h, p] = ttest(sRhoStudentTransformed, rho(j));
    
    [h, p] = ttest(sRhoStudentised, ...
        rho(j)*sqrt((M-2)./(1-rho(j)^2)));
    if j == 1
        fprintf('(d.b)\n');
    end
    fprintf('For rho_(X,Y) = %.2f:\n', rho(j));
    figure(3*length(rho) + j);
    histogram(sRhoStudentised);
    title(['M = ', num2str(M), ' samples of studentised $r_{X^2,Y^2}$'], ...
        ['$\rho_{X,Y}$ = ', num2str(rho(j))], 'interpreter', 'latex');
    xline(rhoStudentised(j), '-', {'actual rho (studentised)'});
    fprintf(['The null hypothesis that rho = %.2f cannot be rejected \n',...
    '(1 - p-value) %.4f%% of the times.\n\n'], rho(j),...
    100*(1-p));
end

% Notes on (d):
