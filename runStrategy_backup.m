function runStrategy(src,event,numArmies,myTerritory,territory,movesMatrix)
%% Highlight in green my territories
myTerritories_highlight = evalin('base','myTerritories_highlight');
 delete(myTerritories_highlight);
fields = fieldnames(territory.num);
for i = 1:numel(fields)
    if myTerritory(i).Value
        myTerritories_highlight(i) = fill(territory.border.(fields{i}).x,territory.border.(fields{i}).y,'green');
        set(myTerritories_highlight(i),'edgecolor','none','facealpha',0.5);
    end
end
assignin('base','myTerritories_highlight',myTerritories_highlight);

%% Construct matrix of territories that I can attack
attackMatrix = movesMatrix;
for j = 1:42 % columns
    if myTerritory(j).Value
        attackMatrix(:,j) = 0; % cannot attack my own territoty
    end
end
assignin('base','attackMatrix',attackMatrix);