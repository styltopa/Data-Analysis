% Stelios Topalidis
% AEM: 9613

clc;

eruptData = readtable('eruption.dat');
[waitTime1989, dur1989, waitTime2006] = deal(table2array(eruptData(:,1)),...
                                        table2array(eruptData(:,2)), ...
                                        table2array(eruptData(:,3)));

clf;
% The figures of waiting times and durations, with a normal curve
% fitting the data
figure(1);
histfit(waitTime1989);
title('Histogram of waiting times between Old Faithful geyser eruptions');
legend('1989');

figure(2);
histfit(dur1989);
title('Histogram of durations of eruptions of the Old Faithful geyser');
legend('1989');

figure(3);
histfit(waitTime2006);
title('Histogram of waiting times between Old Faithful geyser eruptions');
legend('2006');
 
% % The waiting times between eruptions in years 1989, 2006 in one plot
% figure(4);
% histogram(waitTime1989);
% hold on;
% histogram(waitTime2006);
% title('Histogram of waiting times between Old Faithful geyser eruptions');
% legend('1989', '2006');
% hold off;

%% (a)
clc;
str = 'std';
fprintf('------------------------\n');
fprintf('(a): Testing for the standard deviation\n\n');
%% waitTime1989
% hypothesized standard deviation of waiting time
hypStdDev = 10;
hypVar = hypStdDev^2;
alpha = 0.05;

[h, ~, ci, ~] = vartest(waitTime1989, hypVar,...
    'Alpha', alpha);

fprintf('-Waiting time in 1989\n');
hypTest(h, hypStdDev, ci, alpha, str);

%% dur1989
% hypothesized standard deviation of duration 
hypStdDev = 1;
hypVar = hypStdDev^2;
alpha = 0.05;

[h, ~, ci, ~] = vartest(dur1989, hypVar,...
    'Alpha', alpha);

fprintf('-Duration in 1989\n');
hypTest(h, hypStdDev, ci, alpha, str);

%% waitTime2006
% hypothesized standard deviation of waiting time 
hypStdDev = 10;
hypVar = hypStdDev^2;
alpha = 0.05;

[h, ~, ci, ~] = vartest(waitTime2006, hypVar,...
    'Alpha', alpha);


fprintf('-Duration in 2006\n');
hypTest(h, hypStdDev, ci, alpha, str);
fprintf('------------------------\n\n');

%% (b)
str = 'mean';
fprintf('------------------------\n');
fprintf('(b): Testing for the mean\n\n');
%% waitTime1989
% hypothesized mean of waiting time
hypMean = 75;
alpha = 0.05;

[h, ~, ci, ~] = ttest(waitTime1989, hypMean,...
    'Alpha', alpha);

fprintf('-Waiting time in 1989\n');
hypTest(h, hypMean, ci, alpha, str);

%% dur1989
% hypothesized mean of duration
hypMean = 2.5;
alpha = 0.05;

[h, ~, ci, ~] = ttest(dur1989, hypMean,...
    'Alpha', alpha);

fprintf('-Duration in 1989\n');
hypTest(h, hypMean, ci, alpha, str);

%% waitTime2006
% hypothesized mean of waiting time 
hypMean = 75;
alpha = 0.05;

[h, ~, ci, ~] = ttest(waitTime2006, hypMean,...
    'Alpha', alpha);

fprintf('-Duration in 2006\n');
hypTest(h, hypMean, ci, alpha, str);
fprintf('------------------------\n\n');

%% (c)
str = 'chi2';
fprintf('------------------------\n');
fprintf(['(c): Testing if the distribution of the data is normal with\n',...
    'the chi squared test\n\n']);

%% waitTime1989
alpha = 0.05;
[h, p, ~] = chi2gof(waitTime1989, 'Alpha', alpha);

fprintf('-Waiting time in 1989\n');
hypTest(h, hypMean, ci, alpha, str, p);

%% dur1989
alpha = 0.05;
[h, p, ~] = chi2gof(dur1989, 'Alpha', alpha);

fprintf('-Duration in 1989\n');
hypTest(h, hypMean, ci, alpha, str, p);

%% waitTime2006
alpha = 0.05;
[h, p, ~] = chi2gof(waitTime2006, 'Alpha', alpha);

fprintf('-Waiting time in 2006\n');
hypTest(h, hypMean, ci, alpha, str, p);
fprintf('------------------------\n');

%% Functions used
% Function documentation
% If str = std or mean, the function displays the ci and the result of the 
% hypothesis (acceptance or rejection)
% If str = chi2, the function displays the result of the hypothesis 
% (acceptance or rejection)and also the p-value given that the hypothesis
% holds

% h: the result of the hypothesis
% alpha: the confidence level for which the hypothesis is accepted
% str: the parameter of the hypothesis:
%  'std': hypothesis that the data follow a normal dist of given std. dev.
%  'mean': hypothesis that the data follow a normal dist of given mean.
%  'chi2': hypothesis that the data follow a normal dist of mean equal to 
% the sample mean and variance equal to the sample variance.

% (Exclusive to str = std or mean)
% hypothesizedVal: 
% the value to test the hypothesis for the std or mean
% ci: the confidence interval

% (Exclusive to str = chi2)
% p: the p-value of the test

function stdDev = hypTest(h, hypothesizedVal, ci, alpha, str, p)
    switch str
        case 'std'
            fprintf(['The variance has a confidence interval of\n',...
            '[%.2f, %.2f] or equivalently standard deviation confidence \n'...
            'interval of [%.2f, %.2f] \n\n'], ci(1), ci(2),...
            sqrt(ci(1)), sqrt(ci(2)));
            if h
                fprintf(['The hypothesis that the standard\n', ...
                    'deviation equals %.1f is rejected with %.1f%% confidence\n\n'], ...
                    hypothesizedVal, (1-alpha)*100);
            elseif not(h)
                fprintf(['The hypothesis that the standard\n', ...
                    'deviation equals %.1f is accepted with %.1f%% confidence\n\n'], ...
                    hypothesizedVal, (1-alpha)*100);
            end
        case 'mean'
            fprintf(['The mean has a confidence interval of\n',...
                '[%.1f, %.1f] \n\n'], ci(1), ci(2));
            if h
                fprintf(['The hypothesis that the mean\n', ...
                    'equals %.2f is rejected with %.1f%% confidence\n\n'], ...
                    hypothesizedVal, (1-alpha)*100);
            elseif not(h)
                fprintf(['The hypothesis that the mean\n', ...
                    'equals %.2f is accepted with %.1f%% confidence\n\n'], ...
                    hypothesizedVal, (1-alpha)*100);
            end
        case 'chi2'
            if h
                fprintf(['The hypothesis that the data comes from a\n', ...
                    'normal distribution (of mean the mean of the data and \n',... 
                    'variance the variance of the data) is rejected \n',...
                    'with %.1f%% confidence\n\n'], (1-alpha)*100);
            elseif not(h)
                fprintf(['The hypothesis that the data comes from a\n', ...
                    'normal distribution (of mean the mean of the data and \n',... 
                    'variance the variance of the data) is accepted\n',...
                    'with %.1f%% confidence\n\n'], (1-alpha)*100);
            end
            fprintf(['The p-value meaning the probability of observing \n',... 
                'this sample under the null hypothesis equals %f\n\n'], p);
        otherwise
            error('stdDev: the str parameter must be std, mu or chi2\n');
    end
    return
end

