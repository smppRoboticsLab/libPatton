% ************** MATLAB "M" fcn (jim Patton) *************
% create robot control babis from data using copycat, & save.
% SYNTAX:    
% INPUTS:    
% OUTPUTS:  
% VERSIONS:  3/7/99 INITATED by patton from set_params.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

function [rhoD,qDesired,phiDesired,t1,St_D]= ...
  get_desired_trajcectory(startXr,startYr,targXr,targYr,Dir,deflection)

% __ SETUP __
fcnName='rcFit5.m';
global DEBUGIT 
if ~exist('verbose'), verbose=1; end                  % if not passed
if ~exist('deflection'), deflection=0; end            % if not passed
if verbose, fprintf('\n ~ %s ~ \n',fcnName); end      %

movmtDistance=sqrt((startXrr-targXr)^2 + ...
                   (targYr-startY)^2);
startX  =-Xshoulder2nose-startXr; 
targX   =-Xshoulder2nose-targXr;                      % convert to subj coords
startY  = Yshoulder2motor-startYr;  
targY   = Yshoulder2motor-targYr;   
startPoint=[startX startY];

[rhoD,qDesired,phiDesired,t1]=                    ... % SET "DESIRED" TRJECTORY
   get_trajectory('nonBel.txd',                   ... % trajFileName,
   Dir*pi/180,                                    ... % rot,mag,cntrPt,verbose)
   [movmtDistance -deflection],                   ... %
   startPoint);                                       %
speedD=sqrt(rhoD(:,4).^2+rhoD(:,5).^2);               % 1st col is time
for St_D=4:size(rhoD,1)                               % Loop for each time rhoI sample
  if speedD(St_D)>speedThresh,                        % find where mvmt begins
    break; 
  end;
end
if St_D==size(rhoD,1),                                % if no movement
  St_D=1;
  if verbose, fprintf('\n ~ %s ~ \n',fcnName); end      %
end   

