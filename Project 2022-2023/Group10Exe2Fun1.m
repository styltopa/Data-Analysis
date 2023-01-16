% Function 1 for exercise 2% Stylianos Topalidis
% AEM: 9613
% Stamatis Harteros
% AEM: 9516
% Project for academic year 2022-2023
% Function 1 for Exercise 2


function [CI ,CIbootstrap] = Group10Exe2Fun1(x)
% 	 removing Nan values
    idx  = isnan(x);
    x(idx) = [];

    alpha = 0.05;
    [~, ~, CI, ~] = ttest(x, mean(x), 'Alpha', alpha);
    
    nboot = 1000;
    CIbootstrap = bootci(nboot, @mean, x);
end