%************** MATLAB "M" function  *************
% find startframe of a traj, based on speed threshold
% SYNTAX:     [startFrame,v,speed]=MovementOnset(x,t,speedThresh,plotIt);
% INPUTS:     x             position vector (in R-n) where n=the dimension
%                           of the space.
%             t             either the time interval for each step (scalar)
%                           or a set of regular times correcponding to x
%             speedThresh   threshold of v for detecting movement onset
% OUTPUTS:    St            frame# that start of movement was detected
%             v             velocity optional output
%             speed         speed optional output
% REVISIONS:  07-15-2006    init from StartAndLength.m to have 
%                           general formula for 2 or 3 dimensions
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~
function [startFrame,v,speed]=movementOnset(x,t,speedThresh,plotIt);

%% SETUP
if ~exist('speedThresh'), speedThresh=.1; end       % if not passed
if ~exist('plotIt'), plotIt=0; end                  % if not passed
startFrame=NaN;                                     % init to NaN

%% CONSTRUCT TIME & Sample Freq (Hz)
if length(t)==1,                                    % 
  Hz=1/t;                                           %
  t=(0:size(x,1)-1)*t;                              %
else                                                %
  Hz=1/(t(3)-t(2));                                 % sampling freq
end                                                 %

%% differnetiate
v=dbl_diff(x,Hz,0);                                 % differnetiate

%% SCAN for start frame #
for i=2:length(v(:,1)),                             % Loop:each v time step
  speed(i)=sqrt(sum(v(i,:).^2));                    % speed calc
  if(isnan(startFrame)&speed(i)>speedThresh),       % findWhere mvmt begins
    startFrame=i; 
  end;        
end
if(isnan(startFrame)); startFrame=1; end
%% plot
if plotIt
  figure(9575); clf;
  subplot(2,1,1)
  plot(t,x,'.'); hold on
  subplot(2,1,2)
  plot(t,v,'.'); hold on
  plot(t,speed,'ko','markersize',3);
  plot(t(startFrame),speed(startFrame),'k+','markersize',60)
  drawnow; 
end

return


