% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function for exercise 7


function [adjR2Max , Index] = Group10Exe7Fun1(x, y, xName, xNameP, yName)
    
    % Remove NaN values
    xAndY = [x, y];  
    xAndYNotNan = rmmissing(xAndY);
    x= xAndYNotNan(:,1);
    y= xAndYNotNan(:,2);

       
    %% 1st degree polynomial model  
    
    yModelStruct1 = fitlm(x, y, 'RobustOpts', 'ols');
    yModel1 = yModelStruct1.Fitted;
    adjR2_1 = yModelStruct1.Rsquared.Adjusted;

    [xSorted,I] =sort(x);
    Y = yModel1(I);
    
    figure();
    ax = subplot(2,3,1);
    dotSize = 15;
    scatter(x, y, dotSize, 'filled');
    hold on;
    title('1st degree polynomial (linear) model');
    plot(xSorted, Y, 'Color', 'r', 'LineWidth', 1.5);
    xlabel(xName);
    ylabel(yName);
    annotationFontSize = 12;
    posArr = ax.InnerPosition;
    [xOffset, yOffset] = deal(0.1, 0.14);
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
    
    X  =[x, x.^2];
    yModelStruct2 = fitlm(X, y, 'RobustOpts', 'ols');
    yModel2 = yModelStruct2.Fitted;
    adjR2_2 = yModelStruct2.Rsquared.Adjusted;

    Y = yModel2(I);
    
    ax = subplot(2,3,2);
    scatter(x, y, dotSize, 'filled');
    hold on;
    title('2nd degree polynomial model');
    plot(xSorted, Y, 'Color', 'r', 'LineWidth', 1.5);
    xlabel(xName);
    ylabel(yName);
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
    
    X  =[x, x.^2, x.^3];

    yModelStruct3 = fitlm(X, y, 'RobustOpts', 'ols');
    yModel3 = yModelStruct3.Fitted;
    adjR2_3 = yModelStruct3.Rsquared.Adjusted;

    ax=subplot(2,3,3);
    scatter(x, y, dotSize, 'filled');
    hold on;
    
    Y = yModel3(I);   
    plot(xSorted, Y, 'Color', 'r', 'LineWidth', 1.5);
    xlabel(xName);
    ylabel(yName);
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


    bTransformed = yModelStructTransformed.Coefficients.Estimate;
    b = bTransformed;
    b(1) = exp(bTransformed(1));


    yModel = b(1).*xNonZeros.^b(2);
    [xSorted,I] =sort(xNonZeros);

    for i=1:length(I)
        Y1(i)=yModel(I(i));
    end


    adjR2_4=1-((length(yNonZeros)-1)/(length(yNonZeros)-2))*((sum((yNonZeros-yModel).^2)/sum((yNonZeros-mean(yNonZeros)).^2)));
    

    ax = subplot(2,3,4);
    scatter(x, y, dotSize, 'filled');
    xlabel(xName);
    ylabel(yName);
    hold on;
    plot(xSorted, Y1, 'Color', 'r', 'LineWidth', 1.5);
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
    [xSorted, I] =sort(xNonZeros);
    for i =1:length(xNonZeros)
        yModel(i) = b(1)+b(2)/xNonZeros(i);
    end
    for i=1:length(I)
        Y2(i) =yModel(I(i));
    end
    adjR2_5=1-((length(yNonZeros)-1)/(length(yNonZeros)-2))*((sum((yNonZeros-yModel).^2)/sum((yNonZeros-mean(yNonZeros)).^2)));


    ax = subplot(2,3,5);
    scatter(x, y, dotSize, 'filled');
    title('Instrinsically linear logarithmic model');
    hold on;
    plot(xSorted, Y2, 'Color', 'r', 'LineWidth', 1.5);
    xlabel(xName);
    ylabel(yName);

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

    %% Exponential intrinsically linear model

    xNonZeros = x;
    yNonZeros = y;

    yNonZeros = yNonZeros(yNonZeros~=0);  %Removing values where y=0
    xNonZeros = xNonZeros(yNonZeros~=0);


    for i=1:length(xNonZeros)
        yTransformed(i) = log(yNonZeros(i));
    end

    yModelStructTransformed = fitlm(xNonZeros, yTransformed, 'RobustOpts', 'ols');

    % Revert back to the linear model by changing the coefficients
    bTransformed = yModelStructTransformed.Coefficients.Estimate;
    b = bTransformed;
    b(1) = exp(bTransformed(1));

    [xSorted, I] =sort(x);
    for i=1:length(x)
        yModel(i) = b(1)*exp(b(2)*x(i));
    end
    for i=1:length(I)
        Y(i) =yModel(I(i));
    end

    adjR2_6=1-((length(y)-1)/(length(y)-2))*((sum((y-yModel).^2)/sum((y-mean(y)).^2)));


    ax = subplot(2,3,6);
    scatter(x, y, dotSize, 'filled');
    title('Intrinsically linear exponential model');
    hold on;
    plot(xSorted, Y, 'Color', 'r', 'LineWidth', 1.5);
    xlabel(xName);
    ylabel(yName);
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
    
    

