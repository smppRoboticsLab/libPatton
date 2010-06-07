
function [datawv, MOVED] = add_vel(data, ctrial);

%ctrial=[ 503282      504009 ];
velxy=[]; vel=[]; sumvel=[];
datawv=[];

tinterval = data(4,1)-data(2,1);
ei=1; bi=1;

   for j=1:ctrial(2)-ctrial(1)-1
       velxy(j,1) = abs( (data(ctrial(1)+j+1, 4) - data(ctrial(1)+j-1,4))/tinterval);
       velxy(j,2) = abs( (data(ctrial(1)+j+1, 5) - data(ctrial(1)+j-1,5))/tinterval);
       vel(j) = sqrt(power(velxy(j,1),2) + power(velxy(j,2),2));  
   end
    
   for i=5:ctrial(2)-ctrial(1)-1
     sumvel(i-4) = 0.2*(vel(i-4) + vel(i-3) + vel(i-2) + vel(i-1) + vel(i));
   end
     
  i=1;
  countbg = 1;
  while countbg==1
    if i<=ctrial(2)-ctrial(1)-5 || sumvel(i)>0.01
        bi = ctrial(1) + i;
         countbg=0;
    end
     i = i+1;
  end
 
   i=ctrial(2)-ctrial(1)-5;
   countend=1;
   while countend == 1
    if i==2 || sumvel(i)>0.01
      ei = ctrial(1) + i;
      countend=0;
    end
     i = i-1;
   end
 
   if ei-bi>20
       MOVED=1;
     for j=1:ei-bi
       datawv(j,1:2) = data(bi+j,4:5);
       datawv(j,3:4) = velxy(bi+j-ctrial(1),1:2);
       datawv(j,5:6) = data(bi+j,6:7);
     end
   else
       MOVED = 0;
   end
  
  
  
      
      