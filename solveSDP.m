function [optimalAttack,optimalAttackEnum,optimalJ,exitflag] = solveSDP(P,G,transientStatesEnum,allInputs)
fprintf('Preparing to solve the SDP problem\n');
P2{1} = sparse(0,0);
for u = 1:numel(P)
    P2{u} = P{u}(transientStatesEnum,transientStatesEnum);
end
G2 = G(transientStatesEnum,:);
K=size(P2{1},1); % Dimension of (transient) state space
L=size(G2,2); % Dimension of input space

%% step 1:solve linear program
% set up the arrays required by linprog
f=-1*ones(1,K);
A=repmat(speye(K),L,1)-vertcat(P2{:});
b=reshape(G2,[K*L,1]);
% Remove Inf in order for linprog to converge
idx=isinf(b);
b=b(~idx);
A=A(~idx,:);
% Solve the linear program
options=optimoptions('linprog','Display','off','Algorithm','dual-simplex'); % Don't show "Optimization terminated." message
fprintf('Optimizing\n');
[optimalJ,~,exitflag]=linprog(f,A,b,[],[],[],[],[],options); % Solve linear program

%% step 2: obtain optimal policy by solving Bellman's equation with argmin (to get the minimizing policy)
fprintf('Computing the optimal inputs using Bellman''s equation\n');
temp = sparse(size(P2{u},1),numel(P2));
temp2 = repmat(optimalJ.',K,1);
for u = 1:numel(P2) % compute expected value, which is the stage cost
    temp(:,u) = sum(P2{u}.*temp2,2);
end
[~,optimalAttackEnum]=min(G2+temp,[],2);
optimalAttack = allInputs(optimalAttackEnum,:);
fprintf('All done\n');