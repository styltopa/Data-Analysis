% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function 1 for Exercise 8

function[adjR2Poly, pVal] = Group10Exe8Fun1(x,y)
    %% (a) Remove Nan values
    xAndY = [x, y];
    xAndYNotNan = rmmissing(xAndY);
    [x, y] = deal(xAndYNotNan(:, 1), xAndYNotNan(:, 2));

    %% (b) Fit a model using OLS
    %% 3rd degree Polynomial model

    X  =[x, x.^2, x.^3];
    
    yModelStruct3 = fitlm(X, y, 'RobustOpts', 'ols');
    
    adjR2Poly = yModelStruct3.Rsquared.Adjusted;


    %% (c) Randomisation test for adjR^2
    nSamples = 1000;
    % vector with the adjR2 values of the randomised samples
    adjR2V = nan(nSamples, 1);

    for i = 1:nSamples
        randPermIndices = randperm(length(y));
    
        yrand=y(randPermIndices);
        yModelStruct3 = fitlm(X, yrand, ...
            'RobustOpts', 'ols');
        
        adjR2V(i) = yModelStruct3.Rsquared.Adjusted;
    end


    pVal = (1+sum( adjR2V>= adjR2Poly))/(nSamples+1);
end