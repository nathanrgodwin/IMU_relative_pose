function dataviz_ekf(csvpath1, csvpath2, videoname, myTitle, myTitle2)
    addpath('quaternion_library'); 
    addpath('../filter_code/nick');
    file1 = csvread(csvpath1);
    if (~strcmp(csvpath2, ''))
        file2 = csvread(csvpath2);
    end

    n = size(file1,2);
    fig = figure('visible','off');
    linestart = [0;0;0];
    quat1 = file1(1:4,:);
    quat1 = aa2quat(-quat2aa(quat1))';
    lineendx1 = quaternProd(quat1,quaternProd([0,1,0,0],quaternConj(quat1)));
    lineendy1 = quaternProd(quat1,quaternProd([0,0,1,0],quaternConj(quat1)));
    lineendz1 = quaternProd(quat1,quaternProd([0,0,0,1],quaternConj(quat1)));
    
    if (~strcmp(csvpath2, ''))
        quat2 = file2(1:4,:)';
        lineendx2 = quaternProd(quat2,quaternProd([0,1,0,0],quaternConj(quat2)));
        lineendy2 = quaternProd(quat2,quaternProd([0,0,1,0],quaternConj(quat2)));
        lineendz2 = quaternProd(quat2,quaternProd([0,0,0,1],quaternConj(quat2)));
    end

    %frames(length(round(n*.3):round(n*.375))) = struct('cdata',[],'colormap',[]);
    %v = VideoWriter(videoname);
    %v.FrameRate= 75;
    %open(v);
    for i = round(n*.3):(round(n*.3)+450)
        if (~strcmp(myTitle2, ''))
            subplot(1,2,1)
        end
        line1 = [linestart, lineendx1(i, 2:end)'];
        plot3(line1(1,1:2), line1(2,1:2), line1(3,1:2), 'r', 'LineWidth', 3)
        %pos = ['(' num2str(line1(1,2), '%0.2f') ', ' num2str(line1(2,2), '%0.2f') ', ' num2str(line1(3,2), '%0.2f') ')'];
        pos = 'X';
        text(line1(1,2),line1(2,2),line1(3,2),pos);
        hold on


        line1 = [linestart, lineendy1(i, 2:end)'];
        plot3(line1(1,1:2), line1(2,1:2), line1(3,1:2), 'g', 'LineWidth', 3)
        %pos = ['(' num2str(line1(1,2), '%0.2f') ', ' num2str(line1(2,2), '%0.2f') ', ' num2str(line1(3,2), '%0.2f') ')'];
        pos = 'Y';
        text(line1(1,2),line1(2,2),line1(3,2),pos);
        
        line1 = [linestart, lineendz1(i, 2:end)'];
        plot3(line1(1,1:2), line1(2,1:2), line1(3,1:2), 'b', 'LineWidth', 3)
        %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
        pos = 'Z';
        text(line1(1,2),line1(2,2),line1(3,2),pos);
        title(myTitle)
        grid on
        xlim([-1 1]);
        ylim([-1 1]);
        zlim([-1 1]);
        if (strcmp(csvpath2, ''))
            hold off
        end
        
        if (~strcmp(csvpath2, ''))
            if (~strcmp(myTitle2, ''))
                subplot(1,2,2)
            end
            line2 = [linestart, lineendx2(i, 2:end)'];
            plot3(line2(1,1:2), line2(2,1:2), line2(3,1:2), 'm', 'LineWidth', 3)
            %pos = ['(' num2str(line1(1,2), '%0.2f') ', ' num2str(line1(2,2), '%0.2f') ', ' num2str(line1(3,2), '%0.2f') ')'];
            pos = 'X''';
            text(line2(1,2),line2(2,2),line2(3,2),pos);
            hold on

            line2 = [linestart, lineendy2(i, 2:end)'];
            plot3(line2(1,1:2), line2(2,1:2), line2(3,1:2), 'y', 'LineWidth', 3)
            %pos = ['(' num2str(line1(1,2), '%0.2f') ', ' num2str(line1(2,2), '%0.2f') ', ' num2str(line1(3,2), '%0.2f') ')'];
            pos = 'Y''';
            text(line2(1,2),line2(2,2),line2(3,2),pos);
            
            line2 = [linestart, lineendz2(i, 2:end)'];
            plot3(line2(1,1:2), line2(2,1:2), line2(3,1:2), 'c', 'LineWidth', 3)
            %pos = ['(' num2str(line(1,2), '%0.2f') ', ' num2str(line(2,2), '%0.2f') ', ' num2str(line(3,2), '%0.2f') ')'];
            pos = 'Z''';
            text(line2(1,2),line2(2,2),line2(3,2),pos);
            if (~strcmp(myTitle2, ''))
                title(myTitle2);
            end
            grid on
            xlim([-1 1]);
            ylim([-1 1]);
            zlim([-1 1]);
            hold off
        end
        drawnow
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