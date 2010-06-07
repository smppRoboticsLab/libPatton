%************** MATLAB "M" function  *************
% Analyze data: ensemble average plots
% SYNTAX:     doEnsembles(CI,deflection,what2do,plotDims,plotAxes,fsz)
% INPUTS:     NOTE THAT ALL ARE OPTIONAL (enter an empty matrix for default)
%             CI          (optional) shaded confidence interval you want  
%                         displayed for the trajectrotries (example: 0.95) default is
%                         zero=none
%             deflection  (optional) remnamnt of old studies, amount of  
%                         stretch in the lateral direction that you want to 
%                         display for the desired trajectory.
%             what2do     (optional) list that specifies what to plot:
%                           what2do(part).phases says what to plot for each
%                           phase ineach part. 
%             plotDims    (optional) [#rows,#cols] of subplots
%             plotAxes    (optional) 1-by-4 input axis(), for scaling 
%             fsz         (optional) font size for plots
%             Dirs        (optional) movement directions to do (in degress)
%             
%             showForces  (optional) show force whiskers on the plots
% REVISIONS:  2/8/2000  (patton) INITIATED
%             9-1-0     RENAMED analysis4.m from fastLearnCurves.m (patton)
%             10/25/00  RENAMED doEnsembles.m
%             4-2-01    UPGRADED doEnsembles2.m
%             6-17-01   allowed what2do input that specifies which phases to plot
%             8-23-05   commenting, added dirs2plot, new input showForces
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function doEnsembles2(CI,deflection,what2do,plotDims,plotAxes,fsz,Dirs,showForces)

% ____ SETUP ____
prog_name='doEnsembles2.m';                                   % name of this program
fprintf('\n~ %s ~ ', prog_name);                              % MSG
if ~exist('CI'), CI=0, end                                    % if not passed
if ~exist('deflection'),                                      % if not passed
  deflection=findInTxt('parameters.txt',                  ... % desired bend in trajectory
            'trajectory deflection=')                         % 
  %pauser
end                                                           %
if isempty(deflection), fprintf('!\7'); deflection=0, end     %
set_params;                                                   %
if ~exist('what2do'), what2do=[]; end                         % if not passed
if ~exist('fsz')|isempty(fsz), fsz=8; end; 				            % if not passed
if ~exist('showForces')|isempty(showForces),showForces=1; end;% if not passed
verbose=1; plotIt=1; printIt=1;                               % switches for display
mkrSz=2;                                                      % marker size
baseDir=cd;                                                   %
Dname=['desired.txd'];                                        %
part=0;                                                       % init
PC=0;                                                         % init plotCount
gray=.7*ones(1,3);                                            % rgb triple for plots
firstTimeThru=1;                                              %
wd=parse(pwd,'\'); wd=deTabBlank(wd(size(wd,1),:));           % get name of directory
totalNplots=8; 
firstTime=1;

%__setup figures__
for i=2:-1:1
  figure(i);clf; 
  put_fig(i,(i-1)*.4+.2,.05,.45,.85);           
  orient landscape
end
  put_fig(1,.1,.05,.84,.87);           

% ____ find number of plots - LOOP for EACH part ____ 
if ~exist('plotDims')|isempty(plotDims),
  totalNplots=0;                                              % 
  fprintf('\n Finding # of plots.'); 
  part=0;
  while(1)
    fprintf('.'); 
    part=part+1;  
    filename=['targ_p' num2str(part) '.txd']; 
    if(~exist(filename))break; end                            % stop if no more parts
    phasesOinterest=findInTxt(filename,'phases of interest=');% load phases to do work on
    if isempty(phasesOinterest),                              % if nothing there
      totalNplots=8;                                          % 
      plotDims=[2,ceil(totalNplots/2)];                       % rows cols of plot window
      break
    else
      totalNplots=totalNplots+length(phasesOinterest);
      plotDims=[3,ceil(totalNplots/3)];                       % 2 rows X cols of plot window
    end 
  end % END while
end % END if isempty

% ____ LOOP for EACH part ____ 
fprintf('\nDoing ensembles:'); 
part=0;
while(1)
  part=part+1;
%   if part==2; part=3; end
  fprintf('\n\npart %d:\n~~~~~~',part); 
  
  %__ load TARGETS __ 
  filename=['targ_p' num2str(part) '.txd']; 
  if(~exist(filename))                                        % stop if no more parts
    fprintf('\nCannot find %s. -No more parts\n',filename);
    break;
  end 
  fprintf('\n\nPart %d Trials:\n~~~~~~\n',part);              % 
  [trialHeader,trialData]=hdrload(filename);                  % targets & trial info
  movDirections=textract(filename,'Dir(deg)');
  nPhases=find1TXTvalue(filename,'Number of Phases=','s');
  if ~exist('Dirs')|isempty(Dirs)
    Dirs=sort(distill(movDirections'))
  end
  nDirs=length(Dirs);    % 
  Mag=mean(trialData(:,8));                                   % magnitude o ea.movement
  if isempty(what2do)
    phasesOinterest=findInTxt(filename,'phases of interest=') % load phases to do work on
    if isempty(phasesOinterest),                              % if nothing there
      phasesOinterest=('enter phasesOinterest: ');            % user input
    end 
  end
  goodTrials=textract(filename,'Good trial');                 % load column of data
  if goodTrials(1,1)==-8888,                                  % if not there
    goodTrials=ones(size(trialData,1),1);                     % make a column of all good
  end
  trialsStruct=probeTrialsStruct2(part,'verbose');                    % structure of names & list of

  % ____ LOOP for EACH part & TRIAL  ____
  for phase=1:length(trialsStruct)
    fprintf('\n\n\n___\n Phase %d ("%s" for %s): ',phase,        ...
      deTabBlank(trialsStruct(phase).name), cd); 
    drawnow
    
    if ~isempty(what2do)                                      % if there what2do was passed
      phasesOinterest=what2do(part).phases;                   % unpack
    end
        
    if(sum(phase==phasesOinterest))                           % if phase is on list
      PC=PC+1;                                                % increase plotCount
      for i=1:2                                               % each plot window
        figure(i); subplot(plotDims(1),plotDims(2),PC)        
        plot(0,0,'w.'); hold on
        set(gca,'clipping','off')
        title([char(64+PC) '. '                           ... % number the plot windows  
          str2mat(trialsStruct(phase).name)],'fontsize',fsz);
        set(gca,'fontsize',fsz);
        axis off;
     end
      
      % ___ loop for each dir ___
      for Dir=1:nDirs,                                        % determine direction
        fprintf('\n  Direction %d: ',Dirs(Dir)); 
      
        % determine sub-list of trials that match Dir and phase
        trials=[]; starts=[];                                 % init
        for i=1:length(trialsStruct(phase).trials)
          trial=trialsStruct(phase).trials(i);
          if movDirections(trial)==Dirs(Dir),                 % if match direction
            trials=[trials trial];                            % stack onto list
            startTarg=[-Xshoulder2motor Yshoulder2motor]  ... % convert to subject coords
                      -trialData(trial,2:3);
            starts=[starts; startTarg];
          end
        end % END for i        
        
        if ~isempty(trials)                                   % skip if no trials 
          fprintf('\n                            Trials:'); 
          fprintf(' %d',trials);
          i=1;
          while(i<=length(trials))
            %fprintf(' <i=%d trial=%d good=%d>',  ...
            %     i,trials(i),goodTrials(trials(i)))
            if ~goodTrials(trials(i)),                        % if not good,
              trials(i)=[];                                   % CLIP IT
              fprintf('(bad)');                               % message
            end      
            i=i+1;
          end
          fprintf('\n    Trials after clipping bad ones:'); 
          fprintf(' %d',trials);
          Ename=[trialsStruct(phase).name  '.'            ... % ouput filename
               num2str(Dirs(Dir)) '.ensemble.dat'];           %
          Ename=strrep(Ename,' ','_');
          if Dir==1,plotIt='speed'; else plotIt=1; end
          meanStart=ensembleTrials3(trials,part,starts    ... % *** perform ensemble ***
           ,Ename,CI,plotIt,verbose,~printIt,fsz,showForces);% ... & return  
          %pauser;
          if firstTime,
            figure(2)
            plot([0 1],[0 0],'k:'); hold on                     % zero horizontal line
            text(-.05,0, '0'                                ... %
              ,'VerticalAlignment','middle'                 ... %
              ,'HorizontalAlignment','right','Fontsize',fsz);
            plot([.1 .2],[.95 .95],'k'); 
            text(.15,.95, '0.1 sec'                         ... %
              ,'VerticalAlignment','Top'                    ... %
              ,'HorizontalAlignment','center','Fontsize',fsz);
            plot([0 0],[.7 .8],'k'); 
            text(0,.75, '0.1 m/sec'                         ... %
              ,'Rotation',90                                ... %
              ,'VerticalAlignment','bottom'                 ... %
              ,'HorizontalAlignment','center','Fontsize',fsz);
            firstTime=0;
          end
          
          % __load refernce (desired) __
          if exist(Dname)
            fprintf('\n LOAD REFERENCE: %s for %d deg..', ... %
              Dname,Dirs(Dir));                               %
            D=getIdealTrajectory(Dname,L                  ... % load & transform
            ,[0,0],Dirs(Dir)*pi/180-pi,Mag,deflection     ... % 
            ,speedThresh,0);                                  %
            D(:,1)=[];                                        % clip time column
            %fprintf('Done. \n');                             % 
          else 
            filename=['Unperturbed baseline.'             ... % 
                num2str(Dirs(Dir)) '.ensemble.dat']; 
              filename=strrep(filename,' ','_');
              if exist(filename)
                fprintf('\n LOAD REFERENCE: %s, %d deg..', ...%
                 filename,Dirs(Dir));                           %      
                D=loadRobotData(filename,cutoff,0);             % load & transform to subj c.s.
              else 
                fprintf(' \7 Cannot find %s! ',filename)          
              D=[];
            end  
          end % end if exist Dname
          if ~isempty(D),                                     % if no reference
            figure(1);
            plot(D(:,1),D(:,2),'r.','markersize',4);          % plot reference position *********
            [DStart,Dlength,Dspeed]=startAndLength(D(:,3:4)); % find speed threshold frame
            
            if Dir==1,                                        % if dir=1
              figure(2);
              Dtime=(0:length(Dspeed)-1)*.01; Dtime=Dtime';
%               DStart,meanStart,Dtime,length(Dtime)
              if meanStart>length(Dtime), meanStart=5; end
              Dtime=Dtime+Dtime(meanStart)-Dtime(DStart);     % shift to line time up with mean
              plot(Dtime,Dspeed,'r.','markersize',4);         % plot reference velocity *********
            end
                          
          end                                                 % end if ~isempty(D)
          drawnow; pause(.00001)                              % 
        else
          fprintf(' - no trials for this direction. \n')
        end % END if ~isempty(trials)
      end % END for Dir (directions)
  
      % ___ finalize and print ___
      %suptitle(('Ensemble trials for',                 ...
      %  trialsStruct(phase).name ,cd));
      %title(str2mat(trialsStruct(phase).name))
      %if firstTimeThru,
      %  cmd=['print -dpsc2 ' baseDir '\ensembles.ps']; 
      %  firstTimeThru=0;
      %else
      %  cmd=['print -dpsc2 -append ' baseDir '\ensembles.ps'];  
      %end
      if exist('plotAxes')&~isempty(plotAxes), 
        figure(1); axis(plotAxes); axis 
      else
        figure(1); axis image;
      end
   else
     fprintf(' (skipping) ')    
   end % END if doEnsemble
    
  end % END for phase

  fprintf('\nDONE with trials for part %d. ',part); 
  if part==1 & exist('part2')                                 % for backwards compatibility
      cd part2; cd;
      [trialHeader,trialData]=hdrload('targ.txd');            % load targets & trial info
      load trialsStruct                                       % load trial categoriesw
  end                              
end % END for part

cd(baseDir); cd

for i=1:2
  figure(i);
  hdl=textOnPlot(['(Subject ' wd ')'],.93,.07); 
  set(hdl,'fontsize',fsz-2);
  if i==1,
    cmd=['print -dpsc2 ensembles']; disp(cmd); eval(cmd)
  else
    cmd=['print -dpsc2 ensembles -append'];disp(cmd);eval(cmd)
  end
  hgsave(gcf,['ensembles' num2str(i)]);                          % save figure in matlab fig file
end

fprintf('\n~ END %s ~ ', prog_name); 
return
