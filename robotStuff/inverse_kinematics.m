%______*** MATLAB "M" file (jim Patton) ***_______
% Inverse kinematics of two-joint planar arm. (such as the human arm)
% Inverse kinematics transforms a desired endpoint position 
% into corresponding angles.  
% CONTROLLER for the following model 
% SYNTAX:  q=invrskin(p,a)
% INPUTS:  p    matrix of positons. rows are different instances in 
%               time, and colums are x and y.
%          a    nonzero for absolute, meaning q(2) will be specified in 
%               inertial reference & not relative to the link its 
%               connected to. (see below)
%
%     if a is nonzero:                  if a=0 or not given:
%
%          p  o                                  p  o   q2  `
%             \                                      \     `                
%             (m2)                                   (m2) `                      
%               \  q2                                  \ `               
%                o ` ` ` `                             o     
%               /                                     /           
%             (m1)                                  (m1)          
%             /   q1                                /   q1        
%          __o___` ` ` ` ` `                    __o___` ` ` ` ` `  
%          \\\\\\\                              \\\\\\\                 
%    L is distal-to-segment mass ctr., 
%    q is positive for countrclockwise rot
%
% REVISIONS: 1/28/99 Adapeted by patton from conditt's INVRSKIN.M  
%~~~~~~~~~~~~~~~~~~~~~~~~~~  BEGIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function q=inverse_kinematics(p,a)

global L % where: L=	segment length (interjoint)
l1=L(1);
l2=L(2);
p=p';
if ~exist('a'), a=0; end;                      % default joint angs if not given 

q(2,:) = acos((p(1,:).^2 + p(2,:).^2 - l1^2 - l2^2) ./ (2 * l1 * l2));
q(1,:) = atan2(p(2,:),p(1,:))                    ...
       - atan2((l2 * sin(q(2,:))),(l1 + (l2 * cos(q(2,:)))));

if a, q(2,:)=q(2,:)+q(1,:); end               % CALCULATE ABSOLUTE IF REQUESTED

q=q';

