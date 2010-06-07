%______*** MATLAB "M" function (jim Patton) ***_______
% Setup DESIRED TRAJECTORY based on data loaded from file.
% SYNTAX: [rho,q,phi,t1,St,speed]=f(fName,L,startPt,rot,mag,deflection,speedThresh,verbose,plotIt);
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
% INPUTS :    fName    file with data
%             L               2 element array of segment lengths
%             startPt          shift this much
%             rot             amount to rotate this data ccw about origin
%             mag             scale by this much
%             verbose         nonzero for messages
% OUTPUTS:    rho             time,CARTESIANpositons,velocities,&accels(NX7)
%             q               time,ANGULARpositons,velocities,&accels(NX7)
%             phi             same but for joint (relative) angles(NX7)
%             t1              time domain (NX1)
% VERSIONS:   4/22/99 INITIATED (patton) spawned from do_df2
%             2-10-2000 made L an input, renamed to getTreajectory.m
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [rho,q,phi,t1,St,speed]=f(fName,L,startPt,rot,mag,deflection,speedThresh,verbose,plotIt);
 
%_______ SETUP ______
progname='getIdealTrajectory.m';
if verbose,fprintf('\n~ %s ~',progname); end 
if ~exist('plotIt'), plotIt=0; end                    % if not passed
if ~exist('fName'),                          % if nothing given
  warning('No inputs given! USING DEFAULT:\n\n'); 
  fName='pt2pt.txd'
  rot=pi/2
  mag=.1
  startPt=[.15 .3]
end;
if ~exist('rot'),     
  warning('No "rot" given! USING DEFAULT:\n'); 
  rot=0         
end;
if ~exist('mag'),     
  warning('No "mag" given! USING DEFAULT:\n'); 
  mag=.2     
end;
if ~exist('startPt'), 
  warning('No "startPt" given! USING DEFAULT:\n'); 
  startPt=[0 .45]  
end;
if ~exist('speedThresh'), 
  warning('No "speedThresh" given! USING DEFAULT:\n'); 
  speedThresh=.06;
end;
if ~exist('verbose'), verbose=1;      end;
if ~exist('L'),       
  warning('No "L" given! USING DEFAULT:\n'); 
  L=-[8888 8888];
end;

%_______ LOAD _______
if verbose, 
  fprintf('loading %s',fName);
end % message
[HEAD,DATA]=hdrload(fName);          % load xy trajectory
len=length(DATA(:,1));
Hz=(findInTxt(fName,'Sampling freq in Hz:'));
if verbose, 
  fprintf('(sampled at %.2f Hz)', Hz);
  fprintf(' DONE loading.');
end % message
 
%______ SCALE, ROTATE, TRANSLATE _______
DATA=cleannan(DATA,0);                      % if any NaN's, remove them
DATA(:,1)=DATA(:,1)*mag;                    % scale final dist to desired mag
DATA(:,2)=DATA(:,2)*deflection;             % scale final dist to desired mag
if rot~=0,                                  % rotate direction
  for i=1:len,
    DATA(i,:)=rot2d(DATA(i,:),rot);
  end
end
DATA=[DATA(:,1)+startPt(1)              ... %
      DATA(:,2)+startPt(2)];

%_______ construct time ______
tf=1/Hz*(length(DATA)-1);                   % final sim time
t1=0:1/Hz:tf; t1=t1';                       % set desired time (as col vect)

%__ CALC rho (endpoint traj& deriv's) __
rho=DATA; 
[rho(:,3:4),rho(:,5:6)]=dbl_diff(rho,Hz,0); % calc higher derivatives
rho=[t1 rho];                               % add a time col

%___ CALC phi (joint angles & deriv's) __
phi=inverse_kinematics3(rho(:,2:3),0,L);    % joint (relative) ang 
%figure(4); subplot(2,1,1), plot(phi(:,1)/pi*180,phi(:,2)/pi*180,'.');
[phi(:,3:4),phi(:,5:6)]=dbl_diff(phi,Hz,0); % calc higher derivatives
phi=[t1 phi];                               % add a time col
  
%___ CALC q (seg angles & deriv's) __
q=inverse_kinematics3(rho(:,2:3),1,L);      % segment angles 
%figure(4); subplot(2,1,2), plot(q(:,1)/pi*180,q(:,2)/pi*180,'.');
[q(:,3:4),q(:,5:6)]=dbl_diff(q,Hz,0);       % calc higher derivatives
q=[t1 q];                                   % add a time col

%___ speed __
speed=sqrt(rho(:,4).^2+rho(:,5).^2);        % 1st col is time

%___ start of movement __
for St=4:size(rho,1)                        % Loop for each time rhoI sample
  if speed(St)>speedThresh,                 % find where mvmt begins
    break; 
  end;
end
if St==size(rho,1),                         % if no movement
  St=1;
  if verbose, 
    warning(' no speed threshold ',fcnName); 
  end      %
end   

if plotIt,
  clf;
  subplot(3,1,1);  plot(rho(:,2),rho(:,3),'.'); axis equal; title('rho')
  subplot(3,1,2);  plot(q(:,2),q(:,3),'.'); axis equal; title('q')
  subplot(3,1,3);  plot(phi(:,2),phi(:,3),'.'); axis equal; title('phi')
end

if verbose, 
  fprintf('~ END %s. ~',progname);
end % message

%figure(2); clf; plot(DATA(:,1),DATA(:,2)); axis('image')
