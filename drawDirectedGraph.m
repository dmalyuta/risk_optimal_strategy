% draw  connected, directed graph to visualize the output of createGraph() function
nodeLabels = allStates;
stateEnum = allStatesEnum;
T = P{1};
for u = 2:numel(P)
    T = T+P{u};
end
stateGraph = digraph(T);

% create node labels
nodeLabels = reshape(cellstr(num2str(nodeLabels(:))),size(nodeLabels,1),size(nodeLabels,2));
for i = 1:size(nodeLabels,2)-1
    nodeLabels(:,i) = strcat(nodeLabels(:,i),{','});
end
while size(nodeLabels,2)~=1
    nodeLabels = [strcat(nodeLabels(:,1),nodeLabels(:,2)) nodeLabels(:,3:end)];
end

figure(3); clf(figure(3)); hold on;
stateGraphPlot = plot(stateGraph);
layout(stateGraphPlot,'layered','Direction','right');
% labelnode(stateGraphPlot,stateEnum,nodeLabels);
% labeledge(stateGraphPlot,1:numedges(stateGraph),nonzeros(T.'));
set(gca,'xtick',[],'ytick',[],'Position',[0 0 1 1]);