close all;
clc;
clear;

n = 100;
m = 10;
totalLayouts = 1;

for numOfLayouts = 1:totalLayouts
    figure(numOfLayouts);
    tiledlayout(2, 2);
    sgtitle("Scatter diagrams " + num2str(numOfLayouts));

    for i = 1:4
        ax = nexttile;
        disp(ax.InnerPosition);
        x = rand(n, 1);
        y = rand(n, 1);
        returnSubplot(x, y, m, ax);
        title("Subplot " + num2str(i));
    end
end

function returnSubplot(x, y, m, ax)
    scatter(x, y);
    hold on;
    plot(x(1:m), y(1:m));
    hold off;
    adjR2 = rand(1,1);
    annotationFontSize = 12;
%     posArr = ax.OuterPosition;
    posArr = ax.InnerPosition;
    xOffset = 0.1;
    yOffset = 0.1;
    [posX, posY, width, height] = deal(posArr(1) + posArr(3) - xOffset, ...
        posArr(2) + posArr(4) - yOffset,...
        0.1 ,...
        0.1); 
    annotPosAndDims = [posX, posY, width, height];
%     annotPosAndDims = [ax.xlim, ax.ylim];
    annotation('textbox', annotPosAndDims, 'String', ...
        {"$AdjR^2$: "+ adjR2}, ...
        'interpreter', 'latex', ...
        'FontSize', ...
        annotationFontSize);
end


