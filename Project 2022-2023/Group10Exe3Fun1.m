% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function for Exercise 3

function [p1, p2, discIndex] = Group10Exe3Fun1(years, feature)
    %% (a) Detect the point of discontinuity

    % Index of discontinuity 
    discIndex = nan; 
    for i=2:length(years)
        if years(i) ~= years(i-1)+1
            discIndex = i;
    %         Assume a single discontinuity point
    %         On the first discontinuity point we find, 
    %         we continue in the next iteration of the loop.
            continue;
        end
    end
    % If there was no discontinuity point, return error
    if isnan(discIndex)
        error("There should be a discontinuity point.");
    end
    %% (b) Split the data features in two vectors
    X1 = feature(1:discIndex-1);
    X2 = feature(discIndex:end);
    % Test if either X1 or X2 are filled only with NaN values
    
    % p1 and p2 are initialised with some impossible value (-1 for example) 
    [p1, p2] = deal(-1, -1);
    % If either of X1 or X2 have only NaN values, the test is not held
    % and the pvalues returned are NaN (remain as initialised)
    if ( all(isnan(X1) == ones(length(X1), 1), 'all') || ...
         all(isnan(X2) == ones(length(X2), 1), 'all'))
        p1 = nan(1, 1); 
        p2 = nan(1, 1);
    end
    
    % If p1 and p2 have not gotten NaN values then the periods have some 
    % values that are not NaN. Therefore, the equality of means test 
    % can be performed
    if ~isnan(p1) && ~isnan(p2) 
        % P-values from the:
        % parametric test
        % Remove Nan values
        idx1  = isnan(X1);
        X1(idx1) = [];
        idx2  = isnan(X2);
        X2(idx2) = [];
        
        %% (c, d) Parametric and randomisation test, 
        %% Calculate and return the p-values
        [~,p1] = ttest2(X1,X2);

        B=1000;
        % X3 contains all the values of both period vectors X1 and X2
        X3 = zeros(length(X1)+length(X2),1);
        X3(1:length(X1))= X1;
        X3(length(X1)+1:end)= X2;
        originalDiffOfMeans = mean(X1) - mean(X2);

        Y1 = NaN(B,length(X1));
        Y2 = NaN(B,length(X2));
        meanOfdiffOfY1Y2 = NaN(B,1);
        % Randomly split X3 into arrays Y1(with length of X1) and Y2
        % (with length of X2) each time we calculate the difference of 
        % the means
        for i=1:B
            my_indices = randperm(length(X3));
            Y1(i,:) = X3(my_indices(1:length(X1)));
            Y2(i,:) = X3(my_indices(length(X1)+1:end));
            meanOfdiffOfY1Y2(i) = mean(Y1(i,:)) - mean(Y2(i,:));
        end
        % Calculate the p value
        p2 = (1+sum(meanOfdiffOfY1Y2 >= originalDiffOfMeans))/(B+1);

    end
end




