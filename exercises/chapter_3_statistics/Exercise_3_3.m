% Stelios Topalidis
% AEM: 9613
% Exercise 3.3

clc;
% The percentage acceptance of the null hypothesis that the mean mu 
% belongs to the 95% confidence interval should increase for 
% increasing number of elements (n) in each sample (M samples overall)
% Comment/uncomment one of the cases below
% (a)
[n, M, mu] = deal(5, 1000, 15);
% (b)
% [n, M, mu] = deal(100, 1000, 15);

x = exprnd(mu, n, M);

% y : Mx1 vector of the mean of n observations of M different samples
y = mean(x, 1);

% hCounter: counts the amount of times of rejection of null hypotheses
hCounter = 0;
  
for i = 1:M
    % h: is 0 if the null hypothesis is accepted meaning mu is in the ci
    % for the i-th sample
    % ci: the confidence interval of the distribution 
    % given that Alpha is 5%
    [h, ~, ~, ~] = ttest(x(:,i), mu, 'Alpha', 0.05);
    hCounter = hCounter + h;
end

[~, ~, ci, ~] = ttest(y, mu, 'Alpha', 0.05);

clf;
figure(1);
histogram(y);
title("Histogram of means of samples taken from the exponential dist");
subtitleStr = ['M: ', num2str(M), ',  n: ', num2str(n), ...
    ',  Mean of the distribution ', ...
    'which the samples were taken from (1/\lambda): ', num2str(mu)];
subtitle(subtitleStr);
xline([ci(1), ci(2)], '-', ...
    {'Lower limit of confidence interval', ...
    'Upper limit of confidence interval'}, 'Color', 'b', 'LineWidth', 2,...
    'LabelHorizontalAlignment', 'center');
% 'Mean value' here (mu) refers to the mean value of the distribution which 
% the samples were taken of
xline(mu, '-', {'Mean value'}, 'Color', 'r', 'Linestyle', '-',... 
    'LineWidth', 2, 'LabelHorizontalAlignment', 'center');

% hCounter = the amount of times the null hypothesis was rejected
% M - hCounter = the amount of times the null hypothesis was accepted
fprintf(['The null hypothesis (that the mean failure time ',...
    'of a system \nequals 15 days) was accepted %d times out of %d \n',...
    'or %.2f%% of the times\n'], ...
    M-hCounter, M, ((M-hCounter)/M)*100);

