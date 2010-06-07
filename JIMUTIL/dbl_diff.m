% ************** MATLAB "M" function  (jim Patton) *************
% Velocity and acceleration calulations from a time record(s).
% UIses the simple central, 2 point method.
%  SYNTAX:  [vel,acc]=dbl_diff(pos,hz,verbose);
%  INPUTS:  pos       vector or matrix (rows=time steps) 
%           hz        sample frequency
%           verbose   nonzero for no messages
%  OUTPUTS:	
%  CALLS:	
%  INITIATIED:	 9/14/97 patton initated.
%                4/6/99 FIXED VERBOSE VARIABLE (patton)
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [vel,acc]=dbl_diff(pos,Hz,verbose);

%______ SET ______
if ~exist('verbose'), verbose=1; end;               % set to default
if verbose, fprintf(' ~~ dbl_diff.m ~~ '); end      % message
dt=1/Hz;                                            % samp intervl
[rows,cols]=size(pos);                              % # records
if rows<cols, pos=pos'; [rows,cols]=size(pos); end; % transpose if wrong
vel=zeros(rows,cols); acc=vel;                      % predimesion

%______ VELOCITY ______
for t=2:rows-1                                      % loop: ea record
  vel(t,:)=(pos(t+1,:)-pos(t-1,:))./(2*dt);         % velocity calc
end; % for t                                        % end loop
vel(1,:)=pos(2,:)-pos(1,:);                         % startpoint
vel(rows,:)=pos(rows,:)-pos(rows-1,:);              % endpoint

%______ ACCELERATION ______
for t=2:rows-1                                      % loop: ea record
  acc(t,:)=(vel(t+1,:)-vel(t-1,:))./(2*dt);         % velocity calc
end; % for t                                        % end loop
acc(1,:)=vel(2,:)-vel(1,:);                         % startpoint
acc(rows,:)=vel(rows,:)-vel(rows-1,:);              % endpoint

if verbose, fprintf(' ~ END dbl_diff.m ~ '); end    % message 

