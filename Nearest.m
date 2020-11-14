%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira


% function [success, v_nearest] = Nearest(S, p_rand)
function v_nearest = Nearest(S, p_rand)



    index = 1;
    min_dist = sqrt((S.container(1).state(1)-p_rand(1))^2+(S.container(1).state(2)-p_rand(2))^2);
    %Iterate over the vertexex to find the closest one
    for k = 2:1:S.num_elements
        new_dist = sqrt((S.container(k).state(1)-p_rand(1))^2+(S.container(k).state(2)-p_rand(2))^2);
        if (new_dist < min_dist)
            min_dist = new_dist;
            index = k;
        end
    end
    
    %Return the nearest vertex
    v_nearest = S.container(index);
    
end %function