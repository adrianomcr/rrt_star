%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira


function free = CollisionFree(u1,u2,n,Objetos,w_s)

    %u1 - first point
    %u2 - secong point
    %n - desired number of interpolation
    %Objetos - list of structures with the obstacles
    
    if(length(u1(:,1)) == 1); u1 = u1'; end
    if(length(u2(:,1)) == 1); u2 = u2'; end
    
    %Obtain interpolation
    vetor = u2-u1;
    linha = u1*ones(1,n) + vetor*linspace(0,1,n);
    
    %Check if thre is at least one point inside at least one object
    free = 1;
    for k = 1:1:length(Objetos)
        O_v = Objetos(k).vertices;
        dentro = inpolygon(linha(1,:),linha(2,:),O_v(:,1),O_v(:,2)); %obs: can be improved
        if sum(dentro) > 0
            free = 0;
            break;
        end
    end
    
    %Check if the point is inside the workspace
    if (u1(1)<w_s(1) || u1(1)>w_s(2) || u1(2)<w_s(3) || u1(2)>w_s(4))
        free = 0;
    end
    if (u2(1)<w_s(1) || u2(1)>w_s(2) || u2(2)<w_s(3) || u2(2)>w_s(4))
        free = 0;
    end
    %USE inpolygon INSTEAD


end
