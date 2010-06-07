%______*** MATLAB "M" M-file(jim Patton) ***_______
% animate the results simulated dynamically
%     \
%     (m2)
%       \
%        \
%         o 
%        /
%     (m1)
%      /
%     /
%  __o___
%  \\\\\\\
%
% INPUTS: 	    -
% OUTPUTS:      graphics
% CALLED BY:    do_2df_1.m 	(m- file) 
% VERSIONS:	    INITIATED 6/5/95 by jim patton 
%               renamed 2/2/99 from simple_anim to post_anim
%______________________________________________________

fprintf(' ~ post_anim.m Animating.. ~ ');

%___________________Resample states_____________________
skip=.03;
len=length(time);
u_time=0:skip:time(len);
u_q=interp1(time,posvelacc(:,1:2),u_time); 
u_force=interp1(time,force(:,1:2),u_time);
u_rho=zeros(length(u_time),2,2);

%_________ setup arm segments if necessary _________
if ~exist('armPlotHandle'), 
  %set_anim(intended_rho); 
end    % set plot if not already


%_________ setup other things _________
title(['end time=' num2str(tf)]);
ax=axis; xrange=ax(2)-ax(1);
hh=plot(ax(1),ax(4),'k.','markersize',15);
plot(0,0,'bo');                                   % circle @shoulder joint
elbow_h=plot(0,0,'bo');                           % circle @elbow joint
forearm_h=plot(0,0,'y.','markersize',10); 
humerus_h=plot(0,0,'y.','markersize',10); 

%_________ loop for each frame _________
for t=2:length(u_time);
  
  %__________ locate joint points __________
  joint1x=L(1)*cos(u_q(t,1));
  joint1y=L(1)*sin(u_q(t,1));          
  joint2x=joint1x+L(2)*cos(u_q(t,2));    
  joint2y=joint1y+L(2)*sin(u_q(t,2));    

  % __________ update arm  __________  
  set(graphicsParams(1)                       ... % this time's config
      ,'Xdata',[0 joint1x joint2x]            ...               
      ,'Ydata',[0 joint1y joint2y]            ...
      ); 

  %______ update elbow joint & seg CMs  _____  
  set(elbow_h                                 ... % this time's config
      ,'Xdata',[joint1x ]                     ...               
      ,'Ydata',[joint1y ]                     ...
      ); 
  set(humerus_h                               ... % this time's config
      ,'Xdata',[R(1)*cos(u_q(t,1))]                     ...               
      ,'Ydata',[R(1)*sin(u_q(t,1))]                     ...
      ); 
  set(forearm_h                               ... % this time's config
      ,'Xdata',[joint1x+R(2)*cos(u_q(t,2))]   ...               
      ,'Ydata',[joint1y+R(2)*sin(u_q(t,2))]   ...
      ); 
    
  % __________ update force vector __________  
  set(graphicsParams(2)                       ... % set this time's config
   ,'Xdata',                                  ...               
   graphicsParams(3).*[0 u_force(t,1)]+joint2x       ...               
   ,'Ydata',                                  ...               
   graphicsParams(3).*[0 u_force(t,2)]+joint2y       ...
   ); 
  
  set(hh,'Xdata',ax(1)+u_time(t)/tf*xrange);      % update progress dot
  
  plot(joint2x,joint2y,'k.','markersize',4)       % leave endpoint trace
 
  drawnow; pause(0)
  
end %for

fprintf(' ~ END post_anim.m ~ \n');

return
