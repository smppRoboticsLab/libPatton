%************** MATLAB "M" fcn ************
% batch file to Analyze data
% SYNTAX:     analysis 
% REVISIONS:  10/25/00 (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

function analysis(verbose)
fprintf('\n~ Analysis.m (analysis function) ~')

% __SETUP__
CI=0;                                               % zero for do not compute
CI=.95;                                            % confidence interval for ensembles
doPlot='individual';                                %
doPrint=1;                                          %
Hz=100;                                             %

% __LOAD/SET PARAMETERS___
analFrames=findInTxt('parameters.txt',          ... % duration of the force field
  'force field duration=')*Hz;                      % 
if isempty(analFrames), analFrames=.2*Hz; end       % 
deflection=findInTxt('parameters.txt',          ... % desired bend in trajectory
        'trajectory deflection=')                   %   
if isempty(deflection),                             % IF NONE GIVEN
  fprintf('\n\7Deflection is empty - set to zero. ')% message
  deflection=0;                                     % default
end                                                 % 
refFileroot=findInTxt('parameters.txt',         ... % desired bend in trajectory
        'refFileroot=','s');                        % name of the phase of baseline 
                                                    %  trajectories for comparing

% __ANALYSIS__
addGoodTrialColumn2targ;                            % 
plotIFDForces;                                      % plot the SFD force fields (if any)
doEnsembles2(CI,deflection);                        % 
%performMeas2(refFileroot,doPlot,doPrint,        ... % performance measures
 %   analFrames,deflection);                         % 
%learnCurves(doPlot);                                % learning curves 
%stats(doPlot)                                       % statistical summary & plot


fprintf('\n~ END Analysis.m  ~ \n')

