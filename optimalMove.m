territoriesBattle = find(territory.attackTerritories | territory.defendTerritories);
S_0 = territory.armies(territoriesBattle).'; % initial configuration
moves = movesMatrix(territoriesBattle,territoriesBattle);

[allStates,allStatesEnum,transientStatesEnum,terminalStatesEnum,allInputs,P,G] = createGraph(S_0,moves); % create the dynamic programing problem
[optimalAttack,optimalAttackEnum,optimalJ,exitflag] = solveSDP(P,G,transientStatesEnum,allInputs); % solve the dynamic programming problem

%% compute leftover attacker and defender armies' mean and variance
% compute the transtion matrix (i.e. Markov chain) resulting from using the optimal strategy
clearvars Popt;
for i = 1:numel(transientStatesEnum)
        Popt(transientStatesEnum(i),:) = P{optimalAttackEnum(i)}(transientStatesEnum(i),:);
        Gopt(transientStatesEnum(i)) = G(transientStatesEnum(i),optimalAttackEnum(i));
end
Popt(end+1:numel(allStatesEnum),:) = 0; % fill in for any leftover terminal states
Popt(terminalStatesEnum,terminalStatesEnum) = eye(numel(terminalStatesEnum)); % terminal states loop back to themselves
convergedPopt = Popt^100; % stationnary distribution
% ----- attacker and defender costs for each state
GoptDefender = zeros(numel(allStatesEnum),1);
GoptAttacker = zeros(numel(allStatesEnum),1);
for i = terminalStatesEnum.'
    GoptDefender(i) = -sum(allStates(i,allStates(i,:)<0));
    GoptAttacker(i) = sum(allStates(i,allStates(i,:)>0));
end
% ----- stratic disctribution
staticDistribution = convergedPopt(transientStatesEnum,:);
% ----- leftover defender army mean
defenderLeftoverMean = staticDistribution*GoptDefender;
% ----- leftover attacker army mean
attackerLeftoverMean = staticDistribution*GoptAttacker;
% ----- leftover defender army variance
defenderLeftoverVariance = staticDistribution*GoptDefender.^2-defenderLeftoverMean.^2;
% ----- leftover attacker army variance
attackerLeftoverVariance = staticDistribution*GoptAttacker.^2-attackerLeftoverMean.^2;