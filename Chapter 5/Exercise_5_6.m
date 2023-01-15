% Stelios Topalidis
% AEM: 9613
% Exercise 5.6

clc;
clear;
close all;

% import data

% distance
d = [2, 3, 8, 16, 32, 48, 64, 80];
% usability percent
up = [98.2, 91.7, 81.3, 64.0, 36.4, 32.6, 17.1, 11.3];

% distance value to predict the usability percentage
dValToPredUp =  25;

%% (a)
%% Linear
% Plot both the data and the model
figure(1)
dotSize = 25;
scatter(d, up, dotSize, 'filled');
title({'Scatter diagram of usability percent to the distance traveled';...
    'Model fitting the data: Linear'});
xlabel('Distance (x1000 km)');
ylabel('Usability percentage (%)');
hold on;

%% Models used
%% LinearModel: up = b0 + b1*d
covMat = cov(d, up);
dUpCov = covMat(1, 2);
b1 = dUpCov/var(d);
b0 = mean(up) - b1.*mean(d);
plot(d, b0 + b1*d);
fprintf('(b)\nLinear model: up = b0 + b1*d = %.2f + (%.2f) * d\n', b0, b1);
hold off;

figure(2)
errors = up - (b0 + b1*d);
% normalised errors
errorsNorm = errors/std(errors);
% diagnostic plot: normalised errors against the actual values of usability
% percentage
scatter(up, errorsNorm, dotSize, 'filled');
xlabel('Usability percentage (%)');
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex',...
    'FontSize', 15);
title({'Diagnostic plot: normalised errors of the model'; 'Linear'});

yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k')
ymin = -3;
ymax = 3;
ylim([ymin, ymax]);

% usability percentage prediction based on the linear model
linUpPred = (b0 + b1*dValToPredUp);
fprintf('Prediction of usability for %d km: %.2f%%\n\n', dValToPredUp,...
    linUpPred);


%% Exponential model: up = a*e^(b*d) 

% Plot both the data and the model
figure(3);
scatter(d, up, dotSize, 'filled');
title({'Scatter diagram of usability percent to the distance traveled';...
    'Model fitting the data: Exponential'});
xlabel('Distance (x1000 km)');
ylabel('Usability percentage (%)');
hold on;

% Transform the data to the assumed linear relation to one another 
% Calculate the model parameters
upTransformed = log(up);
dTransformed = d;

% Fit the linear model to the linearized data
% Find the transformed parameters
covMat = cov(dTransformed, upTransformed);
dUpCov = covMat(1, 2);
bTransformed = dUpCov/var(dTransformed);
% Linear model: y' = aTransformed + bTransformed*x
aTransformed = mean(upTransformed) - bTransformed*mean(dTransformed);

% Inverse transform back to the original data and the original
% parameters
a = exp(aTransformed);
b = bTransformed;
plot(d, a*exp(b*d));
fprintf('Exponential model: up = a*e^(b) = %.2f * e^(%.2f*d) \n', a, b);
hold off;

% Normalised errors and corresponding scatter diagram
% (normalised error diagnonstics plot)
errors = up - a*exp(b*d);
% normalised errors
errorsNorm = errors/std(errors);
% diagnostic plot: normalised errors against the actual values of usability
% percentage
figure(4);
scatter(up, errorsNorm, dotSize, 'filled');
xlabel('Usability percentage (%)');
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex',...
    'FontSize', 15);
title({'Diagnostic plot: normalised errors of the model'; 'Exponential'});

yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k')
ymin = -3;
ymax = 3;
ylim([ymin, ymax]);


% usability percentage prediction based on the exponential model
expUpPred = a*exp(b*dValToPredUp);
fprintf('Prediction of usability for %d km: %.2f%%\n\n', dValToPredUp,...
    expUpPred);

% %% Power law model: up = a*(d^b): Issue: how to handle negative values of
% %% a?
% figure(5);
% scatter(d, up, dotSize, 'filled');
% title({['Scatter diagram between the distance traveled and the ',...
%     'usability']; 'Model fitting the data: power law'});
% xlabel('Distance traveled (x1000 km)');
% ylabel('Usability percentage (%)');
% hold on;
% 
% % Calculate the model
% 
% % Transform the data and the parameters in an attempt to linearize it
% dTransformed = log(d);
% upTransformed = log(up);
% covMat = cov(dTransformed, upTransformed);
% dUpCov = covMat(1, 2);
% bTransformed = dUpCov/var(dTransformed);
% aTransformed = mean(upTransformed) - bTransformed*mean(dTransformed);
% 
% b = bTransformed;
% bPos = -b;
% a = bPos.^aTransformed;
% % disp(a);
% % plot(d, 200*d.^(-0.45));
% plot(d, a.*(d.^bPos));
% hold off;
% 
% % make notes/remarks on the suitability of the linear model based on the
% % diagnostics diagram (should be stationary for all values of the
% % independent variable)

%% Log linear: up = a + b*log(d)

% Plot both the data and the model
figure(7);
scatter(d, up, dotSize, 'filled');
title({'Scatter diagram of usability percent to the distance traveled';...
    'Model fitting the data: Log linear'});
xlabel('Distance (x1000 km)');
ylabel('Usability percentage (%)');
hold on;

% Transform the data to the assumed linear relation to one another 
% Calculate the model parameters
upTransformed = up;
dTransformed = log(d);

% Fit the linear model to the linearized data
% Find the transformed parameters
covMat = cov(dTransformed, upTransformed);
dUpCov = covMat(1, 2);
bTransformed = dUpCov/var(dTransformed);
% Linear model: y' = aTransformed + bTransformed*x
aTransformed = mean(upTransformed) - bTransformed*mean(dTransformed);

% Inverse transform back to the original data and the original
% parameters
a = aTransformed;
b = bTransformed;   
plot(d, a+b*log(d));
fprintf('Log linear model: up = a + b*log(d) = %.2f + %.2f*log(d)\n',a, b);
hold off;

% Normalised errors and corresponding scatter diagram
% (normalised error diagnonstics plot)
errors = up - (a + b*log(d));
% normalised errors
errorsNorm = errors/std(errors);
% diagnostic plot: normalised errors against the actual values of usability
% percentage
figure(8);
scatter(up, errorsNorm, dotSize, 'filled');
xlabel('Usability percentage (%)');
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex',...
    'FontSize', 15);
title({'Diagnostic plot: normalised errors of the model'; 'Log Linear'});

yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k')
ymin = -3;
ymax = 3;
ylim([ymin, ymax]);



% usability percentage prediction based on the log linear model
logLinUpPred = (a + b*log(dValToPredUp));
fprintf('Prediction of usability for %d km: %.2f%%\n\n', dValToPredUp,...
    logLinUpPred);

%% Inverse: up = a + b*(1/d)

% Plot both the data and the model
figure(9);
scatter(d, up, dotSize, 'filled');
title({'Scatter diagram of usability percent to the distance traveled';...
    'Model fitting the data: Inverse'});
xlabel('Distance (x1000 km)');
ylabel('Usability percentage (%)');
hold on;

% Transform the data to the assumed linear relation to one another 
% Calculate the model parameters
upTransformed = up;
dTransformed = 1./d;

% Fit the linear model to the linearized data
% Find the transformed parameters
covMat = cov(dTransformed, upTransformed);
dUpCov = covMat(1, 2);
bTransformed = dUpCov/var(dTransformed);
% Linear model: y' = aTransformed + bTransformed*x
aTransformed = mean(upTransformed) - bTransformed*mean(dTransformed);

% Inverse transform back to the original data and the original
% parameters
a = aTransformed;
b = bTransformed;   
plot(d, a+b*(1./d));
fprintf('Inverse model: up = a + b*(1/d) = %.2f + %.2f*(1/d)\n',a, b);
hold off;

% Normalised errors and corresponding scatter diagram
% (normalised error diagnonstics plot)
errors = up - (a + b*(1./d));
% normalised errors
errorsNorm = errors/std(errors);
% diagnostic plot: normalised errors against the actual values of usability
% percentage
figure(10);
scatter(up, errorsNorm, dotSize, 'filled');
xlabel('Usability percentage (%)');
ylabel('Normalised errors $e_i^*$', 'interpreter', 'latex',...
    'FontSize', 15);
title({'Diagnostic plot: normalised errors of the model'; 'Inverse'});

yline(0, '-', 'Color', 'k');
yline([-2, 2], '--', 'Color', 'k')
ymin = -3;
ymax = 3;
ylim([ymin, ymax]);


% usability percentage prediction based on the linear model
invUpPred = a + b*(1/dValToPredUp);
fprintf('Prediction of usability for %d km: %.2f%%\n\n', dValToPredUp,...
    invUpPred);

% Notes
% The diagnostic plot of the exponential model seems to be the one that is
% the most centered around zero and not dependent on the actual values of 
% usability percentage (horizontal axis)