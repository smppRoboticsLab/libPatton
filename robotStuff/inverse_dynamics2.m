% ************** MATLAB "M" function (jim Patton) *************
% Inverse dynamic analysis on chain-o-segments w/known kinetics @ endpoint. 
%
% SYNTAX:  [Fx,Fy,T]=inverse_dynamics(posvelacc,end_kinetics,verbose);
%
% It uses the  "top down approach."  See /jim/lee/inv_dyn for bottom 
% up hybrid approach with force plate info.
%
%     o==>"end kinetics:" force and torque at endpoint
%      \
%      (m2)
%        \  q2
%         o   -   -   -   -   -   -	
%        /                 M is mass vect, R is  segment lengths, 
%      (m1)                L is distal-to-segment mass ctr., 
%      /   q1            q is positive for countrclockwise rot
%   __o___  -   -   -   -   -   -   
%   \\\\\\\
%
% INPUTS:  posvelacc    postions in columns, then velocities, then 
%                       accelerations.  Defined as positive counter 
%                       clockwise from horizontal to the right(matr)
%          end_kinetics force vector of time records [x,y,torque]
%          M          row=seg#; col1=mass col2=polar inertia@segCM (matrix)
%          L          segment lengths (interjoint)(vect)
%          R          distal joint to segment CM (vect)
%          g          accel due to gravity down 
% OUTPUTS: Fx    x force at joints (rows=time; columns=joint#)
%          Fy    y force at joints (rows=time; columns=joint#)
%          T     TORQUE at joints (rows=time; columns=joint#)
% CALLS:      passive_torques()
% VERSIONS:   10/2/96   INITIATED Patton from inv_dyn4.m -IDA proj&Hsin-I
%             12/11/96  Moved to matlab/devel directory; named ida_top.m
%             6/23-4/97 Patton. new comments; moved to 
%                       D:\Programs\mfiles\JIMUTIL\IDA_TOP.M 
%             1/25/99   Changed comments and tabs.
%             1/27/99   Changed name from and made more general 
%             9/16/99   changed order of outputs and renamed
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [T,Fx,Fy]=inverse_dynamics2(posvelacc,end_kinetics,M,L,R,g,verbose);

%______________ SETUP ______________
global DEBUGIT  
% where:
if ~exist('verbose'), verbose=1; end                 % if not passed
if verbose,fprintf('\n ~ inverse_dynamics2.m ~ '); end  %
len=length(posvelacc(:,1));                          % number of time steps
if ~exist('end_kinetics'),                           % if not passed
  if verbose,
    fprintf('no end_kinetics?! Assume zero..');      % message
  end
  end_kinetics=zeros(len,3);                         % [Fx, Fy, T]
end                                                  %
num_seg=length(posvelacc(1,:))/3;                    % number of segs in anal
Fx(:,num_seg+1)=-end_kinetics(:,1);                   % top (endpt) xforce 
Fy(:,num_seg+1)=-end_kinetics(:,2);                   % top (endpt) yforce 
 T(:,num_seg+1)=-end_kinetics(:,3);                   % top (endpt) torque
q   = posvelacc(:,1:num_seg);                        % parse out position 
Dq  = posvelacc(:,num_seg+1:num_seg*2);              % parse out vel
DDq = posvelacc(:,num_seg*2+1:num_seg*3);            % parse out acc
m=M(:,1);                                            % seg mass (bottom first)(vect)
I=M(:,2);                                            % seg inertia (bottom first)(vect)
if DEBUGIT,m,I,L,R,g,fprintf(' Calculating..\n');end

%______________IDA:______________
% joint kinetics from motion (this is set 
% up to be general for multilink chain
% of num_seg segments, where each link 
% is connected to the previous one.) 
if DEBUGIT, fprintf(' (i=)..'); end                  % message
for i=num_seg:-1:1,                                  % each segment 
  if DEBUGIT, fprintf(' %d ',i); end                 % message
  
  %___ START WITH upper FORCE ___
  Fx(:,i)=Fx(:,i+1);                                % invert due to arrow conventions 
  Fy(:,i)=Fy(:,i+1);                                %

  %___ SUM EFFECT of segment's accel due to rot ___
  Fx(:,i)=Fx(:,i)                                ... %
         -m(i)*R(i).*( DDq(:,i).*sin(q(:,i))     ... %
         +Dq(:,i).^2.*cos(q(:,i)) );                 %
  Fy(:,i)=Fy(:,i)                                ... %
         +m(i)*R(i).*(DDq(:,i).*cos(q(:,i))      ... %
         -Dq(:,i).^2.*sin(q(:,i)) ) + m(i)*g;        %

  %__ SUM MIDDLE TERMS 'CEPT SEG 1___
  if i> 1,
    for j=1:i-1
      Fx(:,i)=Fx(:,i)                            ... %
         -m(i)*L(j).*(DDq(:,j).*sin(q(:,j))      ...
         +Dq(:,j).^2.*cos(q(:,j))  );
      Fy(:,i)=Fy(:,i)                            ... %
         +m(i)*L(j).*(DDq(:,j).*cos(q(:,j))      ...
         -Dq(:,j).^2.*sin(q(:,j))  );
    end %for j
  end %if

  %_______TORQUE:______
  T(:,i)= R(i) .*( -Fx(:,i).*sin(q(:,i))         ...
                  + Fy(:,i).*cos(q(:,i))  )      ...
   +(L(i)-R(i)).*( -Fx(:,i+1).*sin(q(:,i))       ...
                  + Fy(:,i+1).*cos(q(:,i)) )     ...
   +T(:,i+1) + I(i).*DDq(:,i);
 
 
end  % for i   

%_______ PASSIVE JOINT IMPEDANCE FORCES:_______
%T(:,1:2)=T(:,1:2)-passive_torques(posvelacc(:,1:num_seg*2));

%Fx,Fy,T % for debugging

if DEBUGIT, fprintf(' Done. \n '); end
if verbose,fprintf('~ END inverse_dynamics2.m ~ '); end  %
return