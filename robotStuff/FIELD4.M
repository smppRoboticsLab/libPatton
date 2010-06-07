%______*** MATLAB "M" function (jim Patton) ***_______
% torque calculations based on kinematics -- special field
%
%            Fy
%            ^
%            :
%            :
%            o - - - >Fx         NOTE:  
%             \                   phi are relative (joint) angles
%             (m2)    q2
%               \ 
%                o ` ` ` ` `     
%               /                
%             (m1)  q1
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
%                      u(7) = q1_intended
%                      u(8) = q2_intended
%                      u(9) = Dq1_intended
%                      u(10)= Dq2_intended
%                      u(11)= DDq1_intended
%                      u(12)= DDq2_intended
%                      u(13) = q1_desired
%                      u(14) = q2_desired
%                      u(15) = Dq1_desired
%                      u(16)= Dq2_desired
%                      u(17)= DDq1_desired
%                      u(18)= DDq2_desired
%             skip_fwd_kin (optional) nonzero if you want to skip 
%                           the forward kinematics calulation[default=0]
%                           use this if you want to see what the field is 
%                           for a given cartesian endpoint postion, 
%                           velocity or acceleration
% OUTPUTS:    torques
% CALLS :     -
% CALLED BY:  sim_2df.m (simulink function file)
% VERSIONS:   6/5/95    INITIATED  by jim patton
%             10/10/96  Fixed Bug in formulation (patton) 
%             2/2/99    made it work for the robotics lab
%             11/9/99   added rr field
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function F=field4(u,skip_fwd_kin);

%______________ SETUP ______________
global DEBUGIT M L R g field_gain field_type rc RCB % cc ccBASIS
% field_gain=MATRIX of gains that govern the endpoint force. see below
if DEBUGIT disp('~ field4.m ~'); end               %
if ~exist('skip_fwd_kin'),skip_fwd_kin=0;end      % accomodate defaults
[rows,cols]=size(u); if cols==1, u=u'; end        % make it a row vect
[rows,cols]=size(u);
if cols<7, u(:,7:18)=zeros(rows,12); end;
[rows,cols]=size(u);
F=zeros(rows,8);                                  % initialize
NtimeSteps=length(u(:,1));                        % find # of timesteps
q=u(:,1:6);                                       % parse out actual
qIntent=u(:,7:12);                                % parse out Intent 
qDesire=u(:,13:18);                               % parse out Desire

%___ forward kinematics ___
if skip_fwd_kin,  rho=u;                          % if cartesian inputs
else              rho=forward_kinematics2(q); end % end if skip_...            

%___ calc force field ___
if strcmp(deblank(field_type),'stiffness')        % use inertial field 
  F=rho(:,1:2)*field_gain;                        % output=matrix*pos_vect 
elseif strcmp(deblank(field_type),'viscous' )     % use inertial field
  F=rho(:,3:4)*field_gain;                        % output=matrix*velocity_vect 
elseif strcmp(deblank(field_type),'inertial')     % use inertial field 
  F=rho(:,5:6)*field_gain;                        % output=matrix*accel_vect  
elseif strcmp(deblank(field_type),'rc')           % 
  F=zeros(NtimeSteps,2);                          % init
  for b=1:length(RCB)
    if rc(b)
      F=F+rc(b)*rcEval3(rho,RCB(b),0);              %
    end
  end                                             % END for base              
elseif strcmp(deblank(field_type),'rr')           % radial-radial field 
  F=zeros(NtimeSteps,2);                          % init
  for b=1:length(RRB)
    if rr(b)
      F=F+rr(b)*rrEval(rho,RRB(b),0);              %
    end
  end                                             % END for base              
else                                              % use null field as default
  F=[0 0];                                        % output=zero 
end                                               % END if

if DEBUGIT disp('~ field4.m ~'); end               %
return





