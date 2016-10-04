% General a plot of the movesMatrix, i.e. rows are strating territories and
% columns are colors black when the territory of the column can be moved to
% from the starting territory

fields = fieldnames(territory.num);

figure(2); clf(figure(2));
[r,c] = size(movesMatrix);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,movesMatrix);            %# Plot the image
colormap(flipud(gray));                              %# Use inverted gray colormap
axis equal                                   %# Make axes grid sizes equal
set(gca,'XTick',1:(c),'YTick',1:(r),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
set(gca,'YTickLabel',fields,'XTickLabel',fields);
xtickangle(45);
title('movesMatrix visualization, 0 is white and 1 is black');