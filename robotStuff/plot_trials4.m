%*********** MATLAB "M" script (jim Patton) *********** 
% plots the trials for this experiment.
% VERSIONS:	  INITIATED 9/99 by jim patton
%**********************  BEGIN:************************ 

function plotTrials4(trialsStruct,plotman,verbose)

%______________ SETUP ______________
global DEBUGIT L RCB rc
fcnName='plot_trials4.m'; 
if ~exist('verbose'), verbose=1; end                  % if not passed 
if ~exist('plotman'), plotman=1; end                  % if not passed 
if verbose fprintf('~ %s ~',fcnName); end % 
if ~exist('trialsStruct')|isempty(trialsStruct),      % if not passed
  if ~exist('trialsStruct.mat')
    trialsStruct=setPlotStruct(verbose);              % sets these for local 
  else
  load trialsStruct 
  end
end                  
figure(2); clf; orient tall; 
set(gcf,'color',[1 1 .9]), 
put_fig(2,.5,.12,.5,.8)
figure(1); clf; orient tall; 
set(gcf,'color',[1 1 .9]), 
%put_fig(1,.1,.1,.5,.8)
fsz=7; LT='-';LW=.1;                                  % plot params 
set_params;                                           % all modeling params 
[trialHeader,trialData]=hdrload('targ.txd');          % load targets & trial info
%put_fig(2,.15,.15,.9,.9); orient landscape;
%put_fig(1,.1,.1,.9,.9); orient landscape;
put_fig(2,.15,.15,.55,.55); orient landscape;
put_fig(1,.1,.1,.55,.55); orient landscape;

% __ LOOP FOR EACH structure in array trialsStruct __
hdr=[];
for C=1:length(trialsStruct),
  numTrials=length(trialsStruct(C).trials);
  hdr=[hdr trialsStruct(C).name setstr(9) ];
  fprintf('\nCategory #%d -- "%s" (%d trials): '  ... %
    ,C,trialsStruct(C).name,numTrials);  
  
  % __ setup plot 1 __
  figure(1);
  subplot(ceil(length(trialsStruct)/2),2,C);          % 
  plot([.05 .15],[.3 .3],'k');                        % 
  text(.1,.3,'0.1 m'  ...
      ,'VerticalAlignment','bottom' ...
      ,'HorizontalAlignment','center' ...
      ,'FontSize',fsz);
  axis equal; hold on; axis off                       %   
  set(gca,'fontsize',fsz);                            %  
  title(trialsStruct(C).name,                     ... % subplot title
    'fontWeight','bold','fontsize',fsz+2)
  for Dir=1:nDirs                                      % loop for each trajectory 
    rhoD=getIdealTrajectory('sin-morphed.txd',L   ... % GET "DESIRED" MVMT
     ,startPt,Dirs(Dir)*pi/180-pi,Mag,deflection  ... %
     ,speedThresh,0);                                 %
    %plot(rhoD(:,2),rhoD(:,3),'r:');               ... %
  end  
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
  
  % __ setup plot 2 __
  figure(2); 
  subplot(ceil(length(trialsStruct)/2),2,C);          % 
  %plot(timeD-tSynchD,speedD,'r:');                   % desired traj
  plot(0,0)
  hold on;
  set(gca,'fontsize',fsz);                            % 
  %[mrDx,mrDxi]=max(speed);                           %  
  %if C==1,                                           % if first window
  %  text(timeD(mrDxi)-tSynchD,                   ... % put labels for things 
  %%       speedD(mrDxi)                          ... %
  %    ,' desired trajectory','fontsize',fsz);        %  
  %end                                                %
  title(trialsStruct(C).name,                     ... % subplot title
    'fontWeight','bold','fontsize',fsz+2)
  ylabel('m/s')
  xlabel('seconds')
  
  % __ LOOP FOR EACH trial in the list __
  for j=1:numTrials                                   % 
    trial=trialsStruct(C).trials(j);                  %
    fprintf(' %d',trial);                             %
    fileN=['FD-' num2str(trial) '.dat'];
    [rho,force,Hz,v1,v2]=loadRobotData(fileN,cutoff,0);% load data
    t=(0:length(rho(:,1))-1)/Hz;                      % create a time domain
    speed=sqrt(rho(:,3).^2+rho(:,4).^2);
    time=(0:length(rho(:,1))-1)/Hz;
    for St=1:length(speed)
      if speed(St)>speedThresh, 
        tSynch=time(St); 
        break; 
      end;
    end
    
    figure(1); 
    if 0%trialData(trial,6)==3&j==1,
      plotFieldInfluence;                             % plot circle of influnece of RCB
    end        
    plot(rho(:,1),rho(:,2),LT,'linewidth',LW);        % plot trial data *********
    %plot(rho(:,1),rho(:,2),'.');                     % plot trial data ********* 
    startX = -trialData(trial,2);                     % convert to subj coords
    startY =  Yshoulder2motor-trialData(trial,3);
    targX  = -trialData(trial,4);
    targY  =  Yshoulder2motor-trialData(trial,5);
    plotbox(startX,startY,.01,'g',0);                   % redraw on top
    plotbox(targX,targY,.01,'g',0);                    % redraw on top
    
    figure(2); 
    plot(time-tSynch,speed,LT,'linewidth',LW);        % plot trial data *********
    drawnow, pause(.1);                               % REFRESH SREEN
  end                                                 % END for j  
    
end;                                                  % END for C

% __ finishing touches  __
figure(1)
%suptitle(['xy trajectories from ' cd ', plotted ' whenis(clock)]);
print -dpsc2 -append trajectories
figure(2)
suptitle(['Speeds from ' cd ', plotted ' whenis(clock)]);
print -dpsc2 -append trajectories

fprintf('\n~ end %s ~\n',fcnName);
