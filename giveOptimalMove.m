battleStateNow = territory.armies(territory.attackTerritories | territory.defendTerritories).'; % current state of battle
[~,stateNowEnum] = ismember(battleStateNow,allStates(transientStatesEnum,:),'rows');
if stateNowEnum % a matching state foudn for which optimal solution exists
    optimalMoveNow = optimalAttack(stateNowEnum,:);
    fprintf(['Optimal move: attack ' fields{territoriesBattle(optimalMoveNow(3))} ' from ' fields{territoriesBattle(optimalMoveNow(2))} ' with ' num2str(optimalMoveNow(1)) ' dice\n']);
    fprintf(['\n'...
    '-----------------------------------------------------------------------------\n'...
    'Statistics\n'...
    '-----------------------------------------------------------------------------\n'...
    'Expected # defender armies before attack army depletion     |    %.4f\n'...
    'Variance in # defender armies before attack army depletion  |    %.4f\n'...
    '-----------------------------------------------------------------------------\n'],...
    optimalJ(stateNowEnum),0);
    % calcuation variance and show the distribution!!!!
    
    %% terminal state statistics plot
    figure(2); clf(figure(2));
    set(gcf,'Name','Battle Campaign Statistics','NumberTitle','off');
    % ---- attacker leftover armies plot
    subplot(211); hold on;
    xlabel('Number of armies');
    ylabel('PDF value');
    title('Gaussian representation of terminal army distribution');
    subplot(211);
    attackMean = attackerLeftoverMean(stateNowEnum);
    attackStdDev = sqrt(attackerLeftoverVariance(stateNowEnum));
    attackerX = max(1,attackMean-4*attackStdDev):0.01:(attackMean+4*attackStdDev);
    attackerBellCurve = normpdf(attackerX,attackMean,attackStdDev);
    attackerLeftoverPlot = plot(attackerX,attackerBellCurve,'color','green');
    % ---- defender leftover armies plot
    defendMean = defenderLeftoverMean(stateNowEnum);
    defendStdDev = sqrt(defenderLeftoverVariance(stateNowEnum));
    defenderX = max(0,defendMean-4*defendStdDev):0.01:(defendMean+4*defendStdDev);
    defenderBellCurve = normpdf(defenderX,defendMean,defendStdDev);
    defenderLeftoverPlot = plot(defenderX,defenderBellCurve,'color','red');
    xlim([min([attackerX(1) defenderX(1)]) max([attackerX(end) defenderX(end)])]);
    % ---- actual end results probability bar plot
    subplot(212);
    possibleTerminalStates = allStates(staticDistribution(stateNowEnum,:)~=0,:);
    [possibleTerminalStatesProbabilities,idxSort] = sort(full(staticDistribution(stateNowEnum,staticDistribution(stateNowEnum,:)~=0).'),'descend');
    possibleTerminalStates = possibleTerminalStates(idxSort,:);
    xValues = 1:size(possibleTerminalStates,1);
    endResultBarPlot = bar(xValues,possibleTerminalStatesProbabilities*100);
    ytickformat('percentage');
    ylabel('Probability');
    xlabel('Army combination (negative for defenders)');
    xtickangle(90);
    grid on;
    xlim([0 xValues(end)+1]);
    set(gca,'TickLength',[0 0]);
    % create xtick labels
    xLabels = reshape(cellstr(num2str(possibleTerminalStates(:))),size(possibleTerminalStates,1),size(possibleTerminalStates,2));
    for i = 1:size(xLabels,2)-1
        xLabels(:,i) = strcat(xLabels(:,i),{','});
    end
    while size(xLabels,2)~=1
        xLabels = [strcat(xLabels(:,1),xLabels(:,2)) xLabels(:,3:end)];
    end
    xticks(xValues);
    xticklabels(xLabels);
    % make title
    territoryLegend = 'Territory ';
    for i = 1:numel(territoriesBattle)
        territoryLegend = [territoryLegend num2str(i) ': ' fields{territoriesBattle(i)} ', '];
    end
    territoryLegend = territoryLegend(1:end-2);
    title({'Probability disitribution of temrinal states', territoryLegend});
    
    %% statistics plot of how many territories attacker (me) might take over and how many armies I can expect to have remaining
    figure(3); clf(figure(3));
    set(gcf,'Name','Territory Capture Statistics','NumberTitle','off');
    totalDefendTerritories = numel(find(territory.defendTerritories));
    totalAttackTerritories = numel(find(territory.attackTerritories));
    for i = 0:totalDefendTerritories
        % statistics for i territories captured by attacker
        correspondingTerminalStates = sum(possibleTerminalStates>0,2);
        correspondingTerminalStates = find(correspondingTerminalStates==totalAttackTerritories+i);
        correspondingProbabilities = possibleTerminalStatesProbabilities(correspondingTerminalStates);
        numAttackingArmiesLeft = possibleTerminalStates(correspondingTerminalStates,:);
        numAttackingArmiesLeft(numAttackingArmiesLeft<0) = 0;
        numAttackingArmiesLeft = sum(numAttackingArmiesLeft,2);
        numAttackingArmiesLeftUnique = unique(numAttackingArmiesLeft,'stable');
        [~,lib] = ismember(numAttackingArmiesLeft,numAttackingArmiesLeftUnique);
        numAttackingArmiesLeftUniqueProbability = zeros(numel(numAttackingArmiesLeftUnique),1);
        for j = 1:numel(numAttackingArmiesLeftUnique)
            numAttackingArmiesLeftUniqueProbability(j) = sum(correspondingProbabilities(lib==j));
        end
        [numAttackingArmiesLeftUniqueProbability,idxSort] = sort(numAttackingArmiesLeftUniqueProbability,'descend');
        numAttackingArmiesLeftUnique = numAttackingArmiesLeftUnique(idxSort);
        
        subplot(totalDefendTerritories+1,1,i+1);
        xValues = 1:numel(numAttackingArmiesLeftUnique);
        bar(xValues,numAttackingArmiesLeftUniqueProbability*100);
        xticklabels(numAttackingArmiesLeftUnique);
        ytickformat('percentage');
        ylabel('Probability');
        title(sprintf('%d territories captured, probability: %.2f%%',i,sum(numAttackingArmiesLeftUniqueProbability)*100));
        xlim([0 numel(numAttackingArmiesLeftUnique)+1]);
        grid on;
        set(gca,'TickLength',[0 0]);
    end
    xlabel('Number of attacker armies left');
else
    error('No matching state found for which an optimal solution exists');
end