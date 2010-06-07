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

 %__ANALYSIS__
 addGoodTrialColumn2targ;                            % 
%plotIFDForces;                                      % plot the SFD force fields (if any)
 doEnsembles2(CI,deflection);                        % 
% performMeas2(refFileroot,doPlot,doPrint,        ... % performance measures
%    analFrames,deflection);                         % 
% learnCurves(doPlot);                                % learning curves 
%stats(doPlot)                                       % statistical summary & plot

 if plotman,                                         % if view of person selected
    ellipse(-shoulderWidth/2,0,shoulderWidth/2,   ... % body/trunk
      shoulderWidth/6,0,20,[.8 .8 .9]);               %   
    ellipse(-shoulderWidth/2,0,shoulderWidth/8,   ... % head
      shoulderWidth/6,0,20,'k');                      %
    plot(-shoulderWidth/2,shoulderWidth/6,'^');       % nose
    plot(0,0,'o');                                    % shoulder joint
    plot(sum(L)*cos(60/180*pi:.1:120/180*pi),     ... % plot workspace
      sum(L)*sin(60/180*pi:.1:120/180*pi),'g');       % ...
    if C==1,                                          % if first window
      text(0,0,'  estimated shoulder positon',    ... %
        'fontsize',fsz)                               %
      text(0,sum(L)+.01,                          ... %
        '   estimated workspace boundary',        ... %
        'fontsize',fsz)                               %
    end                                               % END if C==1
  end                                                 % END if plotman
  
fprintf('\n~ END Analysis.m  ~ \n')

