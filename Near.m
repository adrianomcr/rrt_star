%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira


% function [success, v_nearest] = Nearest(S, p_rand)
function V_near = Near(S, v, r)

    %S - graph
    %v - vertex aroud which near vertexes will be searched
    %r - maximum search radius

    v_near = [];
    dist = [];
    for k = 1:1:S.num_elements
        if (k ~= v)
            current_dist = sqrt((S.container(k).state(1)-S.container(v).state(1))^2+(S.container(k).state(2)-S.container(v).state(2))^2);
            if (current_dist <= r)
                    v_near = [v_near k];
                    dist = [dist current_dist];
            end
        end
    end

    %Return the set of near vertexes
    V_near = S.container(v_near);
    
end %function