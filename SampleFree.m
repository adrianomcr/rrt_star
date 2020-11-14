%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira


function new = SampleFree(w_s,Objetos)

    %Sample a random point in the free space of the world definedw_s and Objetos
    %w_s - boundaries of the world
    %Objetos - vector of object structures
    
    map_rand_x = [-1 1; 1 0]*[w_s(1); w_s(2)];
    map_rand_y = [-1 1; 1 0]*[w_s(3); w_s(4)];
    
    colisao = 1;
    %Keep sorting a point until it is in the free region
    while(colisao ~= 0)
        %Sort a point
        new = [[rand, 1]*map_rand_x [rand, 1]*map_rand_y]; %maps 0-1 to the world edges
        colisao = 0;
        %Check if the point lies inside an obstacle
        for k = 1:1:length(Objetos)
            O_v = Objetos(k).vertices;
            dentro = inpolygon(new(1),new(2),O_v(:,1),O_v(:,2));
            %Give up if the point is inside an obstacle
            if (dentro == 1)
                colisao = k;
                break;
            end
        end
        
    end


end %function