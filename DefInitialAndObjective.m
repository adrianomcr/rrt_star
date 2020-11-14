
function [p_start, p_obj, r_obj] = DefifeInitialAndObjective(Objetos,w_s)


    %Require the user to insert the initial point
    title('SELECT THE STARTING POINT')
    fprintf('Insert the starting point on screen\n');
    p_start = ginput(1);
    %Wait for a point in the free region
    while(CollisionFree(p_start,p_start,1,Objetos,w_s) ~= 1)
        fprintf('INVALID POINT!\n')
        fprintf('Insert a valid starting point\n');
        %Get the start point
        p_start = ginput(1);
    end
    hold on; plot(p_start(1),p_start(2),'b*','LineWidth',3); hold off;
%     nodes_number = input('Insert the desired number of nodes: ');
%     nodes_number = 200; %default

    %Require the user to insert the objective region
    title('SELECT THE OBJECTIVE (center and radius)')
    fprintf('Insert the objective region on screen\n');
    p_obj = ginput(1);
    %Wait for a point in the free region
    while(CollisionFree(p_obj,p_obj,1,Objetos,w_s) ~= 1)
        fprintf('INVALID POINT!\n')
        fprintf('Insert a valid objective point\n');
        %Get the center of the target region
        p_obj = ginput(1);
    end
    hold on
    plot(p_obj(1),p_obj(2),'b*','LineWidth',3)
    %Get the radius of the target region
    r_obj = ginput(1);
    r_obj = norm(r_obj-p_obj);
    plot(p_obj(1)+r_obj*cos((0:2*pi/50:2*pi)),p_obj(2)+r_obj*sin((0:2*pi/50:2*pi)),'b--','LineWidth',2)
    title('')

    axis equal
    axis (w_s)

end %function