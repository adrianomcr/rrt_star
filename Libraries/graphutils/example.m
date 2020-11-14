% Example of use for graph classes
% Guilherme Pereira - 17/10/2016

clear all
close all

% Create the container for all nodes
S = container_set(vertex.empty());

% Create the node set - This contains only indexes for the nodes. The
% actual nodes are stored in the container set
V = vertex_set();

% Create de edge set
E = edge_set();

rng(100); % Seed of random number generator

% Create the start node
start=[0, 0];
v_start = vertex(S.get_next_idx(), start, 0, 0, 0, [], [], 0);

% Add the start node the cotainer
S.add_element(v_start);

% Add the start node to the vertex set
V.add_vertex(v_start.idx);


% Create a graph
for i=1:20
    
    % Generate a new random node
    new=[rand, rand];
    v_new = vertex(S.get_next_idx(), new, 0, 0, 0, [], [], 0);
       
    % Connect the new node to the nodes close to it if there is one
    % Get the list of all nodes in the graph
    V_list = S.get_element(V.get_idx());
    
    % Compute de distance from v_new to all nodes of the graph
    dist = pdist2(cell2mat({V_list.state}'), v_new.state);
    
    % Create the list of all nodes close to v_new
    V_near = V_list(dist - 0.5<= 0);
    
    % If the list is not empty add v_new to the graph
    if ~(isempty(V_near))
        S.add_element(v_new);
        V.add_vertex(v_new.idx);
        % Create edges for from each element in V_near to v_new
        for i=1:length(V_near)
            E.add_edge(V_near(i).idx, v_new.idx);
            % Add v_new to the list of neighbors of each element of V_near
            S.container(V_near(i).idx).children_set=[S.container(V_near(i).idx).children_set, v_new.idx];
            % Add each element of V_near to the list of neighbors of v_new
            S.container(v_new.idx).children_set=[S.container(v_new.idx).children_set, V_near(i).idx];
        end
    end
end


% Plot
figure(1)
hold on
axis([0 1 0 1])
for i=1:S.num_elements()
    for j=1:S.num_elements()
        if E.has_edge(i,j)
            vi=S.get_element(i);
            vj=S.get_element(j);
            plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)], 'o', 'Color','blue')
            plot([vi.state(1) vj.state(1)], [vi.state(2) vj.state(2)], 'Color','black')
            axis([0 1 0 1])
        end
    end
   
end