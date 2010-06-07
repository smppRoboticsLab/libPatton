%______*** MATLAB "M" function (jim Patton) ***_______
% Plant function for the following model is simulated dynamically
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
% INPUTS :   u    state and force vector: postions(2), velocities(2),
%                 & torques(2) (in that order): 
%                      u(1) = q1
%                      u(2) = q2
%                      u(3) = Dq1
%                      u(4) = Dq2
%                      u(5) = controller torque shoulder
%                      u(6) = controller torque elbow
%                      u(7) = endpoint force x (absolute coord)
%                      u(8) = endpoint force y (absolute coord)
% OUTPUTS:   DDq accelerations of the varibles
% CALLS :  -
% CALLED BY :  sim_2df.m (simulink function file)
% VERSIONS:  6/5/95    INITIATED  by jim patton
%            10/10/96  Fixed Bug in formulation (patton) 
%            2/2/99    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function DDq=plant(u);
%fprintf('~ plant.m  ~'); DDq=[.1 .1], return               % FOR DEBUGGING

%_______________ SETUP ______________
global M L R g Kpas EPpas Bpas % where:
% M     =row=seg#; col1=mass col2=polar inertia@segCM (matrix)
% L     =segment length (interjoint)
% R     =distal joint to segment CM
% g     =accel due to gravity (m/s/s)
% Kpas  =passive linear torsional spring const. vector, 1 element/joint (N*m/rad)
% EPpas =passive equilibrium point in joint angles. vector, 1 element/joint (rad)
% Bpas  =passive linear torsional spring const. vector, 1 element/joint (N*m*sec/rad)
[rows,cols]=size(u); if cols==1, u=u'; end       % make it a row vect

%____ START WITH CONTROLLER TORQUES ____
tau=u(5:6);

%__ add field force contribution to torques __
F=u(:,7:8);                                   % extract force from inputs
J=jacobian([u(1);u(2)-u(1)],L);               % find jacobian
tau_field=((J')*F')';                         % convert to torque
tau=tau+tau_field;                            % add it on

%____ add PASSIVE TORQUES ____
%tau=tau+passive_torques(u(1,1:4));

%____ SETUP SOME  VARS used frequently BELOW ____
dif        =  (u(1)-u(2));                   % used frequently
offdiag    =  M(2,1)*L(1)*R(2)*cos(dif);     % used frequently
scale_vel  =  M(2,1)*L(1)*R(2)*sin(dif);     % used frequently

%_____ CALC ACCEL USING EQUATIONS OF MOTION (checked 10/13/96) ______
A   =[M(2,1)*L(1)^2+M(1,1)*R(1)^2+M(1,2)    offdiag;    ...
      offdiag                               M(2,1)*R(2)^2+M(2,2)  ];
b   =[-scale_vel*u(4)^2-(M(1,1)*R(1)+M(2,1)*L(1))*g*cos(u(1))+tau(1)-tau(2);  ...
       scale_vel*u(3)^2-M(2,1)*g*R(2)*cos(u(2))+tau(2)         ];

%_____ solution to A*DDq=b ______
DDq   = A\b;

return