%Universidade Federal de Minas Gerais - 2016/2
%Planejamento de Movimento de Robos II
%Aluno: Adriano M C Rezende
%Professor: Guilherme Pereira


function [w_s, Ob_number, Objetos] = CreateWorld(default)

    %w_s - vector with the world limits
    %Ob_number - number of obstacles
    %Objetos - vector with the object structures

    %It the user what to greate a new world
    if (default == 0)
        %Ask the user to insert the world size
        w_s = input('Define the world size in the form [xl xr yd yu]: ');
%         w_s = [-2 2 -1 1]; %default

        %Ask the user to insert the number of obastacles
        Ob_number = input('Define the number of obstacles: ');
%         Ob_number = 2; %default

        %Plot the workspace box
        plot(w_s([2 1 1 2 2]),w_s([4 4 3 3 4]),'k-','LineWidth',2)
        axis equal

        %Obtain the vertexes of the polygonal obstacles
        objeto = struct('vertices',0,'n',0);
        Objetos = [];
        for k = 1:1:Ob_number
            hold on;
            title(sprintf('Insert the vertices of obstacle number %d - (right click to close)',k))
            O_v = []; %vertices de um obstaculo
            button = 0;
            %Keep inserting vertexes while the button is not the right one
            while button ~= 3
                [x,y,button] = ginput(1);
                if(button ~= 1);
                    if(length(O_v(:,1))>1)
                        %Plot new edge
                        plot([O_v(end,1) O_v(1,1)],[O_v(end,2) O_v(1,2)],'r-','LineWidth',1)
                    end
                    break;
                end;
                plot(x,y,'ro','LineWidth',2)
                O_v = [O_v; x,y];
                %Plot an edge to close the polygon
                if(length(O_v(:,1))>1)
                    plot([O_v(end-1,1) O_v(end,1)],[O_v(end-1,2) O_v(end,2)],'r-','LineWidth',1)
                end

            end
            title('')
            hold off
            eval(sprintf('O_v%d = O_v;',k))
            objeto = struct('vertices',O_v,'n',length(O_v(:,1)));
            Objetos = [Objetos objeto];
        end
        %Ask the user to insert a number to save the world created
        save_num = input('Define a number to save this world (-1 does not save): ');
        if (save_num ~= -1)
            save(sprintf('./SavedWorlds/World_%d',save_num), 'w_s', 'Ob_number', 'Objetos')
        end
        
    %If the user what to load a existing world
    elseif default > 0
        load(sprintf('./SavedWorlds/World_%d',default), 'w_s', 'Ob_number', 'Objetos')
        
        %Plot the workspace box
        plot(w_s([2 1 1 2 2]),w_s([4 4 3 3 4]),'k-','LineWidth',2)
        axis equal
        hold on
        %Plot the loaded obstacles
        for k = 1:1:Ob_number
            for l = 1:1:Objetos(k).n
                l_next = mod(l,Objetos(k).n)+1;
                plot([Objetos(k).vertices(l,1) Objetos(k).vertices(l_next,1)],[Objetos(k).vertices(l,2) Objetos(k).vertices(l_next,2)],'r','LineWidth',2)
            end
        end
        hold off
    else
        error('Invalid world number')
    end
    
end %function
