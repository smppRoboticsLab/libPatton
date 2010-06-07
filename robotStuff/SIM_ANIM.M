%______*** MATLAB "M" M-file(jim Patton) ***_______
% animate the results simulated dynamically
%            Fy
%            ^
%            :
%            :
%            o - - - >Fx         
%             \                   
%             (m2)    q2
%               \ 
%                o ` ` ` ` `     
%               /                
%             (m1)  q1
%             /
%          __o___` ` ` ` ` `     
%          \\\\\\\         
%
% INPUTS :      u(1) = time
%               u(2) = q1
%               u(3) = q2
%               u(4) = q1_dot
%               u(5) = q2_dot
%               u(6) = q1_2dot
%               u(7) = q2_2dot
%               u(8) = Fx
%               u(9) = Fy
%   
% OUTPUTS : 	  graphics
% CALLED BY : 	
% VERSIONS:	1		INITIATED 2/2/99 by jim patton 
%______________________________________________________

function sim_anim(u);

%___SETUP___
global L DEBUGIT graphicsParams Gcounter     % where:
% L=segment length (interjoint)
% graphicsParams=values pointing to te characteristics of plots (representing the arm):
%                     graphicsParams(1)=handle for the graphics of the arm
%                     graphicsParams(2)=handle for the enpoint force on animation
%                     graphicsParams(3)=scaling factor enpoint force on animation(N/m)
% Gcounter=global counter 
if DEBUGIT, fprintf(' ~ sim_anim.m   animating.. ~ '); end
skip=.03;                              % time skip before redrawing (s)
Ncalls=8;                              % skip this many calls before redrawing
Gcounter=Gcounter+1;

%___ dont draw everytime: ___
if round(100*u(1)/skip)/100==round(u(1)/skip) | Gcounter==Ncalls,
  

  %____________locate joint points____________
  elbowx=L(1)*cos(u(2));
  elbowy=L(1)*sin(u(2));          
  endpointx=elbowx+L(2)*cos(u(3));    
  endpointy=elbowy+L(2)*sin(u(3));    

  % __________ update arm drawing __________  
  set(graphicsParams(1)                            ... % set this instant's config
   ,'Xdata',[0 elbowx endpointx]                   ...               
   ,'Ydata',[0 elbowy endpointy]                   ...
   ); 
  set(graphicsParams(2)                            ... % set this instant's force
   ,'Xdata',graphicsParams(3).*[0 u(8)]+endpointx  ...               
   ,'Ydata',graphicsParams(3).*[0 u(9)]+endpointy  ...
   ); 
 
  title(['Simulating... (time=' num2str(u(1)) ')'])
 
  drawnow; pause(0);
  
  if Gcounter==Ncalls, fprintf('`'); end    % send tick signal
  
  Gcounter=0;                               % reset counter and signal
  
end         


return
