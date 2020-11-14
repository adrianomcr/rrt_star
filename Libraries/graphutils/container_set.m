%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

classdef container_set < handle
    %STATE_CONTAINER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        container
    end
    
    methods
        function obj = container_set(elem)
            obj.container = elem;
        end
        
        function add_element(obj, v)
            if (v.idx >= 1)
                obj.container(1, v.idx) = v;
            end
        end
        
        function idx = get_next_idx(obj)
            idx = length(obj.container) + 1;
        end
        
        function v = get_element(obj, idx)
            v = obj.container(idx);
        end
        
        function v = num_elements(obj)
            v = length(obj.container);
        end
    end
    
end

