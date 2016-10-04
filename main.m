% Main file for the RISK optimal strategy advisor
%
% Author: Danylo Malyuta
% Version: 0.1 (September 2016)
%
% Changelog:
%       (v0.1) Original creation

%% Draw the map

if ~exist('boardFigure','var') || ~ishandle(1)
    boardFigure = figure(1); clf(figure(1));
end
img = imread('./board.png');       % Load the board image
boardImage = imagesc([0 3701], [0 2446], flipud(img)); % Flip the image upside down before showing it
set(gca,'ydir','normal');                 % Set the y-axis back to normal
set(gca,'xtick',[],'ytick',[],'Position',[0 0 1 1]);
set(gcf,'MenuBar','None');
set(gcf,'Name','RISK Game Board','NumberTitle','off');
hold on;

%% Setup map properties

[territory,movesMatrix] = createMovesMatrix;

%% Draw GUI elements

fields = fieldnames(territory.num);
clearvars armyUIControl territoryOwnerUIControl;
figurePos = get(gcf,'Position');
figureWidth = figurePos(3);
figureHeight = figurePos(4);
% create the controls of army size and owner of each territory
for i = 1:numel(fields)
    armyUIControl(i) = uicontrol(boardFigure,'Style','edit','String','0',...
                                 'Units','pixels','Position',[territory.center.(fields{i}).x/3701*figureWidth,...
                                 territory.center.(fields{i}).y/2446*figureHeight,30 15]);
    territoryOwnerUIControl(i) = uicontrol(boardFigure,'Style','checkbox','String','',...
                                           'Value',0,'Units','pixels','Position',[territory.center.(fields{i}).x/3701*figureWidth+30,...
                                           territory.center.(fields{i}).y/2446*figureHeight,15 15]);
end
% create callback functions for the above controls
for i =1:numel(fields)
    set(armyUIControl(i),'Callback',{@updateBoard,i});
    set(territoryOwnerUIControl(i),'Callback',{@updateBoard,i});
end
set(gcf,'SizeChangedFcn',{@RISKBoardSizeChange,territory,fields});

%% Setup the GUI attack/defend territory selection needed for dynamic programming

territory.attackTerritories = false(42,1);
territory.defendTerritories = false(42,1);
attackTerritoriesHighlight(1:42,1) = fill(0,0,'green'); % my territories
defendTerritoriesHighlight(1:42,1) = fill(0,0,'red'); % opponent territories
set(boardImage,'ButtonDownFcn',{@RISKBoardTerritorySelect,fields});
for i = 1:42
    attackTerritoriesHighlight(i) = fill(territory.border.(fields{i}).x,territory.border.(fields{i}).y,'green');
    set(attackTerritoriesHighlight(i),'edgecolor','none','facealpha',0);
    
    defendTerritoriesHighlight(i) = fill(territory.border.(fields{i}).x,territory.border.(fields{i}).y,'red');
    set(defendTerritoriesHighlight(i),'edgecolor','none','facealpha',0);
    
    set(attackTerritoriesHighlight(i),'ButtonDownFcn',{@RISKBoardTerritorySelect,fields});
    set(defendTerritoriesHighlight(i),'ButtonDownFcn',{@RISKBoardTerritorySelect,fields});
end