% Stelios Topalidis
% AEM: 9613
% Exercise 3.10

clc;
clear;
close all;

% height before bounce
h1 = 100;
% height after bounce 
h2 = [60, 54, 58, 60, 56];
e = sqrt(h2/h1); 
eDesired = 0.76;

%% (a) Accuracy uncertainty and precision uncertainty
eDiff = e - eDesired;
% Accuracy: if e of the ball is close to eDesired (small systematic
% error)
% accuracy uncertainty
numOfObservations = length(e);
accUncer = std(eDiff)/sqrt(numOfObservations);

% repetition uncertainty
repetUncer = std(eDiff);

fprintf('(a)\nAccuracy uncertainty (for the mean)= %.4f.\n',...
    accUncer);

fprintf(['Repetition uncertainty (for each new observation) =',... 
    ' %.4f.\n\n'], repetUncer);

% Notes: The std for each new observation is naturally greater than the one
% for the mean (the expected mean of a new sample of observations).

%% (b) 
n = 5;
M = 1000;
% mean for h2 to draw the sample 
mu = 58;
sigma = 2;
h2 = normrnd(mu, sigma, n, M);

%% h2
expectedMeanH2 = mu;
expectedStdH2 = sigma;

sampleMeanH2 = mean(h2, 1);

figure(1);
histogram(sampleMeanH2);
title(['Sample means of h2 for M = ', num2str(M), ' samples']);
xline(expectedMeanH2, '-', 'expected mean of h2');


sampleStdH2 = std(h2, 1);

figure(2);
histogram(sampleStdH2);
title(['Standard deviations of h2 for M = ', num2str(M), ' samples']);
xline(expectedStdH2, '-', 'expected std of h2');

%% e
% h1 remains the same for all measurements.
expectedMeanE = sqrt(expectedMeanH2/h1);
% sigma_e is derived as a function of sigma_h2 from the law of propagation 
% of errors
expectedStdE = (1/(2*sqrt(expectedMeanH2 * h1)))*expectedStdH2;

e = sqrt(h2/h1);
    
sampleMeanE = mean(e, 1);

figure(3);
histogram(sampleMeanE);
title(['Sample means of e for M = ', num2str(M),  ' samples']);
xline(expectedMeanE, '-', 'expected mean of e');

sampleStdE = std(e, 1);

figure(4);
histogram(sampleStdE);
title(['Sample standard deviations of e for M = ', num2str(M), ' samples']);
xline(expectedStdE, '-', 'expected std of e');

% Notes: the means of both h2 and e seem to follow the normal distribution
% However the standard deviations of h2 and e are lopsided (they have
% positive skewness / lopsided to the left).

%% (c)

h1 =  [80 100 90 120 95];
h2 = [48 60 50 75 56];
e = sqrt(h2./h1);

% uncertainties of h1, h2, e
h1Uncert = std(h1);
h2Uncert = std(h2);
eUncert = std(e);
eDesired = 0.76;

fprintf('(c)\nUncertainty for h1: %.3f\n', h1Uncert);
fprintf('Uncertainty for h2: %.3f\n', h2Uncert);
fprintf('Uncertainty for e: %.3f\n', eUncert);
fprintf('Desired e: %.3f\n', eDesired);
fprintf('Sample mean e: %.3f\n', mean(e));
% Note: The mean value of e is very close to the desired one for the ball


% Note: I perform the analysis for the relation between h1 and e to see if
% e is constant no matter what the value of h1 is (which is the expected 
% for a well bouncing ball) or 
% if there is a trend 
% (e.g. if high values of height h1 tend to result in 
% higher -or lower- values of e).
[h1Sorted, ind] = sort(h1);
h2Sorted = sort(h2);
figure(5);
plot(h1Sorted, e(ind));
xlabel('h1');
ylabel('e');
title('Restitution coefficient e as a function of the dropping height h1');

% Note: even if the sample mean of e is very close to the desired
% coefficient e (0.76), the e-h1 graph suggests that large dropping heights 
% h1 result in high restitution coefficients e meaning larger values of h2.
% This practically translates to the higher the dropping height of the ball
% (h1) the higher the ball will bounce (h2) unproportionally to the formula
% h2 = e^2 * h1 (e = sqrt(h2/h1).