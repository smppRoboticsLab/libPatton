%*********** MATLAB "M" script (jim Patton) *********** 
% plots the trials for this experiment.
% VERSIONS:	  INITIATED 9/99 by jim patton
%**********************  BEGIN:************************ 

function plotTrials3(trialsStruct,plotman,verbose)

%______________ SETUP ______________
global DEBUGIT L
fcnName='plot_trials3.m'; 
if ~exist('verbose'), verbose=1; end                  % if not passed 
if ~exist('plotman'), plotman=1; end                  % if not passed 
if verbose fprintf('~ %s ~',fcnName); end % 
if ~exist('trialsStruct')|isempty(trialsStruct),      % if not passed
  trialsStruct=setPlotStruct(verbose);                % sets these for local 
end                  
cutoff=10;
Hz=100;
set_params;
figure(2); clf; orient tall; 
set(gcf,'color',[1 1 .9]), put_fig(2,.5,.12,.5,.8)
figure(1); clf; orient tall; 
set(gcf,'color',[1 1 .9]), put_fig(1,.1,.1,.5,.8)
fsz=7; LT='-';LW=.1;                                  % plot params
speed_thresh_for_move=.1;                             % min speed
Xs2n=.2;                                              % 
Ys2m=find1TXTvalue('parameters.txt',              ... % load this from a paramter file
  'Yshoulder2motor=',0);                              %
timeD=(0:length(rhoD(:,4))-1)/Hz;  
tSynchD=timeD(St_D);

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
  plot(rhoD(:,2),rhoD(:,3),'r:');                     % desired traj
  axis equal; hold on; axis off                       % 
  set(gca,'fontsize',fsz);                            % 
  [mrDx,mrDxi]=max(rhoD(:,2));                        %  
  if C==1,                                            % if first window
    text(rhoD(mrDxi,2),rhoD(mrDxi,3)              ... % put labels for things
      ,' desired trajectory','fontsize',fsz);         %  
  end                                                 %
  plotbox(startX,startY,.01,'g',0);                   % start targ locaion
  plotbox(targX,targY,.01,'g',0);                     % end targ location
  title(trialsStruct(C).name,                     ... % subplot title
    'fontWeight','bold','fontsize',fsz+2)
  if plotman, % if selected 
    ellipse(-Xs2n,0,Xs2n,Xs2n/3,0,20,[.8 .8 .9]);     % body
    ellipse(-Xs2n,0,Xs2n/4,Xs2n/3,0,20,'k');          % head
    plot(-Xs2n,Xs2n/3,'^');                           % nose
    plot(0,0,'o');                                    % shoulder joint
    plot(sum(L)*cos(60/180*pi:.1:120/180*pi),     ... % plot workspace
      sum(L)*sin(60/180*pi:.1:120/180*pi),'g');       % ...
    plot([.25 .35],[.2 .2],'k');                      % 
    if C==1,                                          % if first window
      text(0,0,'  estimated shoulder positon',    ... %
        'fontsize',fsz)                               %
      text(0,sum(L)+.01,                          ... %
        '   estimated workspace boundary',        ... %
        'fontsize',fsz)                               %
      text(.3,.2,'0.1 m',                         ... %
        'VerticalAlignment','bottom','fontsize',fsz)  %
    end                                               % END if C==1
  end                                                 % END if plotman
  
  % __ setup plot 2 __
  figure(2); 
  subplot(ceil(length(trialsStruct)/2),2,C);          % 
  plot(timeD-tSynchD,speedD,'r:');        % desired traj
  hold on;
  set(gca,'fontsize',fsz);                            % 
  [mrDx,mrDxi]=max(speedD);                     %  
  if C==1,                                            % if first window
    text(timeD(mrDxi)-tSynchD,              ... % put labels for things 
         speedD(mrDxi)                      ... %
      ,' desired trajectory','fontsize',fsz);         %  
  end                                                 %
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
      if speed(St)>speed_thresh_for_move, 
        tSynch=time(St); 
        break; 
      end;
    end
    
    [vip,vaf]=velocityInnerProd(rho(:,1:4),rhoD(:,2:5));
    vipMat(j,C)=vip;    
    vafMat(j,C)=vaf;    
    
    figure(1); 
    if C>=4&C<=6&j==1, plotFieldInfluence; end        % plot circle of influnece of RCB
    plot(rho(:,1),rho(:,2),LT,'linewidth',LW);        % plot trial data *********
    %plot(rho(:,1),rho(:,2),'.');                     % plot trial data *********
    
    figure(2); 
    plot(time-tSynch,speed,LT,'linewidth',LW);        % plot trial data *********
    drawnow, pause(.1);                               % REFRESH SREEN
  end                                                 % END for j  
  plotbox(startX,startY,.01,'g',0);                   % redraw on top
  plotbox(targX,targY,.005,'g',0);                    % redraw on top
    
end;                                                  % END for C

% __ finishing touches  __
figure(1)
%suptitle(['xy trajectories from ' cd ', plotted ' whenis(clock)]);
print -depsc2 traj
print -dpsc2 trajectories
figure(2)
%suptitle(['Speeds from ' cd ', plotted ' whenis(clock)]);
print -dpsc2 -append trajectories

vafMat,vipMat

mat2txt('vaf.txd',hdr,vafMat);
mat2txt('vip.txd',hdr,vipMat);

fprintf('\n~ end %s ~\n',fcnName);
