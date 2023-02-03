% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% 
% clc;
% clear;
% close all;
% 
% data = table2array(readtable('Heathrow.xlsx'));
% dataNamesStruct = importdata('Heathrow.xlsx');
% dataNames = string(dataNamesStruct.textdata.Sheet1);
% dataNamesPeriphrastic = {'Year', 'Mean annual temperature', ...
%         'Mean annual maximum temperature', 'Mean annual minimum temperature', ...
%         'Total annual rainfall or snowfall', 'Mean annual wind velocity', ...
%         'Number of days with rain', 'Number of days with snow', ...
%         'Number of days with wind', 'Number of days with fog', ...
%         'Number of days with tornado', 'Number of days with hail'};
% 
% models = string(["1st degree polynomial (linear) model", ...
%     "2nd degree polynomial model", "3rd degree polynomial model", ...
%     "Intrinsically linear power law model", ...
%     "Intrinsically linear logarithmic model", ...
%     "Intrinsically linear exponential model"]);
% 
% 
% % Feature index used to explain the fog variable
% xIndex = 3;
% % Days with fog per year
% yIndex = 10;
% fogData = data(:, yIndex); 
% featureIndexesMat = [2, 3, 4, 5, 6, 7, 8, 9, 12];
% fprintf('The best model for %s (%s):\n\n',...
%     dataNames(yIndex), string(dataNamesPeriphrastic(yIndex)));
%     
% for i = 1:length(featureIndexesMat)
%     
%     featureData = data(:, featureIndexesMat(i));
%     [adjR2Max , modelIndex] = kappa(featureData, fogData,...
%         dataNames(featureIndexesMat(i)), ...
%         dataNamesPeriphrastic(featureIndexesMat(i)));
%     fprintf(['Given the feature %s (%s)\n',...
%         'is the %s\n',...
%         'with adjR2 = %.4f\n\n'], ...
%         dataNames(featureIndexesMat(i)), ...
%         string(dataNamesPeriphrastic(featureIndexesMat(i))),...
%         models(modelIndex), adjR2Max);
% end


 
function[adjR2Max , Index] = Group10Exe7Fun1(x,y,xName,xNameP)
    
    % Remove NaN values
    xAndY = [x, y];  
    xAndYNotNan = rmmissing(xAndY);
    x= xAndYNotNan(:,1);
    y= xAndYNotNan(:,2);

       
    %% 1st degree polynomial model  
    
    yModelStruct1 = fitlm(x, y, 'RobustOpts', 'ols');
    yModel1 = yModelStruct1.Fitted;
    adjR2_1 = yModelStruct1.Rsquared.Adjusted;

    [X,I] =sort(x);
    Y = yModel1(I);
    
    figure();
    ax = subplot(2,3,1);
    dotSize = 15;
    scatter(x, y, dotSize, 'filled');
    hold on;
    title('1st degree polynomial (linear) model');
    plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
        
    annotationFontSize = 12;
    posArr = ax.InnerPosition;
    [xOffset, yOffset] = deal(0.1, 0.12);
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_1}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
    hold off;


    %% 2nd degree polynomial model
    
    x2  =[x, x.^2];
    yModelStruct2 = fitlm(x2, y, 'RobustOpts', 'ols');
    yModel2 = yModelStruct2.Fitted;
    adjR2_2 = yModelStruct2.Rsquared.Adjusted;

    Y = yModel2(I);
    
    ax = subplot(2,3,2);
    scatter(x, y, dotSize, 'filled');
    hold on;
    title('2nd degree polynomial model');
    plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
    
    posArr = ax.InnerPosition;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_2}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
	hold off;


    %% 3rd degree polynomial model 
    
    x3  =[x, x.^2, x.^3];

    yModelStruct3 = fitlm(x3, y, 'RobustOpts', 'ols');
    yModel3 = yModelStruct3.Fitted;
    adjR2_3 = yModelStruct3.Rsquared.Adjusted;

    ax=subplot(2,3,3);
    dotSize = 15;
    scatter(x, y, dotSize, 'filled');
    hold on;
    
    
    Y = yModel3(I);   
    plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);
    posArr = ax.InnerPosition;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_3}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
    title('3rd degree polynomial model')
    hold off;


    %% Intrinsically linear law of power model

    xNonZeros = x;
    yNonZeros = y;

    % Remove values where y = 0
    yNonZeros = yNonZeros(yNonZeros~=0);  
    xNonZeros = xNonZeros(yNonZeros~=0);

    % Remove values where x = 0
    yNonZeros = yNonZeros(xNonZeros~=0);  
    xNonZeros = xNonZeros(xNonZeros~=0);


    xTransformed = log(xNonZeros);
    yTransformed = log(yNonZeros);




    yModelStructTransformed = fitlm(xTransformed, yTransformed, ...
        'RobustOpts', 'ols');
    yModelTransformed = yModelStructTransformed.Fitted;


    bTransformed = yModelStructTransformed.Coefficients.Estimate;
    b = bTransformed;
    b(1) = exp(bTransformed(1));


    yModel = b(1).*xNonZeros.^b(2);
    [X,I] =sort(xNonZeros);

    for i=1:length(I)
    Y1(i)=yModel(I(i));
    end


%     adjR2_4=1-((length(y)-1)/(length(y)-2))*((sum((y-yModel).^2)/sum((y-mean(y)).^2)));
    adjR2_4=1-((length(yNonZeros)-1)/(length(yNonZeros)-2))*((sum((yNonZeros-yModel).^2)/sum((yNonZeros-mean(yNonZeros)).^2)));
    

    dotSize = 15;
    ax = subplot(2,3,4);
    scatter(x, y, dotSize, 'filled');

    hold on;
    plot(X,Y1, 'Color', 'r', 'LineWidth', 1.5);
    posArr = ax.InnerPosition;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_4}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
    title('Intrinsically linear power law model');
    hold off;
    %% Reversed Intrinsically linear model
    
    xNonZeros = x;
    yNonZeros = y;

    % Remove values where y = 0
    yNonZeros = yNonZeros(yNonZeros~=0);  
    xNonZeros = xNonZeros(yNonZeros~=0);

    % Remove values where x = 0
    yNonZeros = yNonZeros(xNonZeros~=0);  
    xNonZeros = xNonZeros(xNonZeros~=0);


    xTransformed = log(xNonZeros);
    yTransformed = log(yNonZeros);
    
    for i=1:length(xNonZeros)
        xTransformed(i)=1/xNonZeros(i);
    end
    yModelStructTransformed = fitlm(xTransformed, yNonZeros, 'RobustOpts', 'ols');


    % revert beck to the linear model by changing the coefficients
    b = yModelStructTransformed.Coefficients.Estimate; 
    [X, I] =sort(xNonZeros);
    for i =1:length(xNonZeros)
        yModel(i) = b(1)+b(2)/xNonZeros(i);
    end
    for i=1:length(I)
        Y2(i) =yModel(I(i));
    end
    adjR2_5=1-((length(yNonZeros)-1)/(length(yNonZeros)-2))*((sum((yNonZeros-yModel).^2)/sum((yNonZeros-mean(yNonZeros)).^2)));


    dotSize = 15;
    ax = subplot(2,3,5);
    scatter(x, y, dotSize, 'filled');
    title('Instrinsically linear logarithmic model');
    hold on;
    plot(X, Y2, 'Color', 'r', 'LineWidth', 1.5);

    posArr = ax.InnerPosition;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_5}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);

    hold off;

    %% Exponential Intrinsically linear model

    xNonZeros = x;
    yNonZeros = y;

    yNonZeros = yNonZeros(yNonZeros~=0);  %Removing values where y=0
    xNonZeros = xNonZeros(yNonZeros~=0);


    for i=1:length(xNonZeros)
        yTransformed(i) = log(yNonZeros(i));
    end

    yModelStructTransformed = fitlm(xNonZeros, yTransformed, 'RobustOpts', 'ols');
    yModelTransformed = yModelStructTransformed.Fitted;

    % revert beck to the linear model by changing the coefficients
    bTransformed = yModelStructTransformed.Coefficients.Estimate;
    b = bTransformed;
    b(1) = exp(bTransformed(1));

    [X, I] =sort(x);
    for i=1:length(x)
        yModel(i) = b(1)*exp(b(2)*x(i));
    end
    for i=1:length(I)
        Y(i) =yModel(I(i));
    end

    adjR2_6=1-((length(y)-1)/(length(y)-2))*((sum((y-yModel).^2)/sum((y-mean(y)).^2)));


    dotSize = 15;
    ax = subplot(2,3,6);
    scatter(x, y, dotSize, 'filled');
    title('Intrinsically linear exponential model');
    hold on;
    plot(X, Y, 'Color', 'r', 'LineWidth', 1.5);

    posArr = ax.InnerPosition;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
    posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
    {"$AdjR^2$: "+ adjR2_6}, ...
    'interpreter', 'latex', ...
    'FontSize', ...
    annotationFontSize);
    
    sgtitle("Model fitting data using feature " + ...
        string(xName) + " (" + string(xNameP) + ")", 'FontSize', 12);
    
    hold off;


    [adjR2Max,Index] = max([adjR2_1,adjR2_2,adjR2_3,adjR2_4,adjR2_5,adjR2_6]);
end
    
    

