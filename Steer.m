%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira



function p_new = Steer(p_nearest, p_rand, step_size)

    %Function to find a point from the nearest point and the spet size

    if (norm(p_rand-p_nearest) < step_size)
        p_new = p_rand;
    else
        vector = p_rand-p_nearest;
        vector = vector/norm(vector);
        p_new = p_nearest + step_size*vector;
    end

end %function