function [allStates,allStatesEnum,transientStatesEnum,terminalStatesEnum,allInputs,P,G] = createGraph(S_0,moves)
fprintf('Creating transition probability matrix P\n');
% create the state graph (i.e. the Markov chain)
allStates = S_0; % vector holding all possible states
allInputs = zeros(0,3); % vector holding all possible inputs
P{1} = sparse(0,0); % transition probability matrix (sparse to save memory, ndSparse class used since 3-dimensional)
stateCounter = 1; % counter of which transient state we're on
probability = calculateTransitionProbabilities; % calculate the probabilities for all possible battle outcomes
%% simulate to obtain all the possible states and inputs
while stateCounter<=size(allStates,1)
    xInitial = allStates(stateCounter,:);
    defenders = find(xInitial<0);
    attackers = find(xInitial>0);
    newStates = [];
    newInputs = [];
    newTransitionProbabilities = [];
    for i = 1:numel(attackers)
        for j = 1:numel(defenders)
            k = attackers(i); % attacking territory number
            l = defenders(j); % defending territory number
            if moves(k,l) % defending territory can be attacked from attacking territory (i.e. they are connected)
                numAttackers = xInitial(k); % number of armies in attacking territory
                numDefenders = -xInitial(l); % number of armies in defending territory
                % assume: if defending territory has >=2 armies, it'll use 2 armies to defend (i.e. max possible)
                if numAttackers>3 % attacker choses to throw 3 dice
                    [newStates,newInputs,newTransitionProbabilities] = playBattle(newStates,newInputs,newTransitionProbabilities,probability,xInitial,k,l,3,min(2,numDefenders));
                end
                if numAttackers>=3 % attacker choses to throw 2 dice
                    [newStates,newInputs,newTransitionProbabilities] = playBattle(newStates,newInputs,newTransitionProbabilities,probability,xInitial,k,l,2,min(2,numDefenders));
                end
                if numAttackers>=2 % attacker choses to throw 1 dice
                    [newStates,newInputs,newTransitionProbabilities] = playBattle(newStates,newInputs,newTransitionProbabilities,probability,xInitial,k,l,1,min(2,numDefenders));
                end
            end
        end
    end
    % integrate these new states with the previously discovered possible states
    if ~isempty(newStates) % satisfied if xInitial is not a terminal state
        [allStates,newStatesEnum] = removeDuplicates(newStates,allStates); % remove duplicates in newly discovered states
        [allInputs,newInputsEnum] = removeDuplicates(newInputs,allInputs); % remove duplicates in newly discovered inputs
        % update the transition probability matrix
        for u = 1:numel(newInputsEnum)
            if newInputsEnum(u)>numel(P) % make any new layer sparse!
                P{newInputsEnum(u)} = sparse(0,0);
            end
            P{newInputsEnum(u)}(stateCounter,newStatesEnum(u)) = newTransitionProbabilities(u);
        end
    else
        for u = 1:numel(P)
            P{u}(stateCounter,:) = 0;
        end
    end
    % continue on to explore the next state
    stateCounter = stateCounter+1;
end
allStatesEnum = (1:size(allStates,1)).'; % enumerated states (1,2,...,N) where N total number of possible states
for u = 1:numel(P) % make all P layers square
    P{u}(:,end+1:size(allStates,1)) = 0;
end
%% create stage cost matrix G (based on strategy choice)
fprintf('Creating stage cost matrix G\n');
sumP = P{1};
for u = 2:numel(P)
    sumP = sumP+P{u};
end
terminalStatesEnum = find(~sum(sumP,2)); % enumerated values of the terminal states (all those that have no states to transition to next)
transientStatesEnum = setdiff(allStatesEnum,terminalStatesEnum); % enumerated values of the non-terminal (i.e. transient) states
G = -allStates(:,S_0<0);
G(transientStatesEnum,:) = 0;
G(G<0) = 0;
% at this point, only terminal states' number of defender armies left
G = sparse(repmat(sum(G,2).',size(allStates,1),1));
temp = sparse(0,0);
temp2 = sparse(0,0);
for u = 1:numel(P) % compute expected value, which is the stage cost
    temp(:,u) = sum(G.*P{u},2);
    temp2(:,u) = sum(P{u},2);
end
G = temp;
G(temp2==0) = Inf; % applying disallowed inputs in a given state incurs infinite stage cost (thus these inputs are avoided)

function [allX,newXEnum] = removeDuplicates(newX,allX)
% remove duplicate from newly discovered states or inputs
[ib,ia] = ismember(newX,allX,'rows'); % find which newly discovered states are in fact duplicates of already discovered inputs
newXEnum(ib) = ia(ib); % register duplicates
[newX,~,ic] = unique(newX(~ib,:),'rows','stable');
newXEnum(~ib) = size(allX,1)+ic; % register new states
allX = [allX;newX]; % add the newly discovered possible states

function [newStates,newInputs,newTransitionProbabilities] = playBattle(newStates,newInputs,newTransitionProbabilities,probability,xInitial,k,l,a,d)
% give possible outcomes of battle starting from state xInitial where attacker on territory k throws a dice and defender on territory l throws d dice
if a~=1 && d==2
    % attacker loses 2 armies
    newStates(end+1,:) = xInitial;
    newStates(end,k) = newStates(end,k)-2;
    % both lose 1 army
    newStates(end+1,:) = xInitial;
    newStates(end,k) = newStates(end,k)-1;
    newStates(end,l) = newStates(end,l)+1;
    % defender loses 2 armies
    newStates(end+1,:) = xInitial;
    newStates(end,l) = newStates(end,l)+2;
    if ~newStates(end,l) % no defenders left
        % a attacking armies move in to occupy the newly captured defending territory
        newStates(end,k) = newStates(end,k)-a;
        newStates(end,l) = a;
    end
    newInputs = [newInputs;a k l;a k l;a k l];
    newTransitionProbabilities = [newTransitionProbabilities probability(a,d,3) probability(a,d,2) probability(a,d,1)];
else
    % attacker loses 1 army
    newStates(end+1,:) = xInitial;
    newStates(end,k) = newStates(end,k)-1;
    % defender loses 1 army
    newStates(end+1,:) = xInitial;
    newStates(end,l) = newStates(end,l)+1;
    if ~newStates(end,l) % no defenders left
        newStates(end,k) = newStates(end,k)-a;
        newStates(end,l) = a;
    end
    newInputs = [newInputs;a k l;a k l];
    newTransitionProbabilities = [newTransitionProbabilities probability(a,d,2) probability(a,d,1)];
end

function probability = calculateTransitionProbabilities
% compute the probabilities of all possible battle outcomes
% see Table 2 in "Markov Chains for the RISK Board Game Revisited" paper by Jason A. Osborne
probability = zeros(3,2,3); % (# dice rolled by attacker,# dice rolled by defender,enumerated outcome)
% outcome 1: attacker loses no armies
% outcome 2: attacker loses 1 army
% outcome 3: attacker loses 2 armies
probability(3,2,1) = 2890/7776; % attacker rolls 3, defender rolls 2, defender loses 2 armies
probability(3,2,2) = 2611/7776; % attacker rolls 3, defender rolls 2, both lose 1 army
probability(3,2,3) = 2275/7776; % attacker rolls 3, defender rolls 2, attacker loses 2 armies
probability(3,1,1) = 855/1296;  % attacker rolls 3, defender rolls 1, defender loses 1 army
probability(3,1,2) = 441/1296;  % attacker rolls 3, defender rolls 1, attacker loses 1 army
probability(2,2,1) = 295/1296;  % attacker rolls 2, defender rolls 2, defender loses 2 armies
probability(2,2,2) = 420/1296;  % attacker rolls 2, defender rolls 2, both lose 1 army
probability(2,2,3) = 581/1296;  % attacker rolls 2, defender rolls 2, attacker loses 2 armies
probability(2,1,1) = 125/216;   % attacker rolls 2, defender rolls 1, defender loses 1 army
probability(2,1,2) = 91/216;    % attacker rolls 2, defender rolls 1, attacker loses 1 army
probability(1,2,1) = 55/216;    % attacker rolls 1, defender rolls 2, defender loses 1 army
probability(1,2,2) = 161/216;   % attacker rolls 1, defender rolls 2, attacker loses 1 army
probability(1,1,1) = 15/36;     % attacker rolls 1, defender rolls 1, defender loses 1 army
probability(1,1,2) = 21/36;     % attacker rolls 1, defender rolls 1, attacker loses 1 army