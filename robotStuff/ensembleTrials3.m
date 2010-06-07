% ************** MATLAB "M" function (jim Patton) *************
% load, average and save an ensemble of robot trials
% SYNTAX:     ensembleTrials(trialList,outName,CI,plotit,verbose,printIt)
% INPUTS:     trialList   list of trial #s
%             protocolNum (optional)
%             outName     name of output file
%             startList   startingpoint locations for each movement
%             CI          (optional) nonzero confidence CIs (default=0)
%             plotit      (optional) nonzero for plots (default=1)
%             verbose     (optional) nonzero for  messages(default=1)
%             printIt     (optional) nonzero for PS file of plots(default=1)
%             fsz         (optional) font size for plots
%             showForces  (optional) show force whiskers on the plots
% OUTPUTS:    meanStart   index of row in mean data that start of movement is detected 
% VERSIONS:   11/1/99 initiated
%             3/6/00 added outName as an input 
%             9/10/00  added printIt as input
%             9/29/0   CHANGE ensembleTrials.m to ensembleTrials2.m and allow for 
%                      "protocolNum" input
%             10/23/0  CHANGE ensembleTrials2.m to ensembleTrials3.m and allow 
%                      "startList" input
%             1/6/3    allow startlist input to be optional
%             8/24/05  added coments and new input - showForces
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function meanStart=ensembleTrials3(trialList,protocolNum,startList,outName,CI,plotit,verbose,printIt,fsz,showForces)

% __ SETUP __
fcnName='ensembleTrials3.m';
if ~exist('protocolNum')|isempty(protocolNum), protocolNum=1; end                     % if not passed 
if ~exist('outName')|isempty(outName), outName='0.dat'; end                           % if not passed     
if ~exist('startList')|isempty(startList), startList=zeros(length(trialList),2); end  % if not passed     
if ~exist('CI')|isempty(CI),CI=0; end                                                 % if not passed 
if ~exist('plotit')|isempty(plotit),  plotit=1; end                                   % if not passed 
if ~exist('verbose')|isempty(verbose),verbose=1;end                                   % if not passed
if ~exist('printIt'), printIt=1; end                                                  % if not passed
if ~exist('fsz')|isempty(fsz), fsz=7; end; 				                                    % if not passed
if ~exist('showForces')|isempty(showForces), showForces=1; end; 				              % if not passed
fScale=.2;                                            % amount of scaling for force whiskers (m/N)
Ntrials=length(trialList);                            % how many trials in this ensemble
speed_thresh_for_move=.1;                             % min speed
cutoff=10;                                            % cutoff freq for filtering
len=9999;                                             % init really big
Xshoulder2motor=findInTxt(                    ... %
 'parameters.txt','Xshoulder2motor=',0);              %
if isempty(Xshoulder2motor)                           %
  error('no "Xshoulder2motor" in "parameters.txt"')
end                                                   %
Yshoulder2motor=findInTxt(                    ... %
 'parameters.txt','Yshoulder2motor=',0);              %
if isempty(Yshoulder2motor)                           %
  error('no "Yshoulder2motor" in "parameters.txt"')
end                                                   %

%__ MESSAGES __
if verbose, fprintf('\n~ %s ~ ',fcnName); end         %
if verbose,  fprintf('  (%d trials)',Ntrials); end    %      

%____ ASSEMBLE CUBE OF DATA ____
if verbose,   fprintf('\n Trial: '); end
CUBE=[];                                              % init
for trial=1:Ntrials                                   %
  fprintf(' %d',trialList(trial));                    % message 
  filename=['p' num2str(protocolNum) '_'          ... % assign trial filename
            num2str(trialList(trial)) '.dat'];        %
  [rho,F,Hz]=loadRobotData(filename,cutoff,0);        % load & transform to subj c.s.
  if isnan(rho), fprintf(' rho=NaN! '); break; end;   % if no more files, quit
%   '  rho(:,1:2):',  rho(:,1:2)
  fprintf('  startList(trial,:) --> %f %f',  startList(trial,:));
  rho(:,1:2)=rho(:,1:2)-(startList(trial,:)'      ... % shift startpoint
    *ones(1,size(rho,1)))';    
  speed=sqrt(rho(:,3).^2+rho(:,4).^2);                % calc speed
  for St=1:length(speed)                              % loop: find start movemt
    if speed(St)>speed_thresh_for_move, break; end    % find mvmt initiation
  end                                                 %
  St=St-20; if St<1, St=1; end                        % go back in time 20 frames
  if verbose,  fprintf('(startFrame#%d)',St); end     %      
  %if verbose, fprintf('\nlen=%d, Cubesize:',len);end %      
  %size(CUBE)
  if len>length(St:length(speed)),                    % if ensemble length too long 
    len=length(St:length(speed));                     % shorten it to current length
    if ~isempty(CUBE), CUBE=CUBE(1:len,:,:); end      % if not empty, clip it down
  end
  CUBE(:,:,trial)=[ rho(St:St+len-1,:)            ...
                    F(St:St+len-1,:)              ... 
                    speed(St:St+len-1) ];             % stack on the trial's data on the cube
  t=(0:size(CUBE,1)-1)/Hz; t=t';
  pause(.01);
  if plotit,                                          % plot trajectory
    figure(1);                                        % position vs position 
    plot(CUBE(:,1,trial),CUBE(:,2,trial)          ... %
      ,'-','color',[.5 .5 .5]);
    axis equal; hold on; 
    if strncmp(lower(plotit),'vel',3)...
              |strncmp(lower(plotit),'speed',3),
      figure(2);                                      % speed vs time
      plot(t,CUBE(:,9,trial)                      ... %
        ,'-','color',[.5 .5 .5]);
      hold on; drawnow; pause(.01);
    end
  end   
end

%____ STATS on the CUBE OF DATA ____
if verbose, fprintf('\n  Average..');  end            %
%MEAN=cubeStat(CUBE,'mean',0);                        % do mean
MEAN=permute(nanmean(permute(CUBE,[3 1 2])),[2 3 1]); % mean -- fast?
if CI,                                                % calc 95% confidence CI
  if verbose, fprintf('\n Confidence (slow)..');end   % message 
  CI95=cubeStat(CUBE,'confidence',.95);               %  
end                                                   %

meanStart=startAndLength(MEAN(:,3:4));


%____ SAVE DATA ____
if verbose,fprintf('\nSave in Robot Coords..'); end   % message
saveDataman(                                      ... % 6 columns (2pos,2vel,2force)
[outName],                                        ... % file name
[   -MEAN(:,1)-Xshoulder2motor                    ... % Transform to Robot Coords
    -MEAN(:,2)+Yshoulder2motor                    ... % Transform to Robot Coords
    -MEAN(:,3:4)                                  ... % Transform to Robot Coords
    -MEAN(:,5:6);                                 ... % Transform to Robot Coords
 -7777 trial Hz 1 0 0;                            ... % 2nd to last line is params
 -7777 0 0 0 0 0]  ,1);                               % last line is params too

if CI
saveDataman(                                    ... % 6 columns (2pos,2vel,2force)
[outName '.CI95'],                              ... % file name
[   -CI95(:,1)-Xshoulder2motor                  ... % Transform to Robot Coords
    -CI95(:,2)+Yshoulder2motor                  ... % Transform to Robot Coords
    -CI95(:,3:4)                                ... % Transform to Robot Coords
    -CI95(:,5:6);                               ... % Transform to Robot Coords
 -7777 trial Hz 1 0 0;                          ... % 2nd to last line is params
 -7777 0 0 0 0 0]  );                               % last line is params too
end
fclose all

%____ PLOT ____
if plotit
  if verbose,   
    fprintf('\n Plotting..');  
  end
 
  %..XY PLOTS..
  figure(1)
  if CI,% confidence ellipses
    for i=1:size(CI95,1)
      ellipse(MEAN(i,1),MEAN(i,2),  ...
              CI95(i,1),CI95(i,2),  ...
              0,15,[.5 .99 .99]);
      hold on, axis equal 
    end
  end
    
  % mean trajectory  
  plot(MEAN(:,1),MEAN(:,2),'linewidth',3)
  hold on, axis equal 
  %title('positions');xlabel('x(m)');ylabel('y(m)')
  
  % forces
  if showForces,
    for i=1:4:size(MEAN,1)
      plot( [MEAN(i,1) MEAN(i,1)+fScale*MEAN(i,3)], ...
        [MEAN(i,2) MEAN(i,2)+fScale*MEAN(i,4)], 'color',[.2 .8 .2],'linewidth',1)
    end % END for i
  end% END if showForces

  % all trajectories
  fprintf('plotting trial:');
  for trial=1:Ntrials                                   %
    fprintf(' (trial %d)', trial); 
      %fprintf(' Cube size: %d x %d', size(CUBE)); 
    plot(CUBE(:,1,trial),CUBE(:,2,trial),'-',       ... %
      'color',[.5 .5 .5])  
  end
  fprintf('plotting trial:');

  %..VELOCITY PLOTS..
  if strncmp(lower(plotit),'vel',3)
    fprintf(' (Velocity plot) ')
    figure(2); set(gcf,'name','Velocity')
    legend(plot(MEAN(:,3:4),'linewidth',3),'x','y',-1)
    hold on
    %title('velocities');
    ylabel('m/s');xlabel('seconds')
    drawnow; pause(.001);
  elseif strncmp(lower(plotit),'speed',3)
    fprintf(' (Speed plot) ')
    figure(2); set(gcf,'name','Speed')
    if CI,                                              % if confidence desired (ellipses)
      for i=1:size(CI95,1)                              %
        ellipse(t(i),MEAN(i,9), 1/Hz,CI95(i,2),     ... %
          0,15,[.5 .99 .99]);                           %
        hold on,                                        %  
      end
    end % end if CI
    
    % mean speed  
    plot(t,MEAN(:,9),'linewidth',3)
    
    % all trials speeds
    for trial=1:Ntrials                                 % loop for each trial
      plot(t,CUBE(:,9,trial),'-','color',[.5 .5 .5]);   %
      hold on,                                          %  
    end
    drawnow; pause(.001);
  end

  % fianlize the plots
  if strncmp(lower(plotit),'vel',3)|strncmp(lower(plotit),'speed',3)
    figure(2)
    axis([0 1 0 1])
    plot([0 1],[0 0],'k:'); hold on                     % zero horizontal line
%     text(-.05,0, '0'                                ... %
%       ,'VerticalAlignment','middle'                 ... %
%       ,'HorizontalAlignment','right','Fontsize',fsz);
%     plot([.1 .2],[.95 .95],'k'); 
%     text(.15,.95, '0.1 sec'                         ... %
%       ,'VerticalAlignment','Top'                    ... %
%       ,'HorizontalAlignment','center','Fontsize',fsz);
%     plot([-.01 .01 0 0 -.01 .01 ],[ 0 0 0 1 1 1],'k'); 
%     text(-.05,.5, 'Speed (m/sec)'                   ... %
%       ,'Rotation',90                                ... %
%       ,'VerticalAlignment','bottom'                 ... %
%       ,'HorizontalAlignment','center','Fontsize',fsz);
%     text(-.05,1, '1'                                ... %
%       ,'VerticalAlignment','middle'                 ... %
%       ,'HorizontalAlignment','right','Fontsize',fsz);
  end
  
  figure(1)                                            % go back to other figure
  
  %..PRINT ..
  if printIt,
    if verbose, 
      fprintf(['\n Printing figure to '            ...
        outName '.Ensemble.ps..']);
    end
    
    suptitle(str2mat('Ensemble average trajectories',outName,cd));
    cmd=['print -dpsc2 ' outName '.Ensemble.ps'];
    disp(cmd); eval(cmd)
    
    if strncmp(lower(plotit),'vel',3)|strncmp(lower(plotit),'speed',3)
      figure(2)
      suptitle(str2mat('Ensemble average speeds',outName,cd));
      cmd=['print -dpsc2 -append ' outName '.Ensemble.ps'];
      disp(cmd); eval(cmd)
    end
  end % END if printIt
  
end % END if plotIt

if verbose, fprintf('\n~ END %s. ~\n',fcnName); end        %
return
