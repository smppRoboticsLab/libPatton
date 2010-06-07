% ************** MATLAB "M" function (jim Patton) *************
% load, average adn save an ensemble of robot trials
% SYNTAX:     ensembleTrials(trialList,outName,doCI95,plotit,verbose,printIt)
% INPUTS:     trialList   list of trial #s
%             outName     name of output file
%             doCI95      (optional) nonzero confidence intervals (default=0)
%             protocol    (optional)
%             plotit      (optional) nonzero for plots (default=1)
%             verbose     (optional) nonzero for  messages(default=1)
%             printIt     (optional) nonzero for PS file of plots(default=1)
% OUTPUTS:  
% VERSIONS:   11/1/99 initiated
%             3/6/00 added outName as an input 
%             9/10/00  added printIt as input
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function ensembleTrials2(trialList,outName,interval,plotit,verbose,printIt)

% __ SETUP __
fcnName='ensembleTrials.m';
if ~exist('protocol'),  protocol=1;end                % if not passed 
if ~exist('outName'), outName='0.dat'; end            % if not passed     
if ~exist('doCI95')|isempty('doCI95'),  doCI95=0; end % if not passed 
if ~exist('plotit')|isempty('plotit'),  plotit=1; end % if not passed 
if ~exist('verbose')|isempty('verbose'),verbose=1;end % if not passed
if ~exist('printIt'), printIt=1; end                  % if not passed
Ntrials=length(trialList);
speed_thresh_for_move=.2;                             % min speed
cutoff=10;                                            % cutoff freq for filtering
len=9999;                                             % init really big
Xshoulder2motor=find1TXTvalue(                    ... %
 'parameters.txt','Xshoulder2motor=',0);              %
if isempty(Xshoulder2motor)                           %
  error('no "Xshoulder2motor" in "parameters.txt"')
end                                                   %
Yshoulder2motor=find1TXTvalue(                    ... %
 'parameters.txt','Yshoulder2motor=',0);              %
if isempty(Yshoulder2motor)                           %
  error('no "Yshoulder2motor" in "parameters.txt"')
end                                                   %

%__ MESSAGES __
if verbose, fprintf('\n~ %s ~ ',fcnName); end        %
if verbose,  fprintf('  (%d trials)',Ntrials); end    %      

%____ ASSEMBLE CUBE OF DATA ____
if verbose,   fprintf('\n Trial: '); end
CUBE=[];                                              % init
for trial=1:Ntrials
  fprintf(' %d',trialList(trial));                    % message 
  %fprintf('\n trial %d',trialList(trial));                    % message 
  filename=['FD-' num2str(trialList(trial)) '.dat'];  % assign trial filename
  [rho,F,Hz]=loadRobotData(filename,cutoff,0);        % load & transform to subj c.s.
  if isnan(rho), fprintf(' rho=NaN! '); break; end;   % if no more files, quit
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
  CUBE(:,:,trial)=[rho(St:St+len-1,:) F(St:St+len-1,:)];
  if plotit
    figure(1); %subplot(2,1,1); 
    plot(CUBE(:,1,trial),CUBE(:,2,trial),':')
    hold on,    
    figure(2); %subplot(2,1,2); 
    plot(CUBE(:,3:4,trial),':')
    hold on
    %disp('  hit a key...');pause
  end
end

%____ ASSEMBLE CUBE OF DATA ____
if verbose, fprintf('\n  Average..');  end
MEAN=cubeStat(CUBE,'mean',0);
if doCI95, % calc 95% confidence interval
  if verbose, fprintf('\n  Confidence..');  end
  CI95=cubeStat(CUBE,'confidence',.95);
end

%____ SAVE DATA ____
if verbose,fprintf('\nSave in Robot Coords..'); end % message
saveDataman(                                    ... % 6 columns (2pos,2vel,2force)
[outName],                                      ... % file name
[   -MEAN(:,1)-Xshoulder2motor                  ... % Transform to Robot Coords
    -MEAN(:,2)+Yshoulder2motor                  ... % Transform to Robot Coords
    -MEAN(:,3:4)                                ... % Transform to Robot Coords
    -MEAN(:,5:6);                               ... % Transform to Robot Coords
 -7777 trial Hz 1 0 0;                          ... % 2nd to last line is params
 -7777 0 0 0 0 0]  );                               % last line is params too

if 0
saveDataman(                                    ... % 6 columns (2pos,2vel,2force)
[outName '.CI95'],                              ... % file name
[   -CI95(:,1)-Xshoulder2motor                  ... % Transform to Robot Coords
    -CI95(:,2)+Yshoulder2motor                  ... % Transform to Robot Coords
    -CI95(:,3:4)                                ... % Transform to Robot Coords
    -CI95(:,5:6);                               ... % Transform to Robot Coords
 -7777 trial Hz 1 0 0;                          ... % 2nd to last line is params
 -7777 0 0 0 0 0]  );                               % last line is params too
end

%____ PLOT ____
if plotit
  if verbose,   
    fprintf('\n Plotting..');  
  end
 
  %..XY PLOTS..
  figure(1); %subplot(2,1,1);
  if doCI95,% confidence ellipses
    for i=1:0%size(CI95,1)
      ellipse(MEAN(i,1),MEAN(i,2),  ...
              CI95(i,1),CI95(i,2),  ...
              0,15,[.5 .99 .99]);
      hold on, axis equal 
    end
  end
    
  % mean trajectory  
  plot(MEAN(:,1),MEAN(:,2),'linewidth',3)
  hold on, axis equal 
  title('positions'); xlabel('x(m)');ylabel('y(m)')

  %..VELOCITY PLOTS..
  figure(2); %subplot(2,1,2); 
  legend(plot(MEAN(:,3:4),'linewidth',3),'x','y',-1)
  hold on
  title('velocities');ylabel('m/s');xlabel('seconds')
  drawnow; pause(.001);
  
  figure(1)
  
  %..PRINT ..
  if printIt,
    if verbose, 
      fprintf(['\n Printing figure to '            ...
        outName '.Ensemble.ps..']);
    end
    
    figure(1)
    suptitle(str2mat('Ensemble averages:',outName,cd));
    cmd=['print -dpsc2 ' outName '.Ensemble.ps'];
    disp(cmd); eval(cmd)
    
    figure(2)
    suptitle(str2mat('Ensemble averages:',outName,cd));
    cmd=['print -dpsc2 -append ' outName '.Ensemble.ps'];
    disp(cmd); eval(cmd)
  end % END if printIt
  
end % END if plotIt

if verbose, fprintf('\n~ END %s. ~\n',fcnName); end        %
return
