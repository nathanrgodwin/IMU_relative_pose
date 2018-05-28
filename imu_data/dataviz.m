function dataviz(csvpath, videoname, myTitle)
    addpath('quaternion_library'); 

    file = csvread(csvpath);

    n = size(file,2);
    fig = figure('visible','off');
    linestart = [0;0;0];
    quat = file(1:4,:)';
    lineendx = quaternProd(quat,quaternProd([0,1,0,0],quaternConj(quat)));
    lineendy = quaternProd(quat,quaternProd([0,0,1,0],quaternConj(quat)));
    lineendz = quaternProd(quat,quaternProd([0,0,0,1],quaternConj(quat)));

    %frames(length(round(n*.3):round(n*.375))) = struct('cdata',[],'colormap',[]);
    %v = VideoWriter(videoname);
    %v.FrameRate= 75;
    %open(v);
    for i = round(n*.3):(round(n*.3)+450)
        line = [linestart, lineendz(i, 2:end)'];
        plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'b', 'LineWidth', 3)
        %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
        pos = 'Z';
        text(line(1,2),line(2,2),line(3,2),pos);
        hold on

        line = [linestart, lineendx(i, 2:end)'];
        plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'r', 'LineWidth', 3)
        %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
        pos = 'X';
        text(line(1,2),line(2,2),line(3,2),pos);

        line = [linestart, lineendy(i, 2:end)'];
        plot3(line(1,1:2), line(2,1:2), line(3,1:2), 'g', 'LineWidth', 3)
        %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
        pos = 'Y';
        text(line(1,2),line(2,2),line(3,2),pos);

        grid on
        xlim([-1 1]);
        ylim([-1 1]);
        zlim([-1 1]);
        title(myTitle)
        drawnow
        hold off
        frame = getframe(fig);
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        %writeVideo(v,frames(i));
          if i == round(n*.3)
              imwrite(imind,cm,videoname,'gif', 'DelayTime',1/75,'Loopcount',inf);
          else
              imwrite(imind,cm,videoname,'gif','DelayTime',1/75,'WriteMode','append');
          end
    end
    %close(v)
end