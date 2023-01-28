% Stylianos Topalidis
% AEM: 9613
% Stamatios Charteros
% AEM:9516
% Project for academic year 2022-2023
% Function for exercise 6


function adjR2 = Group10Exe6Fun1(x, y, xName, yName, xNameP, yNameP, ax)
    %% (a) Remove Nan pair values
    
    % namesPeriphrastically = [Mean annual tempearature
    xAndY = [x, y];
    xAndYNotNan = rmmissing(xAndY);
    [x, y] = deal(xAndYNotNan(:, 1), xAndYNotNan(:, 2));
    
    
    %% (b) Fit linear model and calculate adjR^2
    % fit linear model on the first variable using the ordinary least squares
    % method.
    yModelStruct = fitlm(x, y, 'RobustOpts', 'ols');
    yModel = yModelStruct.Fitted;

    %% (d) Adjusted R^2 is returned
    adjR2 = yModelStruct.Rsquared.Adjusted;

    %% (c) Scatter diagram, fitted line on the independent variable and adjR^2 
    %% shown on plot

    dotSize = 15;
    scatter(x, y, dotSize, 'filled');
    % the title regards the independent variable (horizontal axis)
    title({xNameP + " (" + xName + ")"});    
    xlabel(xName);
    ylabel(yName);
    hold on;
    plot(x, yModel, 'Color', 'r', 'LineWidth', 1.5);
    
%     xlim(xlim+[-10,10]);ylim(ylim+[-10,10]);%use xlim and ylim to fix location
%     text(min(xlim), max(ylim),subPlotNames(i), 'Horiz','left', 'Vert','top')
%     
    annotationFontSize = 12;
    [posX, posY, width, height] = deal(0.65, 0.75, 0.1, 0.1); 
    annotPosAndDims = [posX, posY, width, height];
%     annotPosAndDims = [ax.xlim, ax.ylim];
    annotation('textbox', annotPosAndDims, 'String', ...
        {"$AdjR^2$: "+ adjR2}, ...
        'interpreter', 'latex', ...
        'FontSize', ...
        annotationFontSize);
    hold off
end



