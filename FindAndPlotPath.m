


function successPlot = FindAndPlotPath(G, algorithm, figNum, plotFigOne, q_init, q_goal, w_s)

% G - graph container
% algorithm - number especifying thr algorithm:   1->DFS   2->BFS   3->Dijkstra   4->A*
% figNum - number of the figure to plot stuff
% plotFigOne - should be '1' in orther to plot the path in figure 1 also
% q_init - index for the initial node
% q_goal- index for the goal node
% w_s - world x and y limits

successPlot = 0;

switch (algorithm)
    case 1
        name = 'DFS';
        funcao = 'search_DFS(q_init,q_goal,G)';
    case 2
        name = 'BFS';
        funcao = 'search_BFS(q_init,q_goal,G)';
    case 3
        name = 'Dijkstra';
        funcao = 'search_Dijkstra(q_init,q_goal,G)';
    case 4
        name = 'A*';
        funcao = 'search_Astar(q_init,q_goal,G,0.95)';
    otherwise
        warning('INVALID ALGORITHM! Altomatic return')
        return
end







fprintf(sprintf('Execution time of %s: ', name))
tic
eval(sprintf('[success Tree Edge] = %s;',funcao))
toc
if (success == 0)
    warning(sprintf('Algorithm %s did not suceeded',name))
    return
end
fprintf('\n')
figure(figNum)
% subplot(2,1,1)
% vecPlotTree(Tree);
% title(sprintf('%s tree', name),'FontSize',15)
% %Plota grafo completo
% subplot(2,1,2)
title(sprintf('%s path', name),'FontSize',15)
hold on
axis(w_s)
for i=1:Tree.num_elements()
    for j=1:Tree.num_elements()
        if Edge.has_edge(i,j)
            vi=Tree.get_element(i);
            vj=Tree.get_element(j);
            plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)], '.b','LineWidth',4)
            plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)], 'Color','black')
            axis(w_s)
        end
    end
end
axis equal
%Encontra o caminho
current_node = q_goal; %procura pelo ultimo noh
path = current_node;
while(current_node ~= q_init)
    current_node = Tree.container(current_node).parent_idx;
    path = [current_node path];
end
%Plota caminho na arvove
hold on
for i = 1:1:(length(path)-1)
    vi=Tree.get_element(path(i));
    vj=Tree.get_element(path(i+1));
    plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)],'g','LineWidth',3)
end
hold off


if (plotFigOne == 1)
    %Plota caminho no mundo
    figure(1)
    hold on
    for i = 1:1:(length(path)-1)
        vi=Tree.get_element(path(i));
        vj=Tree.get_element(path(i+1));
        plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)],'g','LineWidth',3)
    end
    hold off
end




if (success ~= 1)
    warning(sprintf('Algorithm %s couldent find a path'),name);
end




successPlot = 1;

end %function