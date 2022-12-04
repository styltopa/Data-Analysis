% Stelios Topalidis
% AEM: 9613
% Exercise 5.1

clc;
clear;
close all;

[M, n] = deal(1000, 20);
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
        sRho(i) = sCovXY/(sSigmaX*sSigmaY);    
    end

    % sRhoFisher follows a normal distribution and therefore tests for its mean
    % can be performed.
    sRhoFisher = atanh(sRho(:, j));
    sRhoFisherLow = sRhoFisher - critVal*sqrt(1/(n-3));
    sRhoFisherHigh = sRhoFisher + critVal*sqrt(1/(n-3));
    % invert fisher transform back to the original values of the correlation
    % coefficient
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


%% (b) Hypothesis testing of correlation coefficient of X, Y equal to zero

% for the different values of rho that we want to check
for j = 1:length(rho)
    
    % transform the sample rho to follow the student distribution
    sRhoStudentTransformed = sRho(:, j).*sqrt((n-2)./(1-sRho.^2));
    h = ttest(sRhoStudentTransformed, rho(j));
end

