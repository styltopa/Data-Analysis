% Stelios Topalidis
% AEM: 9613
% Exercise 4.3

clc;
clear;
close all;


%% (a) Uncertainty of power stdP as a function of stdV, stdI, stdf
%% given that V, I, f are uncorrelated
[muV, muI, muf] = deal(77.78, 1.21, 0.283);
[stdV, stdI, stdf] = deal(0.71, 0.071, 0.017);

% Law of propagation of errors:
% stdP = sqrt((V*cos(f)*stdV)^2 + (V*cos(f)*stdI)^2 + ...
%     (V*I*(-sin(f)))^2);

% Caclulation for (V, I, f) = the mean values (muV, muI, muf) from 
% part b):
% tMean: theoretic power mean 
tPMean = muV*muI*cos(muf);
% tStdP¨theoretic standard deviation of power 
% By the law of propagation of errors and given V, I, f 
% and their uncertainties from (b) we compute
tStdP = sqrt((muI*cos(muf)*stdV)^2 + (muV*cos(muf)*stdI)^2 + ...
    (muV*muI*(-sin(muf))*stdf)^2);

fprintf(['(a)\nTheoretic power uncertainty: %.3f\n\n'], tStdP);


%% (b) Check if the sample stdP is consistent with its theoretic value 
%% (check if the sample and the theoretic accuracy are equal)
% M samples of triad of (V, I, f), histogram of P, two xlines of +-stdP of
% a one from the sample and the one from a
M = 1000;
% vector of means
muVector = [muV, muI, muf];
% Since the variables are not correlated, meaning the covariance of V, I 
% and f is equal to zero (non diagonal elements of the array).
sigmaMat = [stdV^2, 0, 0;...
            0, stdI^2, 0;...
            0, 0 stdf^2];

varsSamples = mvnrnd(muVector, sigmaMat, M);
V = varsSamples(:, 1);
I = varsSamples(:, 2);
f = varsSamples(:, 3);

P = V.*I.*cos(f);

% sPMean: sample power mean. It converges to the theoretic mean for 
% large number of triads (V, I, f)
% sStdP: sample power standard deviation. It also converges to the 
% theoretic standard deviation large number of triads (V, I, f)
sPMean = mean(P);
% (standard deviation of the values of P \n',...
%    'calculated from the triads (V, I, f))
sStdP = std(P);

figure(1);
histogram(P);
title(['M = ', num2str(M),' samples of power given that V, I and f are ',...
    'uncorrelated']);

% Note: the xlines are for the sample means and standard deviations
xline([sPMean - sStdP, sPMean + sStdP], '-', {'mu - sample std',...
     'mu + sample std'}, 'LineWidth', 2);
xline([sPMean - tStdP, sPMean, sPMean + tStdP], '-', {'mu - theoretical std',...
    'mu', 'mu + tStdP'}, 'LineWidth', 2, 'Color', 'r');


fprintf(['(b)\n',...
    'Sample power uncertainty: %.3f\n\n'], sStdP); 
% Note: the sample accuracy (sStdP) is close to the theoretic one (tStdP)

%% (c) Same as (a, b) but this time V and f are correlated 
%% (c.a) This time the law of propagation of errors considers the
%% covariances between V and f:

% correlation coefficient between V and f
rhoVf = 0.5;
% Law of propagation of errors (covariance between V, f included:
% stdP = sqrt((V*cos(f)*stdV)^2 + (V*cos(f)*stdI)^2 + ...
%     (V*I*(-sin(f)))^2) + ...
%     (I*cos(f))*(V*I*(-sin(f)))*VfCorrCoeff * stdV * stdf;

% tMean: theoretic power mean. The non zero covariance between 
% V and f does not influence the calculation of the mean (remains the same
% as before).
tPMean = muV*muI*cos(muf);
 
% covariance of V and f (rho12 = cov12/(sigma1*sigma2))
covVf = rhoVf * stdV * stdf;

% tStdP¨theoretic standard deviation of power. Here however, the law of
% propagation of error now takes into account the non-zero covariance
% of V and f.
tStdP = sqrt((muI*cos(muf)*stdV)^2 + (muV*cos(muf)*stdI)^2 + ...
    (muV*muI*(-sin(muf))*stdf)^2 + ...
    (muI*cos(muf))*(muV*muI*(-sin(muf)))* covVf);
fprintf(['(c.a)\nTheoretic power uncertainty (V, f are now ',...
    'correlated): %.3f \n\n'], tStdP);

% Note: the non zero covariance between V and I results in a smaller stdP
% due to the minus sign of the new term in the law of propagation of
% errors.

%% (c.b) The M samples (V, I, f) now follow a normal multivariate 
%% distribution with correlated variables (sigmaMat is not diagonal)

% M samples of triad of (V, I, f), histogram of P, two xlines of +-stdP of
% a one from the sample and the one from a
M = 1000;
% vector of means
muVector = [muV, muI, muf];
% Since the variables are not correlated, meaning the covariance of V, I 
% and f is equal to zero (non diagonal elements of the array).
sigmaMat = [stdV^2, 0, covVf;...
            0, stdI^2, 0;...
            covVf, 0 stdf^2];

        
varsSamples = mvnrnd(muVector, sigmaMat, M);
V = varsSamples(:, 1);
I = varsSamples(:, 2);
f = varsSamples(:, 3);

P = V.*I.*cos(f);


% sPMean: sample power mean. It converges to the theoretic mean for 
% large number of triads (V, I, f)
% sStdP: sample power standard deviation. It also converges to the 
% theoretic standard deviation large number of triads (V, I, f)
sPMean = mean(P);
% (standard deviation of the values of P \n',...
%    'calculated from the triads (V, I, f))
sStdP = std(P);

figure(2);
histogram(P);
title(['M = ', num2str(M),' samples of power given that V and f are ',...
    'correlated with $$\rho_{V, f}$$ =', num2str(rhoVf)], 'interpreter',...
    'latex');

% Note: the xlines are for the sample means and standard deviations
xline([sPMean - sStdP, sPMean + sStdP], '-', {'mu - sample std',...
     'mu + sample std'}, 'LineWidth', 2);
xline([sPMean - tStdP, sPMean, sPMean + tStdP], '-', ...
    {'mu - theoretical std',...
     'mu', 'mu + theoretical std'}, 'LineWidth', 2, 'Color', 'r');


fprintf(['(c.b)\n',...
    'Sample power uncertainty (V, f are now ',...
    'correlated): %.3f\n\n'], sStdP); 


% Notes: 
% In both cases 1st) where (V, I, f) uncorrelated (parts a, b) and 
% 2nd) where (V, f) correlated (part c) , the 
% sample uncertaintaintlies of the power (sStdP) 
% are close to the theoretical ones (tStdP).
