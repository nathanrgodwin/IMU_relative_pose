vrinfo = aviinfo('circle_ukf_1651.avi');
filename = 'circle_ukf_1651.gif'; 
mov1 = VideoReader('circle_ukf_1651.avi');
vidFrames = read(mov1);
for n = 1:vrinfo.NumFrames
      [imind,cm] = rgb2ind(vidFrames(:,:,:,n),255);
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1;
          imwrite(imind,cm,filename,'gif', 'DelayTime',0.1,'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','DelayTime',0.1,'WriteMode','append');
      end
end 