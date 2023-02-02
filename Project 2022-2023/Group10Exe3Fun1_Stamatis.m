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

function[p1 , p2] = Group10Exe3Fun1(years , info)
%% (a)

discIndex = 0; % Point of discontinuity
%    we assume a single discontinuity point
for i=2:length(years)
    if years(i)>years(i-1)+1
        discIndex = i;
    end
end
%% (b)
B = 1000;
% Éf discIndex isnt 0 then the function continues
if discIndex ~= 0
    X1 = info(1:discIndex-1);
    X2 = info(discIndex:end);
    %we test if X1 and X2 are only filled with NaN values(if they are...
    %...we cant continue
    ISNAN1 = isnan( X1 );
    ISNAN2 = isnan( X2 );
    nan1 = 1;
    nan2 = 1;
    for i =1:length(ISNAN1)
        if ISNAN1(i) == 0
            nan1 = 0;
        end
    end
    for i =1:length(ISNAN2)
        if ISNAN2(i) == 0
            nan2 = 0;
        end
    end
    p1 = 10; %values p1,p2 that will be returned if the next if doesnt run
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
        %we create array X3 that contains all the values of both X1 and X2
        X3 = zeros(length(X1)+length(X2),1);
        X3(1:length(X1))=X1;
        X3(length(X1)+1:end)=X2;
        originalDiffOfMeans = mean(X1) - mean(X2);
        
        Y1 = NaN(B,length(X1));
        Y2 = NaN(B,length(X2));
        meanOfdiffOfY1Y2 = NaN(B,1);
        %we randomly split X3 into arrays Y1(with length of X1) and Y2(with
        %length of X2) each time we calculate the differnce of the means
        for i=1:B
            my_indices = randperm(length(X3));
            Y1(i,:) = X3(my_indices(1:length(X1)));
            Y2(i,:) = X3(my_indices(length(X1)+1:end));
            meanOfdiffOfY1Y2(i) = mean(Y1(i,:)) - mean(Y2(i,:));
        end
        %we calculate the p value
        p2 = (1+sum(meanOfdiffOfY1Y2 >= originalDiffOfMeans))/(B+1);
        
    end
else
    error("there must be a breaking point")
end

    


