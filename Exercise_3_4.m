% Stelios Topalidis
% AEM: 9613

clc;

%% (a) 
x = [41 46 47 47 48 50 50 50 50 50 50 50, ...
48 50 50 50 50 50 50 50 52 52 53 55, ...
50 50 50 50 52 52 53 53 53 53 53 57, ...
52 52 53 53 53 53 53 53 54 54 55 68];
% plays no role in the confidence interval calculated from vartest 
% (ci is calculated from the sample). It is only used for the hypothesis
% testing
varA = var(x);

% vartest tests the hypothesis that the data x can be derived from a 
% normal distribution with variance myVar
alphaA = 0.05;
[~, ~, varCI, ~] = vartest(x, varA, 'Alpha', alphaA);

fprintf(['(a): The %.1f%% confidence interval for the variance is ',...
    '[%.2f, %.2f]\n\n'], (1-alphaA)*100,  varCI(1), varCI(2));

%% (b)
stdevB = 5;
varB = stdevB^2;
alphaB = 0.05;
% checking if the data is derived from a normal distribution of variance 
% 25 (5^2).
[hb, ~, ~, ~] = vartest(x, varB, 'Alpha', alphaB);
% hb is 1 (true) if the hypothesis is rejected and 0 (false) is it is not
% rejected
if hb 
    fprintf(['(b): The null hypothesis that the data is derived ',... 
        'from a \nnormal distribution of stand. deviation = %.2f \n',...
        'or variance = %.2f is rejected ',...
        '(see confidence interval from (a))\n\n'], stdevB, varB);
elseif not(hb)
    fprintf(['(b): The null hypothesis that the data is derived ',... 
        'from a \nnormal distribution of stand. deviation = %.2f \n',...
        'or variance = %.2f is accepted ',...
        '(see confidence interval from (a))\n\n'], stdevB, varB);
end

%% (c), (d)
% the significance level for the ttest for the mean of the sample
alphaC = 0.05;
% the value of mu does not influence the calculation of muCI (confidence interval for 
% the mean) but is only used for the null hypothesis testing
muToCheck = 52; 
[hd, pc, muCI, ~] = ttest(x, muToCheck, 'Alpha', alphaC); 
fprintf(['(c): The %.1f%% confidence interval for the mean is ',...
    '[%.2f, %.2f]\n\n'], (1-alphaA)*100,  muCI(1), muCI(2));

if hd
    fprintf(['(d): The hypothesis that %.1f kV is the mean of the data \n',...
        'with %.1f%% confidence is rejected ',...
        '(see confidence interval from (c)).\n\n'], muToCheck,...
        (1-alphaC)*100);
elseif not(hd)
    fprintf(['(d): The hypothesis that %.1f kV is the mean of the data \n',...
        'with %.1f%% confidence is accepted ',...
        '(see confidence interval from (c)).\n\n'], muToCheck,...
        (1-alphaC)*100);
end

%% (e)
% he: the null hypothesis testing bool for question e
% pe: the p-value for the chi2 goodness of fit test
alphaE = 0.05;
[he, pe, ~] = chi2gof(x, 'Alpha', alphaE);


if he
    fprintf(['(e): The null hypothesis that the data is from the \nchi',...
        ' squared distribution with confidence %.2f%% is rejected.\n'],...
    (1-alphaE)*100);
elseif not(he)
    fprintf(['(e): The null hypothesis that the data is from the \nchi',...
        ' squared distribution with confidence %.2f%% is accepted.\n'], ...
        (1-alphaE)*100);
end
fprintf(['The p-value (meaning the min value of the confidence level ',...
    '\nfor which the null hypothesis is accepted) is: %f\nor %f%%\n\n'], ...
    pe, pe*100);
