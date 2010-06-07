% ************** MATLAB "M" function (jim Patton) *************
% this file creates a 3d scaatter plot for the input variable (xyz).
% & draws the data points resolved to the other 2 planes (y and z).
% INPUTS:		x 	a N by 3 matrix of N triples, with :
%					x values in 1st column 
%					y values in 2nd column 
%					y values in 3rd column 
%			mrk	a marker string (example 'b+' for blue plusses)
% OUTPUTS:		generates a plot, and returns plot handle
% CALLS:		plot3.m, polyfit.m
% CALLED BY:		?
% INITIATIED:		12/14/95 by jim patton from fpstatic.m 
% SYNTAX:		handle=plotproj(x,mrk);
% SEE DIRECTORY:   	C:\JIM\matlab\devel
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function plt_hndl=plot2prj(x1,x2,mrk1,mrk2);
fprintf('\n~plot2prj.m MATLAB m-function (PATTON)~');

%xx=0:.51:10; xx=xx'; x=rand(20,3)+[xx xx xx]; %xlabel('x'); ylabel('y'); zlabel('z');
plt_hndl=plot3(0, 0, 0); hold on; grid on; 

%__________ Plot 3d data points___________
for i=1:length(x1(:,1)), 
  hdl=plot3([x1(i,1)],[ x1(i,2)],[x1(i,3)],mrk1); 
  set(hdl,'LineWidth',2); set(hdl,'MarkerSize',4);
end; 
for i=1:length(x2(:,1)), 
  hdl=plot3([x2(i,1)],[ x2(i,2)],[x2(i,3)],mrk2); 
  set(hdl,'LineWidth',2); set(hdl,'MarkerSize',4);
end; 

ax=axis;

%__________ Plot projection points___________
for i=1:length(x1(:,1)), 
  hdl=plot3([x1(i,1)],ax(4),[x1(i,3)],  mrk1);  	set(hdl,'MarkerSize',3);
  hdl=plot3(ax(2),[ x1(i,2)],[x1(i,3)], mrk1); 	set(hdl,'MarkerSize',3);
  hdl=plot3([x1(i,1)],[x1(i,2)], ax(5), mrk1); 	set(hdl,'MarkerSize',3);
end;

for i=1:length(x2(:,1)), 
  hdl=plot3([x2(i,1)],ax(4),[x2(i,3)],  mrk2);  	set(hdl,'MarkerSize',3);
  hdl=plot3(ax(2),[ x2(i,2)],[x2(i,3)], mrk2); 	set(hdl,'MarkerSize',3);
  hdl=plot3([x2(i,1)],[x2(i,2)], ax(5), mrk2); 	set(hdl,'MarkerSize',3);
end;

%__________ Fit series 1 to linear (1st order) polynomial & plot projections ___________
if length(x1(:,1))>1,
  p = polyfit(x1(:,1),x1(:,2),1);
  plot3(							...
    [min(x1(:,1)) max(x1(:,1))],				...
    [p(2)+p(1)*min(x1(:,1)) p(2)+p(1)*max(x1(:,1))],	...
    [ax(5) ax(5)],					...
    mrk1(1));

  p = polyfit(x1(:,3),x1(:,2),1);
  plot3(							...
    [ax(2) ax(2)],					...
    [p(2)+p(1)*min(x1(:,3)) p(2)+p(1)*max(x1(:,3))],	...
    [min(x1(:,3)) max(x1(:,3))],				...
    mrk1(1));

  p = polyfit(x1(:,1),x1(:,3),1);
  plot3(							...
    [min(x1(:,1)) max(x1(:,1))],				...
    [ax(4) ax(4)],					...
    [p(2)+p(1)*min(x1(:,1)) p(2)+p(1)*max(x1(:,1))],	...
    mrk1(1));
end % if length(x1(:,1))>1

%__________ Fit series 2 to linear (1st order) polynomial & plot projections ___________
if length(x2(:,1))>1,
  p = polyfit(x2(:,1),x2(:,2),1);
  plot3(							...
    [min(x2(:,1)) max(x2(:,1))],				...
    [p(2)+p(1)*min(x2(:,1)) p(2)+p(1)*max(x2(:,1))],	...
    [ax(5) ax(5)],					...
    mrk2(1));

  p = polyfit(x2(:,3),x2(:,2),1);
  plot3(							...
    [ax(2) ax(2)],					...
    [p(2)+p(1)*min(x2(:,3)) p(2)+p(1)*max(x2(:,3))],	...
    [min(x2(:,3)) max(x2(:,3))],				...
    mrk2(1));

  p = polyfit(x2(:,1),x2(:,3),1);
  plot3(							...
    [min(x2(:,1)) max(x2(:,1))],				...
    [ax(4) ax(4)],					...
    [p(2)+p(1)*min(x2(:,1)) p(2)+p(1)*max(x2(:,1))],	...
    mrk2(1));
end % if length(x2(:,1))>1

fprintf('~END plotproj.m~\n');
