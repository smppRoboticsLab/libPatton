%______*** MATLAB "M" function (jim Patton) ***_______
% Setup DESIRED TRAJECTORY based on data loaded from file.
% SYNTAX: [rho,q,phi,t1]=get_trajectory(trajFileName,rot,mag,cntrPt,verbose);
%
%                                                     phi2  `
%            o==>F                                 o==>F   `
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
% INPUTS :    trajFileName    file with data
%             rot             amount to rotate this data ccw about origin
%             mag             scale by this much
%             cntrPt          shift this much
%             verbose         nonzero for messages
% OUTPUTS:    rho             time,CARTESIANpositons,velocities,&accels(NX7)
%             q               time,ANGULARpositons,velocities,&accels(NX7)
%             phi             same but for joint (relative) angles(NX7)
%             t1              time domain (NX1)
% VERSIONS:   4/22/99 INITIATED (patton) spawned from do_df2
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [rho,q,phi,t1]=get_trajectory(trajFileName,rot,mag,cntrPt,verbose);

%_______ SETUP ______
global L
progname='get_desired_trajectory.m';
if ~exist('trajFileName'),                 % if nothing given, set typical pt2pt
  trajFileName='pt2pt.txd';
  rot=pi/2; 
  mag=.1; 
  cntrPt=[.15 .3]; 
end;
if ~exist('rot'),     rot=0;          end;
if ~exist('mag'),     mag=1;          end;
if ~exist('cntrPt'),  cntrPt=[0 0];   end;
if ~exist('verbose'), verbose=1;      end;
if ~exist('L'),       L=[8888 8888],  end;
L
if verbose, 
  fprintf('\n~ %s ~', progname);            % message
end                                         % 

if length(mag)==1, mag=[mag mag]; end       % if single value given, apply to both


%_______ LOAD _______
if verbose, 
  fprintf('loading %s',trajFileName);
end % message
[HEAD,DATA]=hdrload(trajFileName);          % load xy trajectory
len=length(DATA(:,1));
Hz=sscanf(HEAD(3,:),                    ... % 
  'Sampling freq in Hz: %f');
if verbose, 
  fprintf('(sampled at %.2f Hz)', Hz);
  fprintf(' DONE loading.');
end % message

%______ SCALE, ROTATE, TRANSLATE _______
DATA=cleannan(DATA,0);                      % if any NaN's, remove them
DATA(:,1)=DATA(:,1)*mag(1);                 % scale final dist to desired mag
DATA(:,2)=DATA(:,2)*mag(2);                 % scale final dist to desired mag
if rot~=0,                                  % rotate direction
  for i=1:len,
    DATA(i,:)=rot2d(DATA(i,:),rot);
  end
end
DATA=[DATA(:,1)+cntrPt(1) DATA(:,2)+cntrPt(2)];

%_______ construct time ______
tf=1/Hz*(length(DATA)-1);                   % final sim time
t1=0:1/Hz:tf; t1=t1';                       % set desired time (as col vect)

%__ CALC rho (endpoint traj& deriv's) __
rho=DATA; 
[rho(:,3:4),rho(:,5:6)]=dbl_diff(rho,Hz,0); % calc higher derivatives
rho=[t1 rho];                               % add a time col

%___ CALC phi (joint angles & deriv's) __
phi=inverse_kinematics(rho(:,2:3),0);       % desired joint (relative) ang 
[phi(:,3:4),phi(:,5:6)]=dbl_diff(phi,Hz,0); % calc higher derivatives
phi=[t1 phi];                               % add a time col
  
%___ CALC q (seg angles & deriv's) __
q=inverse_kinematics(rho(:,2:3),1);         % desired joint (relative) ang 
[q(:,3:4),q(:,5:6)]=dbl_diff(q,Hz,0);       % calc higher derivatives
q=[t1 q];                                   % add a time col
  
if verbose, 
  fprintf('~ END %s. ~',progname);
end % message

%figure(2); clf; plot(DATA(:,1),DATA(:,2)); axis('image')
