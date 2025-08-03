% Stelios Topalidis
% AEM: 9613
% Exercise 2.5

clear;
clc;

%sigma = sqrt(variance) = 0.1
[mu, sigma] = deal(4, 0.1);
rejectionLength = 3.9;
rejectProbability = normcdf(rejectionLength, mu, sigma);
requestedRejectionRate = 0.01;
% Length threashold above which the girder is accepted 
xThreashold = norminv(requestedRejectionRate, mu, sigma);

fprintf(['The probability of a steel girder to be',...
   ' rejected for being under %.1f m long is: %0.2f%%\n\n'],...
   rejectionLength, rejectProbability*100);

fprintf(['The requested %.1f%% rejection rate needs a steel ', ...
    'girder length threshold of: %0.2f m\n'], ...
    requestedRejectionRate*100, xThreashold);
