% Stylianos Topalidis
% AEM: 9613
% Stamatis Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Exercise 2

% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function 1 for exercise 3

function [p1, p2, discIndex] = Group10Exe3Fun1(years, feature)
%% (a) Detect the first point of discontinuity

% Index of discontinuity (
discIndex = nan; 
for i=2:length(years)
    if years(i) ~= years(i-1)+1
        discIndex = i;
%         We assume a single discontinuity point
%         On the first discontinuity point we find, 
%         we leave the for loop.
        continue;
    end
end
% If there was no discontinuity point, return error
if isnan(discIndex)
    error("There should be a discontinuity point.");
end
%% (b)
X1 = feature(1:discIndex-1);
X2 = feature(discIndex:end);
% We test if either X1 or X2 are filled only with NaN values
% If so, we cannot compare the periods from the given feature
isnan1 = isnan(X1);
isnan2 = isnan(X2);
nan1 = 1;
nan2 = 1;
for i = 1:length(isnan1)
    if isnan1(i) == 0
        nan1 = 0;
        continue;
    end
end
for i = 1:length(isnan2)
    if isnan2(i) == 0
        nan2 = 0;
        continue;
    end
end
% If both nan1 or nan2 is zero, then
p1 = 10; 
p2 = 10;

if nan1 == 0 && nan2 == 0

    % P-values from the:
    % parametric test
    %  removing Nan values
    idx1  = isnan(X1);
    X1(idx1) = [];
    %  removing Nan values
    idx2  = isnan(X2);
    X2(idx2) = [];
    %% (g,d)
    [~,p1] = ttest2(X1,X2);

    B=1000;
    % Array X3 contains all the values of both period vectors X1 and X2
    X3 = zeros(length(X1)+length(X2),1);
    X3(1:length(X1))=X1;
    X3(length(X1)+1:end)=X2;
    originalDiffOfMeans = mean(X1) - mean(X2);

    Y1 = NaN(B,length(X1));
    Y2 = NaN(B,length(X2));
    meanOfdiffOfY1Y2 = NaN(B,1);
    % We randomly split X3 into arrays Y1(with length of X1) and Y2(with
    % length of X2) each time we calculate the difference of the means
    for i=1:B
        my_indices = randperm(length(X3));
        Y1(i,:) = X3(my_indices(1:length(X1)));
        Y2(i,:) = X3(my_indices(length(X1)+1:end));
        meanOfdiffOfY1Y2(i) = mean(Y1(i,:)) - mean(Y2(i,:));
    end
    % We calculate the p value
    p2 = (1+sum(meanOfdiffOfY1Y2 >= originalDiffOfMeans))/(B+1);

end

    


