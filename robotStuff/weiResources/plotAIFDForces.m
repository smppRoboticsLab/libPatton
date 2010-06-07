
% plots the forces in iterative field design
clf; 
fi1 = 1;
fi2 = 1;
numf = 1;
numf2 = 100;

filename='targ_p1.txd';
if exist(filename)
    [ht,dt]=hdrload(filename); 
end


for i=1:length(dt) % scan all
    filename=['F_' num2str(i) '.DAT'];
  
    if dt(i,7) == 225 && dt(i,6) == 2000
      [h,d]=hdrload(filename);
     
      figure(numf);
      ORIENT TALL;
    
      if numf==1 title('red-fx, green-fy'); end
      subplot(4,1,fi1);
      fi1 = fi1 + 1;
      t=(-1:size(d,1))/100;
      d=[0 0;d;0 0];
       plot(t,d(:,1),'r'); hold on;  plot(t,d(:,2),'g');  grid on; 
       ylim([-12 12]);
      multbar3(d',t);
      ylabel(dt(i,1));
      
      if fi1>4
          fi1=1;
          if numf == 1 
              print -dpsc2 AllIFDforces;
          else
              print -dpsc2 AllIFDforces -append;
          end
          numf = numf + 1;
      end
    end
end
   
for i=1:length(dt) % scan all
    filename=['F_' num2str(i) '.DAT'];
    
    if dt(i,7) == 315 && dt(i,6) == 2000
      [h,d]=hdrload(filename);
      
      figure(numf2);
      ORIENT TALL;
      if numf2==100 title('red-fx, blue-fy'); end;
      
      subplot(4,1,fi2);
      fi2 = fi2 + 1;
      t=(-1:size(d,1))/100;
      d=[0 0;d;0 0];
      plot(t,d(:,1),'r'); hold on;  plot(t,d(:,2),'b');  grid on; 
      ylim([-12 12]);
      multbar3(d',t);
      ylabel(dt(i,1));
       
      if fi2>4
          fi2=1;
           print -dpsc2 AllIFDforces -append;
          numf2 = numf2 + 1;
      end
    end
    
end
 
copyfile('F_221.DAT','F1.txd');
copyfile('F_219.DAT','F2.txd');

 close all;


 
  