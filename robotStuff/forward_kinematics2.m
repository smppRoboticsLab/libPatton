%______*** MATLAB "M" function (jim Patton) ***_______
% forcefield calculations based on kinematics
% SYNTAX:  rho=forward_kinematics2(q);
%
%            o
%             \                   
%             (m2)    q2=q(2)
%               \ 
%                o ` ` ` ` `     
%               /                
%             (m1)   q1=q(1)
%             /
%          __o___` ` ` ` ` `     
%          \\\\\\\               
%
% INPUTS :    q     state and force vector: postions(2), velocities(2),
%                   & torques(2) (in that order): 
%                      q(1) = q1
%                      q(2) = q2
%                      q(3) = Dq1
%                      q(4) = Dq2
%                      q(5) = DDq1
%                      q(6) = DDq2
% OUTPUTS:    rho   Cartesian space (x,y) matrix with columns: 2pos, 2vel, 2accel
% CALLS :     -
% CALLED BY:  
% VERSIONS:   9/8/99    INITIATED by jim patton from forward_kinematics.m, so
%                       it returns one big matrix rho with all derivs.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function rho=forward_kinematics2(q);
%fprintf(' forward_kinematics2.m ')

%_______________ SETUP ______________
global L 
% M   row=seg#; col1=mass col2=polar inertia@segCM (matrix)
% L   segment length (interjoint)
[rows,cols]=size(q); if cols==1, q=q'; end       % make it a row vect

%___ forward kinematics ___

rho(:,1)=L(1)*cos(q(:,1))+L(2)*cos(q(:,2));       % cartesian enpt location
rho(:,2)=L(1)*sin(q(:,1))+L(2)*sin(q(:,2));       %

rho(:,3)=-L(1)*q(:,3).*sin(q(:,1))            ... % cartesian enpt velocity
          -L(2)*q(:,4).*sin(q(:,2));
rho(:,4)= L(1)*q(:,3).*cos(q(:,1))            ... % 
          +L(2)*q(:,4).*cos(q(:,2));

rho(:,5)=-L(1)*q(:,5).*sin(q(:,1))            ... % cartesian enpt accel
           -L(1)*q(:,3).^2.*cos(q(:,1))       ... 
           -L(2)*q(:,6).*sin(q(:,2))          ...
           -L(2)*q(:,4).^2.*cos(q(:,2));
rho(:,6)= L(1)*q(:,5).*cos(q(:,1))            ... % 
           -L(1)*q(:,3).^2.*sin(q(:,1))       ... 
           +L(2)*q(:,6).*cos(q(:,2))          ...
           -L(2)*q(:,4).^2.*sin(q(:,2));


