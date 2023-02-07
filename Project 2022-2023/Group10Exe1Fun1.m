% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 1

function [p1,p2] = Group10Exe1Fun1(data)
    
    v = rmmissing(data);
    vSet = unique(v);

    if length(vSet) <= 10
        probabilityOfSuccess = mean(data)/365;
        numberOfTrials = 365;
        [~, pBinomial] = chi2gof(data, 'cdf', ...
            {@binocdf,numberOfTrials,probabilityOfSuccess});
        [~, pDiscreteUniform] = chi2gof(data,'cdf',{@unidcdf,max(data)});
        figure();
    %     bar(data);
        X = categorical(data, vSet, cellstr(num2str(unique(vSet, 'sorted'))));
        histogram(X, 'BarWidth', 0.5);
        title({'Bar graph of values in sample'; ['p-value for binomial dist.: ', ...
            num2str(pBinomial)];...
            ['p-value for discrete uniform dist.: ', num2str(pDiscreteUniform)]});
        xlabel('Values');
        ylabel('Frequency')
        p1 = pBinomial;
        p2 = pDiscreteUniform;
    else
        [~, pNormal] = chi2gof(data);
        [~, pUniform] = chi2gof(data,'cdf',{@unifcdf,min(data),max(data)});
        figure();
        histogram(data);
        title({'Histogram of values in sample';[ 'p-value for normal dist.: ', ...
            num2str(pNormal)];...
            ['p-value for uniform dist.: ', num2str(pUniform)]});
        xlabel('Values');
        ylabel('Frequencies');
        p1 = pNormal;
        p2 = pUniform;
    end
end