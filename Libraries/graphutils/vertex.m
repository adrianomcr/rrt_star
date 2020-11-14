%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

classdef vertex
    %VERTEX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        idx
        state
        parent_idx
        cost_from_parent
        cost_from_start
        children_set
        traj_from_parent
        traj_from_start
    end
    
    methods
        function obj = vertex(idx, state, parent_idx, cost_from_parent, cost_from_start, children_set, traj_from_parent, traj_from_start)
            if (nargin == 0)
                obj.idx = -1;
                obj.state = [];
                obj.parent_idx = -1;
                obj.cost_from_parent = -1;
                obj.cost_from_start = -1;
                obj.children_set = [];
                obj.traj_from_parent = [];
                obj.traj_from_start = [];
            elseif (nargin == 8)
                obj.idx = idx;
                obj.state = state;
                obj.parent_idx = parent_idx;
                obj.cost_from_parent = cost_from_parent;
                obj.cost_from_start = cost_from_start;
                obj.children_set = children_set;
                obj.traj_from_parent = traj_from_parent;
                obj.traj_from_start = traj_from_start;
            else
                error('Using old vertex def');
            end
        end
        
        function flag = is_valid(obj)
            flag = (obj.idx >= 1);
        end
    end
    
end

