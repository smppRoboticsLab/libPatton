% ************** MATLAB "M" function (jim Patton) *************
% Evaluate a robot control basis model
% SYNTAX:     F=rcEval(rho,RCB,verbose);
% INPUTS:    
% OUTPUTS:    Mforce    N by 2 matrix rows=time_steps, cols=joint_torqes
% VERSIONS:   9/14/99   INITIATED by Patton 
%             9/28/99   renamed ccEval3 and began multiple centers
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function F=rcEval3(rho,RCB,verbose);

%_________ SETUP ________
fcnName='rcEval3.m';
global DEBUGIT 
if ~exist('verbose'), verbose=1; end                  % if not passed
if verbose,fprintf('\n ~ %s ~ \n',fcnName); end       %
len=length(rho(:,1));

for i=1:len
  d=(RCB.C-rho(i,1:2))';                              % distance vect 2 center
  EXP=exp(-.5*d'*RCB.K*d);                            % local influnence component
  vis=rho(i,3:4)*RCB.B;                               % viscous component
  F(i,1:2)=EXP*vis;
end

if verbose,fprintf(' ~ END %s ~ \n',fcnName); end     %
return

