%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

classdef edge_element < handle
    %EDGE_ELEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        idx % id of this edge element
        e1 % id of the first parent
        e2
    end
    
    methods
        function obj = edge_element(idx, e1, e2)
            obj.idx = idx;
            obj.e1 = e1;
            obj.e2 = e2;
        end
        
        function [edge1, edge2] = get_edge(obj)
            if (isempty(obj))
                edge1 = [];
                edge2 = [];
            else
                edge1 = obj.e1;
                edge2 = obj.e2;
            end
        end
        
        function flag = is_valid(obj)
            flag = ~isempty(obj) & (obj.idx >= 1);
        end

    end
    
end
