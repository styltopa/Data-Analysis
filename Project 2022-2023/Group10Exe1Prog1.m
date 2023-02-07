% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM:9516
% Project for academic year 2022-2023
% Program 1 for exercise 1

clc;
clear;
close all;


data = table2array(readtable('Heathrow.xlsx'));
dataNamesStruct = importdata('Heathrow.xlsx');
dataNames = string(dataNamesStruct.textdata.Sheet1);
dataNamesPeriphrastic = {'Year', 'Mean annual temperature', ...
        'Mean annual maximum temperature', 'Mean annual minimum temperature', ...
        'Total annual rainfall or snowfall', 'Mean annual wind velocity', ...
        'Number of days with rain', 'Number of days with snow', ...
        'Number of days with wind', 'Number of days with fog', ...
        'Number of days with tornado', 'Number of days with hail'};

% Significance level for the tests
alpha = 0.05;
fprintf(['Tests if the feature follows given distributions \n',...
    'and length of unique values in input vector.\n',...
    '(uniform or normal\n',...
    'distribution for large number of unique values and the binomial ',...
    'and discrete \n',...
    'uniform for small number of unique values of the input vector)\n']); 
fprintf('The tests are held at a %.2f significance level\n\n', alpha);

p = zeros(11,2);
for i = 1:11
    fprintf('%s (%s) follows the:\n', dataNames(i+1), ...
        string(dataNamesPeriphrastic(i+1)));
    dataV = data(:,i+1);
    dataUniqueSet = unique(dataV);
    [p(i,1),p(i,2)] = Group10Exe1Fun1(dataV);
    
%   Test for the discrete distributions
%   (large number of unique values in the input vector)
    if size(dataUniqueSet, 1) <= 10
        if p(i, 1) < alpha
            fprintf('- Binomial: No\n');
        elseif p(i, 1) > alpha
            fprintf('- Binomial: Yes\n');
        elseif isnan(p(i, 1))
            fprintf('- Binomial: Test returns Nan for the p-value\n');
        end
        if p(i, 2) < alpha
            fprintf('- Discrete uniform: No\n');
        elseif p(i, 2) > alpha
            fprintf('- Discrete uniform: Yes\n');
        elseif isnan(p(i, 2))
            fprintf(['- Discrete uniform: Test returns Nan for ',...
                'the p-value\n']);
        end
%   Test for the continuous distributions 
%   (large number of unique values in the input vector)
    elseif size(dataUniqueSet, 1) > 10
        if p(i, 1) < alpha
            fprintf('- Normal: No\n');
        elseif p(i, 1) > alpha
            fprintf('- Normal: Yes\n');
        elseif isnan(p(i, 1))
            fprintf('- Normal: Test returns Nan for the p-value\n');
        end
        if p(i, 2) < alpha
            fprintf('- Uniform: No\n');
        elseif p(i, 2) > alpha
            fprintf('- Uniform: Yes\n');
        elseif isnan(p(i, 2))
            fprintf(['- Uniform: Test returns Nan for ',...
                'the p-value\n']);
        end
    end
    
    fprintf('-------------------------\n');
end
