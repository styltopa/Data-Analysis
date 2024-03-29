% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function for exercise 2

%% Argument
% - x: feature vector

function [CI ,CIbootstrap] = Group10Exe2Fun1(x)
    %   Remove Nan values
    idx  = isnan(x);
    x(idx) = [];
    alpha= 0.05;
    [~, ~, CI, ~] = ttest(x, mean(x), 'Alpha',alpha);

    nboot = 1000;
    CIbootstrap = bootci(nboot, @mean, x);
end



