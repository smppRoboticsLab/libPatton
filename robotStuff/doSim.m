%______*** MATLAB "M" script (jim Patton) ***_______
% "Copycat" sys-ID on virtual subject to design a field that causes desired traj
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
% VERSIONS:	  INITIATED 5/5/99 jim patton
%__________________________ BEGIN: ____________________________

fprintf('\n\n\n\n\n\n\n\n');                   % clear screen 
fprintf('_______________________________\n\n') % message 
fprintf('~Field Design "doSim.m" script~\n')   % message 
fprintf('_______________________________\n')   % message

%__________ SETUP ____________
global M L R g
global EPpas Kpas Bpas 
global graphicsParams Gcounter
global field_gain field_type 
set_params;                                   % set parameters up 
[trialHeader,trialData]=hdrload('targ.txd');  % load targets & trial info
load trialsStruct                             % load list of trials
firstPass=1;

%__ stocatstic elements __
playwav('menu.wav')
if (menu('add noise?','nope','yep')-1)
  forceNoise=0.001                            % estimate ~ .01;
  posNoise=0.001                              % estimate ~ .001;
  velNoise=0                                  % ?
else
  forceNoise=0;                               %;
  posNoise=0;                                 % 
  velNoise=0;                                 % ?
end                                           % END if menu

%__ make virtual subject slightly different__
if 0,
  M(1,1)=1.05*M(1,1);                         
  M(1,2)=0.95*M(1,2);                         % 
  M(2,1)=1.03*M(2,1);                         % 
  M(2,2)=1.1*M(2,2);                          % 
  R(1)=.98*R(1);
  R(2)=1.02*R(2);
  L(1)=.96*L(1);                              % 
  L(2)=1.05*L(2);                             % 
  Bact(2,2)=1.1*Bact(2,2);                    % 
  Bact(1,1)=1.3*Bact(1,1);                    % 
  Kact(1,2)=.89*Kact(1,2);                    % 
  Kact(2,2)=1.08*Kact(2,2);                   % 
else
  fprintf('\n\n params not varied! \n\n\');   
  %playwav('params_not_varied.wav');          % sound message
end

%__________ TRIALS LOOP ____________
%trial=0; trial=trialsStruct(1).trials(1)-1;
fprintf('\n\n');   
trial=input('Enter Start trial: ')-1;
while(trial<size(trialData,1))                % loop for each trial
  figure(2);
  trial=trial+1;                              % 
  direction=trialData(trial,7);
  fprintf('\n%s\n_Begin Trial %d ',sep,trial);% message
  fprintf('(direction=%d):_\n',direction);    % message
  startPt
  
  %__ load virtual subject's intended mvmt __
  fName=['pt2pt.txd'];
  if verbose, 
    fprintf('\n    Load "I" (%s)...',fName); 
  end
  [rhoI,qI,phiI,t1,StI,speedI]=           ... % load file and manipulate data
   getIdealTrajectory(fName,L             ... %
   ,startPt, direction*pi/180-pi,Mag      ... %
   ,0,speedThresh,0);                         %
  len=length(t1);                             % 
  intended_joint_states=[ phiI(:,1:5)];       % assemble sim input eq traj
  Fexpected=zeros(length(t1),2);              % init expect zero field forces
  if verbose, fprintf('Done. '); end          % message 
  endPt=[Xshoulder2motor Yshoulder2motor] ... %
       -trialData(trial,4:5);                 %

  %__ GET "DESIRED" MVMT OF EXPERIMENTER __
  fName=['sin-morphed.txd'];
  if verbose, 
    fprintf('\n    Load "D" (%s)...',fName); 
  end
  [rhoD,qD]=getIdealTrajectory(fName,L    ... %
   ,startPt, direction*pi/180-pi,Mag      ... %
   ,deflection,speedThresh,0);                %
  if verbose, fprintf('Done. '); end          % message
 
  %__ Set Field/Conditions for this trial __
  if trialData(trial,9)>2,                    % phases after learning
    field_type='rc'                           % 
    field_gain=zeros(2,2);                    %
    junk=rhoI(:,2:7);                         %  
    Fexpected=field4([rhoI(:,2:7)         ... % expected field forces 
                     junk                 ... % no longer used
                     junk],1);                %
  end
  if trialData(trial,6)==0,                   % null field
    field_type='null';        
    field_gain=[0 0;0 0];
  elseif trialData(trial,6)>-50           ... % viscous
       & trialData(trial,6)<50,
    field_type='viscous'       
    field_gain=trialData(trial,6)*[0 -1; 1 0];%
  elseif trialData(trial,6)>50            ... % inertial
       & trialData(trial,6)<150,
    field_type='inertial'        
    field_gain=(trialData(trial,6)-100)   ... %
      *[0 -1; 1 0]                            %
  elseif trialData(trial,6)==1000             % RCB type force field
    field_type='rc'                           %
    field_gain=zeros(2,2); 
    for i=1:length(RCB), 
      field_gain=field_gain+RCB(i).rc*RCB(i).B; 
    end; 
    field_gain=-field_gain; 
    clf; field_plot(8); axis equal
  else
    fprintf(' No field type recognised. ')
  end
  fprintf('\nField type: %s\n',field_type);     % message 
  
  %__ FFWD based on INTENT & EXPECTED FORCE__ 
  Cff=inverse_dynamics2(qI(:,2:7),        ... % feedforward Torques based on  
   [Fexpected zeros(len,1)],M,L,R,g,~verbose);%  intended motion & expected force 
  Cff=[t1 Cff(:,1:2)];                        % add time col to feedfwd torque
  
  %_______ SIMULATION _______
  figure(1); pre_plot;                        % setup plot windows for results
  ICs=[qI(1,2) 0; qI(1,3) 0];                 %  ROWS=segment,COL1=pos,COL2=vel
  tf=max(t1);                                 %
  fprintf('\n\nTrial %d :',    trial);        % message
  fprintf('\nSIMULATE %d sec..',tf);pause(.1);% message
  sim('sim_df2',tf); fprintf('DONE.\n');      % ***** SIMULATION *****
  load chirp; sound(y(1:600));
  
  %___ RESAMPLE OUTPUT UNIFORMLY IN TIME ___  
  posvelacc=interp1(time,posvelacc,t1);       %
  force=interp1(time,force,t1);
  C=interp1(time,C,t1);
  Cfb=interp1(time,Cfb,t1);   
  simTime=time; time=t1; 
  
  %_____ POST SIMULATION ANALYSES _____
  fprintf('\n  Analysis: \n');
  rho=forward_kinematics2(posvelacc);
  T=inverse_dynamics2(posvelacc,          ... % calc torqes from motion
      [force 0*t1],M,L,R,g);                  %  and endpoint force
  D=inverse_dynamics2(posvelacc,          ... % calc torqes from motion
      zeros(len,3),M,L,R,g);                  %  only
  post_plot                                   % plot the results
  
  %__ ADD  noise (for stochastic models) __
  if forceNoise,
    fprintf('\nCORRUPTING FORCE: ');          % message
    fprintf('(forceNoise=%f)',forceNoise);    % message
    force=force+forceNoise*randn(len,2);      % corrupt data with noise      
  end
  if posNoise,
    fprintf('\nCORRUPTING POSITION: ');       % message
    fprintf(' (posNoise=%f)',posNoise);       % message
    rho(:,1:2)=rho(:,1:2)+posNoise*randn(len,2);% corrupt data with noise
  end
  if velNoise,
    fprintf('\nCORRUPTING VELOCITY: ');       % message
    fprintf(' (velNoise=%f)',velNoise);       % message
    rho(:,3:4)=rho(:,3:4)+posNoise*randn(len,2);% corrupt data with noise
  end

  %_____ STORAGE _____
  if     strcmp(field_type,'null'),    FT=0;  % field type codes used in saving
  elseif strcmp(field_type,'stiff'),   FT=1;
  elseif strcmp(field_type,'viscous'), FT=2;
  elseif strcmp(field_type,'inertial'),FT=3;
  elseif strcmp(field_type,'rc'),      FT=4;
  elseif strcmp(field_type,'rr'),      FT=5;
  else                                 FT=-8888;
  end  
  fprintf(' (Transform to Robot Coords & save) ');  
  saveDataman(                            ... % 6 columns (2pos,2vel,2force)
   ['FD-' num2str(trial) '.dat'],         ... % file name
   [   -rho(:,1)-Xshoulder2motor          ... % Transform to Robot Coords
       -rho(:,2)+Yshoulder2motor          ... % Transform to Robot Coords
       -rho(:,3:4)                        ... % Transform to Robot Coords
       -force;                            ... % Transform to Robot Coords
    -7777 trial Hz 1 0 0;                 ... % 2nd to last line is params
    -7777 FT field_gain(1:4)]  );             % last line is params too
  save field_design_vars                      % store everything each trial
  %if trial==Nfields, save post_perturb;  end % also store finished w/perturb's
  
  %_____ print _____
  figure(1);
  if firstPass
    print -dpsc2 sim_plots
    firstPass=0;
  else
    print -dpsc2 -append sim_plots
  end  
  
  fprintf('\n Trial %d DONE on %s. ',     ... %
    trial,whenis(clock)); 
 
end  % END while 

plot_trials4([],0);

%_____ final stuff for this script _____
playwav('done.wav');                        % play sound      
fprintf('\n ~ END main.m ~ \n\n')

