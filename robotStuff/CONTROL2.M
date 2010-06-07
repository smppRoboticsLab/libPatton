%________*** MATLAB "M" function (jim Patton) ***_________
% feedback CONTROLLER for a 2 joint arm model:
%
%                                                     phi2  `
%            o                                     o       `
%             \                                     \     `                
%             (m2)                                  (m2) `                      
%               \  q2                                 \ `               
%                o ` ` ` ` `                          o     
%               /                                    /           
%             (m1)                                 (m1)    phi1        
%             / q1                                 / 
%          __o___` ` ` ` ` `                    __o___` ` ` ` ` `  
%          \\\\\\\                              \\\\\\\                 
%
% INPUTS :   u    state and force vector: postions(2), velocities(2),
%            and control inputs(2) (in that order) columns are:
%            u(1) = q1       absolute angle with horiz
%            u(2) = q2       absolute angle with horiz 
%            u(3) = q1_Dot      
%            u(4) = q2_Dot      
%            u(5) = q1_2Dot      
%            u(6) = q2_2Dot      
%            u(7) = phiIntended(1)     (Intended Joint Angle)
%            u(8) = phiIntended(2)     (Intended Joint Angle)
%            u(9) = phiIntendedDot(1)  (Intended Joint velocity)
%            u(10)= phiIntendedDot(2)  (Intended Joint velocity)
%            u(11)= K(1,1)         (active feedback stiffness MAT)
%            u(12)= K(1,2)         
%            u(13)= K(2,1)        
%            u(14)= K(2,2)         
%            u(15)= B(1,1)         (active feedback damping MAT)
%            u(16)= B(1,2)         
%            u(17)= B(2,1)         
%            u(18)= B(2,2)         
%            rows can be time steps
% OUTPUTS :  co    controller output vector (joint torques) 
%            co(1) = tau1
%            co(2) = tau2
% CALLED BY: simulink function call
% VERSIONS:  INITIATED 6/5/95 by jim patton 
%            1/15 to 1/29/99 modified by patton for robot manipulandum
%            5/14/99 changed to control2.m and changed inputs from u(11)
%                    onward, removed gobal variables as inputs.
%~~~~~~~~~~~~~~~~~~~~~~~~~~  BEGIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function tau=control2(u);
%tau=[0 0], fprintf('.control.'); return;           % for debug

%__ SETUP __
global DEBUGIT                                     % nonzero for debugging
fcnName='control2.m';
if DEBUGIT fprintf('~ %s ~',fcnName); end
tau = [0 0];                                       % no torques for control 
verbose=0;                                         % no messages displayed
[rows,cols]=size(u); if cols==1, u=u'; end         % make it a row vect
[rows,cols]=size(u);

% _____ parse out stuff _______
q=u(:,1:2);                                        % segment angle with horiz.
qDot=u(:,3:4);                                     % joint absolute velocities
q2Dot=u(:,5:6);                                    % joint absolute velocities
phiIntended=u(:,7:8);                               % desired positions
phiIntendedDot=u(:,9:10);                           % desired velocities
K=[u(11) u(12)
   u(13) u(14)];
B=[u(15) u(16)
   u(17) u(18)];

% _____ calc relative joint angs stuff _______
phi=[q(:,1) q(:,2)-q(:,1)];                        % joint angles
phiDot=[qDot(:,1) qDot(:,2)-qDot(:,1)];            % joint velocitys
%phi2Dot=[q2Dot(:,1) q2Dot(:,2)-q2Dot(:,1)];       % joint accels

% _____ calc errors _______
phiError=phiIntended-phi;
phiDotError=phiIntendedDot-phiDot;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~ CONTROL TORQUES:  ~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% __  POSITION DEPENDENT FEEDBACK TORQUES  ___
tau=tau + phiError*K;

% __  VELOCITY DEPENDENT FEEDBACK TORQUES  ___
tau=tau + phiDotError*B;

if DEBUGIT fprintf('~ %s DONE. ~',fcnName); end
return



% ______ not used: _________


%global PSTR CCC                                    % for debugging
%subplot(4,2,1); hold on; plot(CCC,phi,PSTR); title('phi');
%subplot(4,2,3); hold on; plot(CCC,phiDot,PSTR); title('phiDot');
%subplot(4,2,5); hold on; plot(CCC,phiError,PSTR); title('phiError');
%subplot(4,2,7); hold on; plot(CCC,phiDotError,PSTR); title('phiDotError');
%subplot(3,1,1); hold on; plot(CCC,K(1:4),PSTR); title('K(1:4)');
%subplot(3,1,2); hold on; plot(CCC,B(1:4),PSTR); title('B(1:4)');
%subplot(3,1,3); hold on; plot(CCC,tau,PSTR); title('tau');
%CCC=CCC+1;










