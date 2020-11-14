%Universidade Federal de Minas Gerais
%2020/2
%Author:
%         Adriano M C Rezende


% Main refference
% Sampling-based algorithms for optimal motion planning - Sertac Karaman
% and Emilio Frazzoli
% Algorithm 6: RRT*.

close all
clear all

%Ask the user to insert the specifications of a world with obstacles
createOption = input('Type 0 to create a new worlrd or select a existent world number: ');

figure(1)
[w_s, Ob_number, Objetos] = CreateWorld(createOption);
xlabel('x','FontSize',15)
ylabel('y','FontSize',15)
title('Mundo','FontSize',15)
%Ask the user to insert an initial point and a target region
[p_start, p_obj, r_obj] = DefInitialAndObjective(Objetos,w_s);


%Ask the user to insert the number of nodes
nodes_number = input('Insert the desired number of nodes: ');



%% Plot obstacles

%Plot the obstacles
hold on
for k = 1:1:length(Objetos)
    fill(Objetos(k).vertices(:,1),Objetos(k).vertices(:,2),'r','LineStyle','none')
end
drawnow
hold off

%Plot the start point and the final region
hold on
plot(p_start(1),p_start(2),'b.','LineWidth',3,'MarkerSize',20)
plot(p_obj(1),p_obj(2),'b.','LineWidth',3,'MarkerSize',20)
plot(p_obj(1)+r_obj*cos((0:2*pi/50:2*pi)),p_obj(2)+r_obj*sin((0:2*pi/50:2*pi)),'b--','LineWidth',2)
hold off



%%

%Require the user to insert the step of the steer function
% d_steer = input(sprintf('Insert the steer function delta for the world size [%.3f X %.3f]: ', w_s(2)-w_s(1), w_s(4)-w_s(3)));
% d_steer = 0.2; %default
d_steer = sqrt((w_s(2)-w_s(1))*(w_s(4)-w_s(3)))/10; %migueh
d_steer = d_steer/2; %migueh







%Add path to the graph library
addpath('./Libraries/graphutils_opt')

% Create a container to store the nodes
S = container_set(vertex.empty()); %Karaman and Frazzoli, Algorithm 6: RRT, line 1

% Create the initial node - random
start = p_start;
x_start = vertex(S.get_next_idx(), start, 0, 0, 0, [], [], 0);
% Add the node to the container
S.add_element(x_start);



% Computation of the radius according to the PRM* ----------
volume_free = (w_s(2)-w_s(1))*(w_s(4)-w_s(3)); %OBS: this estimation is bigger than the total hipervolume (volume_total > volume_free), it is conservative, thus, it works
volume_bola = pi*1^2;
d = 2; %dimension
gammaRRT = 2*(1+1/d)^(1/d)*(volume_free/volume_bola)^(1/d);
eta = d_steer*3/3; %???????
card_V = S.num_elements;
r_near = min(gammaRRT * (log(card_V)/card_V)^(1/d), eta);
% ----------  ----------  ----------  ----------

node_goal_idx = [];
fprintf('\nComputing tree ...\n')
tic
hold on
%%
hold on
while (1) %Karaman and Frazzoli, Algorithm 6: RRT, line 2
% while (S.num_elements < nodes_number)
    
    %Sample a point in the free space
    x_rand = SampleFree(w_s,Objetos); %Karaman and Frazzoli, Algorithm 6: RRT, line 3
    
    %Find the nearest point
    v_nearest = Nearest(S, x_rand); %Karaman and Frazzoli, Algorithm 6: RRT, line 4
    
    %Obtain the new point to be inserted on the tree - Steer function
    x_new = Steer(v_nearest.state,x_rand,d_steer); %Karaman and Frazzoli, Algorithm 6: RRT, line 5
    
    %Create a vertex that will be used to connect the new node
    v_new = vertex(S.get_next_idx(), x_new, [], 0, 0, [], [], 0);
    
    %If there is no point in the line that conects the new edge
    if (CollisionFree(v_nearest.state,v_new.state,20,Objetos,w_s)) %Karaman and Frazzoli, Algorithm 6: RRT, line 6
        
        % Add node to container
        S.add_element(v_new); %Karaman and Frazzoli, Algorithm 6: RRT, line 8

        %Karaman and Frazzoli, Algorithm 6: RRT, line 7 ----------  ------------
        %Compute the cardinality of the tree (nuber of nodes)
        card_V = S.num_elements;
        %Compute the radius in which other possible parent nodes will be searched
        r_near = min(gammaRRT * (log(card_V)/card_V)^(1/d), eta);
        %Get a set of possible parents - those inside the radius r_near
        V_near = Near(S,v_new.idx,r_near); %vetor com os nos proximos de r
        % ----------  ----------  ----------  ----------  ----------  ----------
        
        %Update the cost to arive at the new node
        v_new.cost_from_parent = cost(v_nearest.state,v_new.state);
        S.container(v_new.idx) = v_new;

        %Karaman and Frazzoli, Algorithm 6: RRT, line 9 ----------  ------------
        %Initialize the minimum cost to start the loop
        v_min = v_nearest;
        c_min = get_cost_from_start(S,v_nearest.idx) + cost(v_nearest.state,v_new.state);
        % ----------  ----------  ----------  ----------  ----------  ----------
        
        %Karaman and Frazzoli, Algorithm 6: RRT, line 10 ----------  ------------
        %For each possible parent check if it generates the minimu cost until the new node
        for i = 1:1:length(V_near) %Connect along a minimum-cost path
            %Select a possible parent
            v_near = V_near(i);
            %Karaman and Frazzoli, Algorithm 6: RRT, line 11 ----------  ------------
            %Check for collision in the conection with the current possible parent
            %And check if this parent originates a smaller cost
            if (CollisionFree(v_near.state,v_new.state,20,Objetos,w_s) && get_cost_from_start(S,v_near.idx) + cost(v_near.state,v_new.state) < c_min)
                %Karaman and Frazzoli, Algorithm 6: RRT, line 12 ----------  ------------
                %Update the best parent
                v_min = v_near;
                c_min = get_cost_from_start(S,v_near.idx) + cost(v_near.state,v_new.state);
            end
        end


        %Karaman and Frazzoli, Algorithm 6: RRT, line 13 ----------  ------------
        % Add each element of V_near to the list of neighbors of v_new
        S.container(v_new.idx).parent_idx = [S.container(v_new.idx).parent_idx, v_min.idx];
        % ----------  ----------  ----------  ----------  ----------  ----------
        
        %Update the cost of the new edge, which conects the new node with the best parent
        S.container(v_new.idx).cost_from_parent = cost(v_min.state,v_new.state);
        v_new.cost_from_parent = cost(v_min.state, v_new.state);
        
        
        %Karaman and Frazzoli, Algorithm 6: RRT, line 14 ----------  ------------
        %Rewire Tree
        for i = 1:1:length(V_near) 
            v_near = V_near(i);
            %Karaman and Frazzoli, Algorithm 6: RRT, line 15 ----------  ------------
            if (CollisionFree(v_near.state,v_new.state,20,Objetos,w_s) && get_cost_from_start(S,v_new.idx) + cost(v_new.state,v_near.state) < get_cost_from_start(S,v_near.idx))
                %Karaman and Frazzoli, Algorithm 6: RRT, line 16 ----------  ------------
                x_parent = v_near.parent_idx;
                
                %Update the father of all the old possible parents of the new node
                S.container(v_near.idx).parent_idx = v_new.idx;
                
                %Update the cost
                S.container(v_near.idx).cost_from_parent = cost(v_new.state,v_near.state);
                % ----------  ----------  ----------  ----------  ----------  ----------
                
            end
        end
        
        
        %Store the nodes that are inside the target region ----------  ----------  ----------
        if (sqrt((x_new(1)-p_obj(1))^2+(x_new(2)-p_obj(2))^2) < r_obj) %se na regiao objetivo
            if (CollisionFree(x_new,p_obj,20,Objetos,w_s)) %se collision free
                if isempty(node_goal_idx)
                    node_goal_idx = v_new.idx;
                else
                    h_novo = sqrt((x_new(1)-p_obj(1))^2+(x_new(2)-p_obj(2))^2); %custo da aresta ate no objetivo novo
                    h_velho = sqrt((S.container(node_goal_idx).state(1)-p_obj(1))^2+((S.container(node_goal_idx).state(2)-p_obj(2))^2)); %custo da aresta ate no objetivo antigo
                    if (get_cost_from_start(S,v_new.idx) + h_novo < get_cost_from_start(S,node_goal_idx) + h_velho) % (g + h)_novo < (g + h)_velho
                        node_goal_idx = v_new.idx;
                    end
                end
            end
        end
        % ----------  ----------  ----------  ----------  ----------  ----------  ----------
        
        
        
        % Stoppig condition ----------  ----------  ----------  ----------  ----------
        %If the number of nodes reached the desired one and the target was already found
        if (S.num_elements == nodes_number && ~isempty(node_goal_idx))
            if(mod(S.num_elements,1000) == 0)
                fprintf('Reached %d nodes: ', S.num_elements)
                toc
            end
            %Terminate
            break;
        %Else, ask the user to insert some additional number of nodes
        elseif (S.num_elements == nodes_number)
            toc
            fprintf('The goal was not found yet\n')
            add_nodes_number = input('Insert a positive number to increase the number of nodes: ');
            if (add_nodes_number > 0)
                nodes_number = nodes_number + add_nodes_number;
            end
        end
        % ----------  ----------  ----------  ----------  ----------  ----------  ----------
        
    end %if
    
    
    if(mod(S.num_elements,200) == 0)
        fprintf('Reached %d nodes: ', S.num_elements)
        toc
    end
    

    

end %while
hold off
fprintf('Tree computed\n')
toc








%% Print tree
hold on
fprintf('\nPrinting Tree ...\n')
tic
%Plot each edge of the tree
tree_edges_X = [];
tree_edges_Y = [];
for k = 2:1:S.num_elements
    v = S.container(k);
    u = S.container(v.parent_idx);
    tree_edges_X = [tree_edges_X , [v.state(1); u.state(1)]];
    tree_edges_Y = [tree_edges_Y , [v.state(2); u.state(2)]];
end
plot(tree_edges_X,tree_edges_Y,'k-')
fprintf('Tree printed\n')
toc
hold off




%% Plot optimum path
current_node = node_goal_idx;
path = current_node;
%Find the sequence of nodes of the optimim path
while (current_node ~= 1)
    current_node = S.container(current_node).parent_idx;
    path = [current_node path];
end
hold on
v1 = S.container(path(end)).state;
v2 = p_obj;
%Plot path
plot([v1(1) v2(1)],[v1(2) v2(2)],'-g','LineWidth',4)
for k = 1:1:(length(path)-1)
    v1 = S.container(path(k)).state;
    v2 = S.container(path(k+1)).state;
    plot([v1(1) v2(1)],[v1(2) v2(2)],'-g','LineWidth',4)
end
hold off



%% Save results
name = './logs/';
timestamp = now;
timestamp = datetime(timestamp,'ConvertFrom','datenum');
timestamp = sprintf('%s',timestamp);
name = strcat(name,timestamp);
name = strcat(name,sprintf(' %d_nodes',S.num_elements));
name = strcat(name,'.mat');
save(name,'S','path','createOption','w_s','p_start','p_obj','r_obj')





