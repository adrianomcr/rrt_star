function c = get_cost_from_start(S,v)


    c = 0;
    
    while v ~= 1
        
        c = c + S.container(v).cost_from_parent;
        v = S.container(v).parent_idx;
        
    end



end