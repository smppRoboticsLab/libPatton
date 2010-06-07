% ************** MATLAB "M" script (jim Patton) *************
% design a training field via copycat Sys ID and regional control bases (RCB)
% SYNTAX:    
% INPUTS:    
% OUTPUTS:  
% VERSIONS:  6/13/00 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

% __ SETUP __
global DEBUGIT M L R g EPpas Kpas Bpas field_gain field_type
global RCB rc
scriptName='fieldDesign.m';
fprintf('\n\n\n~ %s SCRIPT ~\n',scriptName)             % title message
figure(1); 
if ~exist('plotit'), plotit=1; end                      % if not passed

eval(['diary ' scriptName '.log']);                   % keep record of this
fprintf('\n\n\n~ BEGIN analysis for %s at %s ~\n' ... %
  ,cd,whenis(clock))                                  %   
set_params                                            % setup most values 
!erase ccFit.ps 
protocolNum=1;                                        % aanalyze the first part
load trialsStruct_p1                                  % load trial categories
startTrial=min(trialsStruct(1).trials);               % first for analysis
[trialHeader,trialData]=hdrload('targ_p1.txd');       % load targets & trial info
fitIt=1;                                      % init flag for fit
CCB=[];                                       % initialize to nothing
CCwings.impedanceSpread=.3;                   % fractional +/- amount 
CCwings.massSpread=.1;                        % fractional +/- amount 
CCwings.geometrySpread=.025;                  % absolute +/- amount 
CCwings.shoulderSpread=.02;                   % absolute +/- amount 
spreadScale=1;                                % for scaling the above
maxTime=.2;                                   % final time for all fiting analyses
Mag=mean(trialData(:,8));                     % magnitude for each movement
deflection=.3*Mag;                            % desired deviation from straight line

%if ~exist('trajectories.ps'),plot_trials4([],0); end % PLOT part 1 trials
baseList=baseline(Dirs,trialsStruct,trialData)        % ensemble avg trials

% ___ determine trials for analysis ___  
perturbTrials=trialsStruct(2).trials%(1:2);
%  perturbTrials=perturbTrials(1:ceil(length(perturbTrials)/2));
NperturbTrials=length(perturbTrials);
fprintf('\n%d perturbation trials :',NperturbTrials); 
fprintf(' %d',trialsStruct(2).trials);
  
% ___ FIT COPYCAT ___
if exist('CCB.mat')
  fprintf('\nLOADING preexisting CCB:\n')
  load CCB
  CCB
else
  fprintf('\n\n\n ___ Fitting CCBs: ___: '); 
  fprintf('\n Fitting %d trials:',length(perturbTrials))  
  fprintf(' %d',perturbTrials);
  CCB=setupCopycat3([],M,L,R,Kact,Bact,0,0          ... % initialize copycat bases
                    ,CCwings,spreadScale)               %
  [CCB,CCr,CCsveErr,CCfracErr]=ccFit9(CCB,maxTime,  ... % fit copycat model 
    perturbTrials,fitIt,CCwings,protocolNum);           
  fprintf('\n END of Fitting CCBs: \n '); 
  save CCB CCB CCr CCsveErr CCfracErr  
end

% __ RC FIELD DESIGN __
fprintf('\n ___ REGIONAL CONTROL BASES (RCB): ___: '); 
widths=[]; centers=[];                                  % init
if 1,
  for i=1:nDirs
    i
    widths(i)=1.3*Mag;
    centers(i,:)=startPt+0.3*Mag*[cos(Dirs(i)/180*pi)...
                                  sin(Dirs(i)/180*pi)];
  end
  widths(i+1)=1.9*Mag; centers(i+1,:)=startPt;
  setupRCB(widths,centers);                             %
else
  setupRCB(1.9*Mag,startPt)
end
RCB
[RCB,rcr]=rcFit8(CCB,maxTime,startPt,Dirs,Mag,deflection);

% PLOT
field_gain=zeros(2,2); 
for i=1:length(RCB), 
  field_gain=field_gain+RCB(i).rc*RCB(i).B; 
end; 
field_type='viscous'; 
figure(2); clf; field_plot(8); axis equal
title('field at centerpoint')

saveRCB
save RCB RCB

% __ FINAL ___
fprintf('\n ~ END %s at %s ~ \n',scriptName,whenis(clock))%  
diary off                                               % 
playwav('done.wav');                                    % play sound      
return
