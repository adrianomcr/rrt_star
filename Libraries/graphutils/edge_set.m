%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

classdef edge_set < handle
    %EDGE_SET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        graph
    end
    
    methods
        function obj = edge_set()
            obj.graph = [];
            obj.graph = sparse(obj.graph);
        end
        
        function add_edge(obj, id1, id2)
            obj.graph(id1, id2) = 1;
        end
        
        function remove_edge(obj, id1, id2)
            obj.graph(id1, id2) = 0;
        end
        
        function remove_all_parents(obj, id)
            obj.graph(:, id) = 0;
        end
        
        function flag = has_edge(obj, id1, id2)
            if (id1 > size(obj.graph,1) || id2 > size(obj.graph,2))
                flag = 0;
            else 
                flag = obj.graph(id1, id2) == 1;
            end
        end
        
        function merge(obj, new_edge_set)
            [i,j,~] = find(new_edge_set.graph);
            for iter = 1:length(i)
                obj.graph(i(iter), j(iter)) = 1;
            end
        end
    end
    
end

