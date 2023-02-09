% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM: 9516
% Project for academic year 2022-2023
% Function for exercise 6


function R2 = Group10Exe6Fun1(x, y, xName, yName, xNameP, ax)
    %% (a) Remove Nan pair values
    
    % namesPeriphrastically = [Mean annual tempearature
    xAndY = [x, y];
    xAndYNotNan = rmmissing(xAndY);
    [x, y] = deal(xAndYNotNan(:, 1), xAndYNotNan(:, 2));
    
    
    %% (b) Fit linear model and calculate R^2
    % fit linear model on the first variable using the ordinary least squares
    % method.
    yModelStruct = fitlm(x, y, 'RobustOpts', 'ols');
    yModel = yModelStruct.Fitted;

    %% (d) R^2 is returned
    R2 = yModelStruct.Rsquared.Ordinary;
    
    %% (c) Scatter diagram, fitted line on the independent variable and R^2 
    %% shown on plot

    dotSize = 15;
    scatter(x, y, dotSize, 'filled');
    % the title regards the independent variable (horizontal axis)
    title({xNameP + " (" + xName + ")"});    
    xlabel(xName);
    ylabel(yName);
    hold on;
    plot(x, yModel, 'Color', 'r', 'LineWidth', 1.5);
      
    annotationFontSize = 12;
    posArr = ax.InnerPosition;
    xOffset = 0.1;
    yOffset = 0.05;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
        posArr(2) + posArr(4) - yOffset, 0.1 ,0.1); 
    annotPosAndDims = [posX, posY, width, height];
    annotation('textbox', annotPosAndDims, 'String', ...
        {"$R^2$: "+ R2}, ...
        'interpreter', 'latex', ...
        'FontSize', ...
        annotationFontSize);
    hold off
end



