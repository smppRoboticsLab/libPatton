%______*** MATLAB "M" function (jim Patton) ***_______
% calculate the passive impedance torques at the 2 joints
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
% INPUTS :   u      state and force vector: postions(2), velocities(2),
%                   & torques(2) (in that order): 
%                      u(1) = q1
%                      u(2) = q2
%                      u(3) = Dq1
%                      u(4) = Dq2
% OUTPUTS:   tau    TORQUES BASED ON MOTIONS AND PASSIVE CONSTANTS
% VERSIONS:  3/1/99 INITIATED  by jim patton
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function tau=passive_torques(u);
%fprintf('~ passive_torques.m  ~');

%_______________ SETUP ______________
global Kpas EPpas Bpas     % where:
% Kpas  =passive linear torsional spring const. vector, 1 element/joint (N*m/rad)
% EPpas =passive equilibrium point in joint angles. vector, 1 element/joint (rad)
% Bpas  =passive linear torsional spring const. vector, 1 element/joint (N*m*sec/rad)
[rows,cols]=size(u); if cols==1, u=u'; end                 % make it a row vect

%_______ passive impedances _____
tau=zeros(length(u(:,1)),2);                               % init
tau(:,1) = tau(:,1)-Kpas(1)*(  u(:,1)         - EPpas(1)); % passive stiffnes
tau(:,2) = tau(:,2)-Kpas(2)*( (u(:,2)-u(:,1)) - EPpas(2)); %
tau(:,1) = tau(:,1)-Bpas(1)*u(:,3);                        % passive viscous
tau(:,2) = tau(:,2)-Bpas(2)*(u(:,4)-u(:,3));               %
tau=zeros(length(u(:,1)),2);                               % init

%fprintf('~ passive_torques.m  ~');
return