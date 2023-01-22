

function [pA, pB, pC, pD] = logtranstest9613(X, Y)
    %% (a) 
    [~, pA] = ttest2(X, Y);

    %% (b) 
    logX = log(X);
    logY = log(Y);
    [~, pB] = ttest2(logX, logY);

    %% (c) 
    B = 1000;
    originalMeanX = mean(X);
    originalMeanY = mean(Y);
    originalDiffOfMeans = originalMeanX - originalMeanY;
    bootMeanX = bootstrp(B, @mean, X);
    bootMeanY = bootstrp(B, @mean, Y);
    bootDiffOfMeans = bootMeanX - bootMeanY;
    bootDiffOfMeansSorted = sort([bootDiffOfMeans; originalDiffOfMeans]);
    rankOriginal = find(bootDiffOfMeansSorted == originalDiffOfMeans);
    rankMedian = find(bootDiffOfMeansSorted == median(bootDiffOfMeansSorted));

    if rankOriginal <= rankMedian 
        pC = 2*(rankOriginal/(B+1));
    elseif rankOriginal > rankMedian 
        pC = 2*(1 - rankOriginal/(B+1));
    end

    %% (d)
    % changing the arguments of the bootstrap 
    originalMeanX = mean(logX);
    originalMeanY = mean(logY);
    originalDiffOfMeans = originalMeanX - originalMeanY;
    % changing the arguments of the bootstrap 
    bootMeanX = bootstrp(B, @mean, logX);
    bootMeanY = bootstrp(B, @mean, logY);
    bootDiffOfMeans = bootMeanX - bootMeanY;
    bootDiffOfMeansSorted = sort([bootDiffOfMeans; originalDiffOfMeans]);
    rankOriginal = find(bootDiffOfMeansSorted == originalDiffOfMeans);
    rankMedian = find(bootDiffOfMeansSorted == median(bootDiffOfMeansSorted));

    if rankOriginal <= rankMedian 
        pD = 2*(rankOriginal/(B+1));
    elseif rankOriginal > rankMedian 
        pD = 2*(1 - rankOriginal/(B+1));
    end
end