%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

classdef vertex_set < handle
    %VERTEX_SET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        map
    end
    
    methods
        function obj = vertex_set(vset)
            if (nargin == 0)
                obj.map = [];
            else
                obj.map = vset.map;
            end
        end
        
        function add_vertex(obj, idx)
            obj.map(idx) = 1;
        end
        
        function remove_vertex(obj, idx)
            obj.map(idx) = 0;
        end
        
        function flag = has_vertex(obj, idx)
            if idx > length(obj.map)
                flag = 0;
            else
                flag = obj.map(idx) == 1;
            end
        end
        
        function idx = get_idx(obj)
            idx = transpose(find(obj.map == 1));
        end
        
        function sz = num_vertex(obj)
            sz = sum(obj.map);
        end
        
        function merge(obj, new_vertex_set)
            obj.map(new_vertex_set.map == 1) = 1;
        end
    end
    
end

