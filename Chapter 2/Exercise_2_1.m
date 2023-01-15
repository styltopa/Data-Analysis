% Stelios Topalidis
% AEM: 9613
% Exercise 2.1

clc;
clear;

nmin = 10;
n_step = 100;
nmax = 10000;
n_range = nmin:n_step:nmax;

frequencyForAllN = -1*ones(length(n_range), 1);


indexCounter = 1;
for n = n_range
    v = rand(n, 1);
    frequencyForAllN(indexCounter) =  calculateNumberOfZeros(v)/n;
    indexCounter = indexCounter + 1;
    %     disp(zerosProportionForVariousN);
end

figure(1);
plot(transpose(n_range), frequencyForAllN)
xlim([nmin nmax])
% the relative frequency of tails -zeros- is between 0.3 and 0.7 in most
% cases
ylim([0.3 0.7])

% returns the number of zeros of a nx1 vector
function numOfZeros = calculateNumberOfZeros(v)
	n = length(v);
    numOfZeros = 0; % For the exercise 2.1 tails correspond to value 0 
    for i = 1:n
        if v(i) <= 0.5
            numOfZeros = numOfZeros + 1;
        end
    end
end
