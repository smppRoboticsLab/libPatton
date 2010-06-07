%************** MATLAB "M" function  *************
% analyze data: performance measures and plot individual traject
% SYNTAX:     performMeas(doPlot,doPrint)
% REVISIONS:  2/8/2000  (patton) INITIATED
%             9-1-0 RENAMED analysis1.m from fastLearnCurves.m (patton)
%             10-25-0 renamed performMeas.m
%             11/3/0 add deflection
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function performMeas2(refFileroot,doPlot,doPrint,aFrames,deflection)

% ____ SETUP ____
prog_name='performMeas.m';                              % name of program
fprintf('\n~ %s ~ ', prog_name);                        % MSG
if ~exist('doPlot'), doPlot=1, end                      % if not passed
if ~exist('doPrint'), doPrint=0, end                    % if not passed
if ~exist('aFrames')|isempty(aFrames), aFrames=20, end  % if not passed
if ~exist('refFileroot')|isempty(refFileroot),          % if not passed
  refFileroot=findInTxt('parameters.txt',          ...  % desired bend in traj
        'Reference filename root=','s')                 % 
  if isempty(refFileroot)
    refFileroot='Unperturbed_baseline'
  end
end
if ~exist('deflection'), deflection=0, end              % if not passed
EM=NaN*zeros(300,16);
set_params;                                             %
drawnow;
verbose=1; plotIt=1;                                    % switches for display
fsz=8;                                                  % font size
mkrSz=2;                                                % marker size
names=[];
spacing=0.005;                                          % figural error
Fscale=.005;
cutoff=10;
colors='mcrgbymcrgbymcrgbymcrgbymcrgby';
cumTrial=0;                                             % init
speedThresh=.1;                                         % for initiation of movement
dName=['desired.txd'];                                  %"DESIRED" MVMT pattern 
measureNames=str2mat(                               ... % measure names
      'Initial resampled figural error with desired'... %
     ,'Initial infinity norm with desired'          ... %
     ,'Initial direction error with desired'        ... %
     ...
     ,'Initial resampled figural error with baseline'... %
     ,'Initial infinity norm with baseline'         ... %
     ,'Initial direction error with baseline'       ... %
     ...
     ,'Initial Maximum speed'                       ... % 
     ...
     ,'Overall resampled figural error with desired'... %
     ,'Overall infinity norm with desired'          ... %
     ...
     ,'Overall resampled figural error with baseline'... %
     ,'Overall infinity norm with baseline'         ... %
     ...
     ,'Overall Maximum speed'                       ... %
     ...
     ,'Speed velocity difference with desired'         ... %
     ,'Speed velocity difference with baseline'         ... %
     );
Nmeas=size(measureNames,1);
fPrefix='FD-'; fSep='';
fPrefix='P';   fSep='_';
 
%__setup figure__
if doPlot,
  for i=1:3
    figure(i);clf; put_fig(i,(i-1)*.3+.08,.45,.32,.45);       % window
  end
  figure(1); 
   
  if doPlot==1,  % __plot ENVIRONMENT __   
    tempX=[];     tempY=[];   
    for i=-.1:.01:pi+.1,                                    % setup arc of workspace
      tempX=[tempX; sum(L)*cos(i)];  
      tempY=[tempY; sum(L)*sin(i)];
    end
    plot(tempX,tempY,'g'); hold on; axis image; % axis off;
    ellipse(-.2,0,.2,.2/3,0,20,[.8 .8 .9]);                 % body
    plot(-.2,.2/3,'^');                                     % nose triangle
    ellipse(-.2,0,.2/4,.2/3,0,20,'k');                      % head 
    plot(0,0,'o');                                          % shoulder joint
  end

  % __plot "dummy" trial__
  d_handle=plot(0,.45,'r.'); hold on; axis image; %axis off;
  D_handle=plot(0,.45,'b.');
  BL_handle=plot(0,.45,'g.');
  F_handle=plot(0,.45,'m');
  FsSeg=[0 Fscale*1];   
  Fs_handle=plot(FsSeg,[0 0],'m-','linewidth',3);           %
  FsT_handle=text(0,0,'1 N','fontsize',fsz              ... %
    ,'VerticalAlignment','bottom'                       ... %
    ,'horizontalAlignment','center');                       %
  set(gca,'fontsize',fsz)
  drawnow; pause(.001)
end

% ____ setup output file ____
h=['Measures of performance (& error) for ' cd]; 
h=str2mat(h,... 
  ['Generated by ' prog_name ', ' whenis(clock)],... 
  '____phases:____');
colLbl=['Trial' char(9) 'part' ];                    % init w/tabSeparator
for meas=1:Nmeas,
  colLbl=[colLbl char(9) ... 
      deblank(measureNames(meas,:))]; 
end % END for meas 
   
% ____ LOOP for EACH part ____
part=0;   
while(1)
  part=part+1;
  
  %__ load TARGETS __ 
  filename=['targ_p' num2str(part) '.txd']; 
  if(~exist(filename,'file')) fprintf('\nNo more parts\n');break;end % stop if no more parts
  fprintf('\n\nPart %d Trials:\n~~~~~~\n',part);              % 
  [trialHeader,trialData]=hdrload(filename);                  % targets & trial info
  nPhases=findInTxt(filename,'Number of Phases=','s');
  Dirs=sort(distill(trialData(:,7))'); nDirs=length(Dirs);    % 
  Mag=mean(trialData(:,8));                                   % magnitude o ea.movement
  if ~exist('deflection')                                     % if not passed
    deflection=.3*Mag;
  end           
  filename=['trialsStruct_p' num2str(part) '.mat'];
  if(~exist(filename)) fprintf('\nNo more parts\n');break;end % stop if no more parts
  load(filename);                     %
  for phase=1:length(trialsStruct)
    h=str2mat(h,['Part ' num2str(part) ', phase '         ...
     num2str(phase) ': ' deblank(trialsStruct(phase).name)]);
  end
  
  % ____ LOOP for EACH part & TRIAL  ____
  fprintf('\nLooping through each trial.. \n');                 %
  for trial=1:size(trialData,1) % trial 79 is a perturb?
    cumTrial=cumTrial+1;
    fprintf(' %d',trial); pause(.001);
    
    % ____ load TRAJECTORY ____
    filename=[fPrefix num2str(part) fSep num2str(trial) '.dat'];
    %fprintf('\n direction: %f ',trialData(trial,7));
    [D,F,Hz]=loadRobotData(filename,cutoff,~verbose); 
    if doPlot
      figure(2);subplot(2,1,1);plot(D);
      subplot(2,1,2);plot(F);figure(1)
    end
    if isnan(D), cumTrial=cumTrial-1; break; end 
    t=0:size(D,1)-1; t=t./Hz; t=t'; D=[t D]; % add time col
    
    % ____ Find the direction ____
    subjCSdirection=trialData(trial,7)+180;
    if subjCSdirection>360, 
      subjCSdirection=subjCSdirection-360; 
    end
    %fprintf('\n direction: %f ',trialData(trial,7));
    %fprintf(' In Subj Coords: %f ',subjCSdirection);
    for Dir=1:nDirs,                                          % determine direction
      if trialData(trial,7)==Dirs(Dir); 
        %fprintf('\n Match for direction %d. ',Dir)
        break; 
      end
    end
    
    % __load BASELINE & DESIRED__
    startTarg=[-Xshoulder2motor Yshoulder2motor]          ... % convert to subject coords
       -trialData(trial,2:3);                                 % 
    if exist(dName),                                          %

      %___ DESIRED REFERENCE ___
      %fprintf('\n Desired: %s(%d deg)..',filename,Dirs(Dir));%      
      d=getIdealTrajectory(dName,L                        ... % load & transform
       ,startTarg,Dirs(Dir)*pi/180-pi,Mag,deflection      ... % 
       ,speedThresh,0);                                       %
      %fprintf('Done. \n');                                   %
      
      %___ BASELINE REFERENCE ___
      filename=[refFileroot '.'                           ... % 
            num2str(Dirs(Dir)) '.ensemble.dat'];              %
      if exist(filename,'file')                               %
        BL=loadRobotData(filename,cutoff,0);                  % load & transform to subj c.s.
        BL(:,1:2)=BL(:,1:2)+(startTarg'*ones(1,size(BL,1)))'; %  
        tBL=0:size(BL,1)-1;tBL=tBL./Hz;tBL=tBL';BL=[tBL BL];  % add time col
      elseif exist([refFileroot '_rotated_trials.'        ... % 
             num2str(Dirs(Dir)) '.ensemble.dat'],'file')      % 
        BL=loadRobotData([refFileroot '_rotated_trials.'  ... % 
             num2str(Dirs(Dir)) '.ensemble.dat'],cutoff,0);   % load & transform to subj c.s.
        BL(:,1:2)=BL(:,1:2)+(startTarg'*ones(1,size(BL,1)))'; %  
        tBL=0:size(BL,1)-1;tBL=tBL./Hz;tBL=tBL';BL=[tBL BL];  % add time col
      elseif exist([refFileroot '_rotated_directions.'    ... % 
             num2str(Dirs(Dir)) '.ensemble.dat'],'file')      %
        BL=loadRobotData([refFileroot '_rotated_directions.'...% 
             num2str(Dirs(Dir)) '.ensemble.dat'],cutoff,0);   % load & transform to subj c.s.
        BL(:,1:2)=BL(:,1:2)+(startTarg'*ones(1,size(BL,1)))'; %  
        tBL=0:size(BL,1)-1;tBL=tBL./Hz;tBL=tBL';BL=[tBL BL];  % add time col
      else 
        fprintf(' \n    Cannot find "%s" ', filename);
        fprintf(' \n    - using NaN for trial %d. ',trial);
        BL=NaN;
      end  
      %fprintf('\n  BL: (%dx%d)',size(BL,1),size(BL,2));
    end

    % __plot current trial__
    if doPlot,
      F_=[];
      for i =1:1:size(D)
        F_=[F_;                                         ...
            D(i,2:3);                                   ...
            D(i,2:3)+Fscale*F(i,1:2);                   ...
            NaN NaN];
      end
      set(d_handle,'XData',d(:,2),'YData',d(:,3));
      set(D_handle,'XData',D(:,2),'YData',D(:,3));
      if ~isnan(BL),
        set(BL_handle,'XData',BL(:,2),'YData',BL(:,3));
      end                                                               %
      set(F_handle,'XData',F_(:,1),'YData',F_(:,2));                    %
      qq=D(1,2)+.01+FsSeg;                                              % x pos legend for force
      rr=D(1,3)+.005*[1,1];                                             % y pos le...
      set(Fs_handle,'XData',qq,'YData',rr);                             % place legend bar
      set(FsT_handle,'Position',[sum(qq)/2,rr(1)]);                     % place txt
      axis equal; axis image; %ax=axis; axR=[ax(2)-ax(1),ax(4)-ax(3)];  % axis settings
      title(['Part ' num2str(part) ', trial '                       ... %
        num2str(trial) ' Gain=' num2str(trialData(trial,6))]);
      drawnow; pause(.001); 
      if doPrint,
        if part==1&trial==1
          print -dpsc2 indivTraject
        else
          print -dpsc2 -append indivTraject
        end    
      end % END if doPrint
    end % END of doPlot
    
    % ____ starting points ____
    dSt=startAndLength(d(:,4:5),size(d,1),speedThresh);
    DSt=startAndLength(D(:,4:5),size(D,1),speedThresh);
    if ~isnan(BL)
      BLSt=startAndLength(BL(:,4:5),size(BL,1),speedThresh);
    else
      BLSt=1;
    end
    
    % for trials with little or no movement:
    if DSt>size(D,1)-aFrames, 
      for i=2:size(D,1)
        if D(i,1)-D(1,1)>.005 | D(i,2)-D(1,2)>.005
          DSt=i;
          fprintf(' (no velocity in this movement; starFr=%d) ',DSt)
          break
        end
      end     
    end       % if bad, use 1st frame past 5 mm

    % for trials with little or no movement:
    if BLSt>size(BL,1)-aFrames, 
      fprintf(' (no mvmnt in baseline!) ')
      BLSt=1;
    end       % if bad, use 1st frame past 5 mm
    
    % ____ MEASURES ____
    %if plotIt, figure(3); clf; end
%     d,D
%     d(dSt:dSt+aFrames,1:3),           ... %
%       D(DSt:DSt+aFrames,1:3)
    [FigErr,InfNorm]=figuralError(d(dSt:dSt+aFrames,1:3),           ... %
      D(DSt:DSt+aFrames,1:3),spacing,~verbose,~plotIt);                 %
    [FigErr_all,InfNorm_all]=figuralError(d(:,1:3),D(:,1:3),        ... %
      spacing,~verbose,~plotIt);                                        %
    if plotIt, figure(1);  end                                          % reset plot
    InitDirErr=initial_direction_error(D(:,2:3),                    ... %
      d(:,2:3),.25,~verbose,~plotIt);
    
    % speed and velocity chebychev
    speed_D=sqrt(D(:,4).^2+D(:,5).^2);                                  % calculate speed
    [maxSpeed_all,maxSpeedFr]=max(speed_D(8:size(speed_D,1)-8));        % find max, not ends
    maxSpeedEarly=max(speed_D(DSt:DSt+aFrames,1));                      % early max
    speedDif_d=velocityErr(D(:,4:5),d(:,4:5));
    
    if ~isnan(BL),                                                      % check for baseline data
      %if plotIt, figure(3); clf; end
      BLaFrames=aFrames;
      if(BLSt+BLaFrames>size(BL,1)),                                    % clip if short(bad)
        BLaFrames=size(BL,1)-BLSt; 
        fprintf(' (shortening BL analysis frames) ');  
      end
      
      [FigErr_BL,InfNorm_BL]=figuralError(BL(BLSt:BLSt+BLaFrames,1:3),... %
        D(DSt:DSt+aFrames,1:3),spacing,~verbose,~plotIt);                 %
      [FigErr_BL_all,InfNorm_BL_all]=figuralError(BL(:,1:3),          ... %
        D(:,1:3),spacing,~verbose,~plotIt);                               %
      
      if plotIt, figure(1); end
      InitDirErr_BL=initial_direction_error(D(:,2:3),                 ... %
        BL(:,2:3),.25,~verbose,~plotIt);
      speedDifBL=velocityErr(D(:,4:5),BL(:,4:5));
    else
      FigErr_BL=NaN; 
      InfNorm_BL=NaN; 
      FigErr_BL_all=NaN; 
      InfNorm_BL_all=NaN; 
      InitDirErr_BL=NaN;
      speedDifBL=NaN;
    end
    EM(cumTrial,:)=[trial part                                      ... % 
                    FigErr        InfNorm         InitDirErr        ... % stack into EM matrix
                    FigErr_BL     InfNorm_BL      InitDirErr_BL     ... %
                    maxSpeedEarly                                   ... %
                    FigErr_all    InfNorm_all                       ... %           
                    FigErr_BL_all InfNorm_BL_all                    ... %
                    maxSpeed_all                                    ... %
                    speedDif_d speedDifBL           ];                  % 
     
    %__ STORE EVERY SO MANY TRIALS __
    if trial/10==round(trial/10), 
      fprintf('  Store data.. \n'); 
      mat2txt('performMeas.txd',str2mat(h,colLbl),EM); 
      drawnow; pause(.001);
    end
    fclose all;
  end % END for trial 
  
  fprintf('\nDONE with trials for part %d. ',part); 
  if part==1 & exist('part2')                                           % for backwards compatibility
      cd part2; cd;
      [trialHeader,trialData]=hdrload('targ.txd');                      % load targets & trial info
      load trialsStruct                                                 % load trial categoriesw
      wd=parse(cd,'\'); wd=wd(size(wd,1),:);                            % working directory
  end                              
  if part==2 & strcmp(wd,'part2'); 
    cd ..
  end                                                                   % change to new directory
  
end % END for part

% final save
h=str2mat(h,  ...
  ['Number of Parts=' num2str(part-1)],colLbl);
mat2txt('performMeas.txd',h,EM); 

fprintf('\n~ END %s ~ ', prog_name); 
