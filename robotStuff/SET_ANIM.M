%______*** MATLAB "M" M-file(jim Patton) ***_______
% setup to animate the results simulated dynamically
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
% INPUTS :      
% OUTPUTS : 	  graphics
% CALLED BY : 	
% VERSIONS:	1		INITIATED 2/2/99 by jim patton 
%______________________________________________________

function set_anim(rIntended);

%___SETUP___
global DEBUGIT L graphicsParams
% where:
% DEBUGIT=nonzero for extra debugging messages
% L      =segment length (interjoint)
% graphicsParams=values pointing to te characteristics of plots (representing the arm)
%                     graphicsParams(1)=handle for the graphics of the arm
%                     graphicsParams(2)=handle for the enpoint force on animation
%                     graphicsParams(3)=scaling factor enpoint force on animation(N/m)

if DEBUGIT, fprintf(' ~ set_anim.m ~ '); end


%____draw environment and setup plot if not set yet____
  fprintf(' ~ setting animation.. ~ ');   
  plot(sum(L)*cos(-.2:.1:pi+.2),sum(L)*sin(-.2:.1:pi+.2),'g'); % workspace
  hold on; 
  plot(rIntended(:,2),rIntended(:,3),'b');
  axis image
  ax=axis; xrange=ax(2)-ax(1); %yrange=ax(4)-ax(3);
  graphicsParams(1)=plot([0 L(1) L(1)+L(2)],     ... % this instant's config
                     [0 0 0],                    ...
                     'r','linewidth', 4);   
  graphicsParams(2)=plot([0 0]+L(1)+L(2),        ... % this instant's config
                     [0 0],                      ...
                     'g','linewidth', 2);   
  title('simulating...')                   

drawnow; pause(0);
return
