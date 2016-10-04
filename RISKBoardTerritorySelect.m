function RISKBoardTerritorySelect(src,callbackdata,fields)
territory = evalin('base','territory');

mouse_x = callbackdata.IntersectionPoint(1);
mouse_y = callbackdata.IntersectionPoint(2);
for i = 1:42
    if inpolygon(mouse_x,mouse_y,territory.border.(fields{i}).x,territory.border.(fields{i}).y)
        selectedTerritory = i;
        break;
    end
end

if exist('selectedTerritory','var')
    if territory.armies(selectedTerritory)>0 % attacker (my) territory selected
        territory.attackTerritories(selectedTerritory) = ~territory.attackTerritories(selectedTerritory);
        territory.defendTerritories(selectedTerritory) = false;
    elseif territory.armies(selectedTerritory)<0 % defender (opponent) territory selected
        territory.defendTerritories(selectedTerritory) = ~territory.defendTerritories(selectedTerritory);
        territory.attackTerritories(selectedTerritory) = false;
    else
        error(['Territory cannot have zero armies! Assign a non-zero amount of armies on the game board to ' fields{selectedTerritory}]);
    end
    % color the territory accordingly
    evalin('base',['set(attackTerritoriesHighlight(' num2str(selectedTerritory) '),''facealpha'',' num2str(0.5*territory.attackTerritories(selectedTerritory)) ');']);
    evalin('base',['set(defendTerritoriesHighlight(' num2str(selectedTerritory) '),''facealpha'',' num2str(0.5*territory.defendTerritories(selectedTerritory)) ');']);
end
assignin('base','territory',territory);