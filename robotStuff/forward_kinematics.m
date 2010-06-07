%______*** MATLAB "M" function (jim Patton) ***_______
% forcefield calculations based on kinematics
%
%            o
%             \                   
%             (m2)    q2=u(2)
%               \ 
%                o ` ` ` ` `     
%               /                
%             (m1)   q1=u(1)
%             /
%          __o___` ` ` ` ` `     
%          \\\\\\\               
%
% INPUTS :    u    state and force vector: postions(2), velocities(2),
%                  & torques(2) (in that order): 
%                      u(1) = q1
%                      u(2) = q2
%                      u(3) = Dq1
%                      u(4) = Dq2
%                      u(5) = DDq1
%                      u(6) = DDq2
% OUTPUTS:    
% CALLS :     -
% CALLED BY:  
% VERSIONS:   3/8/99    INITIATED  by jim patton
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [R,Rdot,R2dot]=forward_kinematics(u);
%fprintf(' forward_kinematics ')

%_______________ SETUP ______________
global L 
% M   row=seg#; col1=mass col2=polar inertia@segCM (matrix)
% L   segment length (interjoint)
[rows,cols]=size(u); if cols==1, u=u'; end       % make it a row vect

%___ forward kinematics ___

R(:,1)=L(1)*cos(u(:,1))+L(2)*cos(u(:,2));       % cartesian enpt location
R(:,2)=L(1)*sin(u(:,1))+L(2)*sin(u(:,2));       %

Rdot(:,1)=-L(1)*u(:,3).*sin(u(:,1))         ... % cartesian enpt velocity
          -L(2)*u(:,4).*sin(u(:,2));
Rdot(:,2)= L(1)*u(:,3).*cos(u(:,1))         ... % 
          +L(2)*u(:,4).*cos(u(:,2));

R2dot(:,1)=-L(1)*u(:,5).*sin(u(:,1))        ... % cartesian enpt accel
           -L(1)*u(:,3).^2.*cos(u(:,1))     ... 
           -L(2)*u(:,6).*sin(u(:,2))        ...
           -L(2)*u(:,4).^2.*cos(u(:,2));
R2dot(:,2)= L(1)*u(:,5).*cos(u(:,1))        ... % 
           -L(1)*u(:,3).^2.*sin(u(:,1))     ... 
           +L(2)*u(:,6).*cos(u(:,2))        ...
           -L(2)*u(:,4).^2.*sin(u(:,2));


