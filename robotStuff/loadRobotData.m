% ************** MATLAB "M" function (jim Patton) *************
% Load data in robot coordinates and convert to subject coords. 
% Filter with a 5th order 2-pass (filtfilt.m)
% SYNTAX:     [rho,force,Hz]=loadRobotData(filename,cutoff,verbose);
% INPUTS:     cutoff    cutoff freq for filter (Hz). Zero for no filtering.
% OUTPUTS:   
% VERSIONS:   9/23/99   INITIATED by Patton 
%             9/24/99   added cutoff and filtering
%             9/25/99   added v1 & v2 as return values
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [rho,force,Hz,v1,v2]=loadRobotData(filename,cutoff,verbose,plotit,forceNoise,posNoise);

%_________ SETUP ________
global DEBUGIT                                      % g=accel due to gravity
fcnName='loadRobotData.m';                          % name of this fcn
if ~exist('forceNoise'), forceNoise=0; end          % if not passed
if ~exist('posNoise'), posNoise=0; end              % if not passed
if ~exist('plotit'), plotit=0; end                  % if not passed
if ~exist('verbose'), verbose=1; end                % if not passed
if ~exist('cutoff'), cutoff=10; end                 % if not passed
if verbose,                                         % message
  fprintf('\n%s:"%s"..',fcnName,filename);
end
filtOrder=5;                                        % cutoff freq for filter (Hz)
Xshoulder2motor=findInTxt('parameters.txt',            ... % load this from a paramter file
  'Xshoulder2motor=',0);                             %
Yshoulder2motor=findInTxt('parameters.txt',            ... % load this from a paramter file
  'Yshoulder2motor=',0);                            %
rho=NaN; force=NaN; Hz=NaN;                         % init

%___ LOAD trial data ___
[DATA,v1,v2]=loadDataman(filename,0);               % 
if DATA==-1;                                        % halt if no file found
  fprintf(' !cant load %s! ',filename); 
  return; 
end                                                 
Hz=v1(3);                                           % extract sampling freq
len=length(DATA(:,1));

%__ ADD artificial noise (for stochastic models) __
if forceNoise,
  if verbose,
    fprintf('adding force noise (%f)..',forceNoise);% message
  end
  DATA(:,5:6)=DATA(:,5:6)+forceNoise*randn(len,2);% corrupt data with noise
end
if posNoise,
  if verbose,
    fprintf('adding kin noise (%f)..',posNoise);    % message
  end
  DATA(:,1:4)=DATA(:,1:4)+posNoise*randn(len,4);% corrupt data with noise
end

%___ filter ___
if cutoff,
  if verbose,
    fprintf('filtering (low pass %dHz)..',cutoff);  % message
  end
  fDATA=butterx(DATA,Hz,filtOrder,cutoff);          % filter data
else
  if verbose, fprintf(' (no filtering) '); end      % message
  fDATA=DATA;
end

%___ extract and transform ___
if verbose,
  fprintf('Transforming to subject Coords..');      % message
end
rho=[-Xshoulder2motor-fDATA(:,1)                ... % extract&transform xy pos
      Yshoulder2motor-fDATA(:,2)];
[vel,acc]=dbl_diff(rho,Hz,0);                       % refine this later !!!
rho=[rho vel acc];                                  % put derivatives on rho
force=-fDATA(:,5:6);                                % extract endpoint force 

if plotit
  clf; orient tall;
  %subplot(4,1,1),plot(rho(:,3:4));title('Velocity')
  %subplot(4,1,2),plot(rho(:,5:6));title('Force')
  subplot(4,1,1:3),plot(fDATA);hold on;
  legend(plot(DATA,'.'),'x','y','dx','dy','fx','fy');
  title('All data')
  subplot(4,1,4),plot(rho(:,1),rho(:,2),'.');
  axis equal;
  drawnow;
  suptitle(filename);
end

if verbose,
  fprintf(' END %s.\n',fcnName);
  %fprintf(' pause...'); pause;
end

return