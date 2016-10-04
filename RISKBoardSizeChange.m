function RISKBoardSizeChange(src,callbackdata,territory,fields)
% change the position (from bottom left corner of figure) of the ui elements
figurePos = src.Position;
figureWidth = figurePos(3);
figureHeight = figurePos(4);
armyUIControl = evalin('base','armyUIControl');
territoryOwnerUIControl = evalin('base','territoryOwnerUIControl');
for i = 1:42
    set(armyUIControl(i),'Position',[territory.center.(fields{i}).x/3701*figureWidth territory.center.(fields{i}).y/2446*figureHeight 30 15]);
    set(territoryOwnerUIControl(i),'Position',[territory.center.(fields{i}).x/3701*figureWidth+30 territory.center.(fields{i}).y/2446*figureHeight 15 15]);
end
assignin('base','armyUIControl',armyUIControl);
assignin('base','territoryOwnerUIControl',territoryOwnerUIControl);