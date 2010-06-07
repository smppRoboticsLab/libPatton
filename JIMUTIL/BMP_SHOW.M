% ************** MATLAB "M" file  (jim Patton) *************
% reads and displays a bmp file on a figure window
% SYNTAX:	h=bmp_show(filename)
% INPUTS:  	filename		
% OUTPUTS: 	plot
% CALLS : 	loadbmp.m	(matlab contrib function)
% CALLED BY:	?		
% INITIATIED:	5/22/96 by patton from rega_set.m
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function h=bmp_show(filename)
fprintf(' ~ bmp_show.m (patton) ~ '); 

clf; hold;
h=0;
[X,map]=loadbmp(filename);
Y=X-1;
clear X; x=[]; y=[];
[m,n]=size(Y);
for i=1:m,
  for j=1:n, 
    if Y(i,j)==0, x=[x; j]; y=[y; m-i]; end;
  end %for j
  %fprintf('.'); 
end %for I

plot(x,y,'k.'); 
fprintf(' ~ END bmp_show.m (patton) ~ '); 

