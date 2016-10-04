function updateBoard(src,event,i)
territory = evalin('base','territory');
% determine this territory's number of armies and owner now
if strcmp(event.Source.Style,'edit') % number of armies edited
    territoryArmies = str2num(src.String);
    territoryOwner = evalin('base',['territoryOwnerUIControl(' num2str(i) ').Value']);
else % territory owner edited
    territoryArmies = str2num(evalin('base',['armyUIControl(' num2str(i) ').String']));
    territoryOwner = src.Value;
end
% update the territoy structure according to this new information
if territoryOwner % if this territory is mine
     territory.armies(i) = territoryArmies;
else
     territory.armies(i) = -territoryArmies; % opponent armies represented by negative value
end
assignin('base','territory',territory);