%______*** MATLAB "M" M-file(jim Patton) ***_______
% send halt signal if slow & within target
%            
%            o 
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
% INPUTS :      u(1) = desired endpoint x
%               u(2) = desired endpoint y
%               u(3) = speedThresh
%               u(4) = q1
%               u(5) = q2
%               u(6) = q1_dot
%               u(7) = q2_dot
% OUTPUTS : 	  stop       zero if stop condition is not met
% VERSIONS:	1		INITIATED 5/4/00 by jim patton 
%______________________________________________________

function stop=sim_anim(u);

%___SETUP___
global L 
% L=segment length (interjoint)

endpoint(1)=L(1)*cos(u(4))+L(2)*cos(u(5));    
endpoint(2)=L(1)*sin(u(4))+L(2)*sin(u(5));    
e1=norm(endpoint-u(1:2)');                  
e2=norm(u(6:7));
%fprintf('<%f %f>\n', e1,e2);

if (e1<.005 & e2<u(3)) % if pos & vel err small
  fprintf('..stop criterion reached. ')
  stop=1;
else
  stop=0; 
end


return
