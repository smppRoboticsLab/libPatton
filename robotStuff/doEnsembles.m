%************** MATLAB "M" function  *************
% Analyze data: ensemble average plots
% SYNTAX:     doEnsembles(CI)
% REVISIONS:  2/8/2000  (patton) INITIATED
%             9-1-0 RENAMED analysis4.m from fastLearnCurves.m (patton)
%             10/25/00 RENAMED doEnsembles.m
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function doEnsembles(CI,phases2skip,deflection)

% ____ SETUP ____
prog_name='doEnsembles.m';                              % name of this program
fprintf('\n~ %s ~ ', prog_name);                        % MSG
if ~exist('CI'), CI=0, end                              % if not passed
if ~exist('phases2skip'), phases2skip=[], end           % if not passed
set_params;                                             %
verbose=1; plotIt=1; printIt=1;                         % switches for display
fsz=8;                                                  % font size
mkrSz=2;                                                % marker size
baseDir=cd;
Dname=['desired.txd'];                                  %
part=0;
firstTimeThru=1;                                        %

%__setup figure__
for i=1:2
  figure(i);clf; put_fig(i,(i-1)*.4,.5,.37,.45);       % window
end

% ____ LOOP for EACH part ____
while(1)
  part=part+1;
  fprintf('\n\npart %d:\n~~~~~~',part); 
  
  %__ load TARGETS __ 
  filename=['targ_p' num2str(part) '.txd']; 
  if(~exist(filename))                                        % stop if no more parts
    fprintf('\nCannot find %s. -No more parts\n',filename);
    break;
  end 
  fprintf('\n\nPart %d Trials:\n~~~~~~\n',part);              % 
  [trialHeader,trialData]=hdrload(filename);                  % targets & trial info
  nPhases=find1TXTvalue(filename,'Number of Phases=','s');
  Dirs=sort(distill(trialData(:,7))'); nDirs=length(Dirs);    % 
  Mag=mean(trialData(:,8));                                   % magnitude o ea.movement
  if ~exist('deflection')                                 % if not passed
    deflection=.3*Mag;
  end           
  
  %__ load trialsStruct __ 
  filename=['trialsStruct_p' num2str(part) '.mat'];
  if(~exist(filename))                                        % stop if no more parts
    fprintf('\nCannot find %s. -No more parts\n',filename);
    break;                                                    % break out of while loop
  end 
  load(filename);                                             % load it
  
  % ____ LOOP for EACH part & TRIAL  ____
  for phase=1:length(trialsStruct)
    fprintf('\n\n\n___\n Phase %d ("%s" for %s): ',phase,        ...
      trialsStruct(phase).name, cd); 
    clf; drawnow
    
    % ___ Check to see if ENSEMBLE was deselected___
    doEnsemble=1;
    for i=1:size(phases2skip)
      if phases2skip(1,i)==part&phases2skip(2,i)==phase,
        doEnsemble=0; 
        fprintf('\nskip part %d, phase %d (%s).\n', ...
          part,phase,trialsStruct(phase).name)
      end        
    end
    
    % ___ ENSEMBLE, finalize & print if not deselected___
    if doEnsemble,
      
      % ___ loop for each dir ___
      for Dir=1:nDirs,                                            % determine direction
        fprintf('\n  Direction %d: ',Dirs(Dir)); 
      
        % determine sub-list of trials that match Dir and phase
        trials=[]; starts=[];                                     % init
        for i=1:length(trialsStruct(phase).trials)
          trial=trialsStruct(phase).trials(i);
          if trialData(trial,7)==Dirs(Dir),                       % if match direction
            trials=[trials trial];                                % stack onto list
            startTarg=[-Xshoulder2motor Yshoulder2motor]      ... % convert to subject coords
                      -trialData(trial,2:3);
            starts=[starts; startTarg];
          end
        end % END for i        
        
        if ~isempty(trials)                                       % skip if no trials 
          fprintf('\n    Trials:'); fprintf(' %d',trials);
          Ename=[trialsStruct(phase).name  '.'                  ... % ouput filename
               num2str(Dirs(Dir)) '.ensemble.dat'];               %
          Ename=strrep(Ename,' ','_');
      
      
          ensembleTrials3(trials,part,starts,Ename            ... % ***** perform ensemble******
                      ,CI,plotit,verbose,~printIt);             % 
                  
          % __load refernce (desired) __
          if exist(Dname)
            %fprintf('\n    LOAD REFERENCE: %s for %d deg.. ',     ...
            %  filename,Dirs(Dir));                                    %      
            D=getIdealTrajectory(Dname,L                          ... % load & transform
            ,[0,0],Dirs(Dir)*pi/180-pi,Mag,deflection            ... % 
            ,speedThresh,0);                                         %
            D(:,1)=[];
            %fprintf('Done. \n');                                      %
          else 
            filename=['Unperturbed baseline.' num2str(Dirs(Dir)) ...
                '.ensemble.dat']; 
              filename=strrep(filename,' ','_');
            %fprintf('\n    LOAD REFERENCE: %s for %d deg.. ',     ...
            %  filename,Dirs(Dir));     %      
            if exist(filename)
              D=loadRobotData(filename,cutoff,0);                     % load & transform to subj c.s.
            else 
              fprintf(' \7 Cannot find %s! ',filename)          
              D=[];
            end  
          end
          if ~isempty(D), plot(D(:,1),D(:,2),'r.'); end
          drawnow; pause(.00001)           % 
        end % END if ~isempty(trials)
      end % END for Dir
  
      % ___ finalize and print ___
      suptitle(str2mat('Ensemble trials for',                 ...
        trialsStruct(phase).name ,cd));
      if firstTimeThru,
        cmd=['print -dpsc2 ' baseDir '\ensembles.ps']; 
        firstTimeThru=0;
      else
        cmd=['print -dpsc2 -append ' baseDir '\ensembles.ps'];  
      end
      disp(cmd); eval(cmd)
   end % END if doEnsemble
    
  end % END for phase

  fprintf('\nDONE with trials for part %d. ',part); 
  if part==1 & exist('part2')                       % for backwards compatibility
      cd part2; cd;
      [trialHeader,trialData]=hdrload('targ.txd');  % load targets & trial info
      load trialsStruct                             % load trial categoriesw
      wd=parse(cd,'\'); wd=wd(size(wd,1),:);        % working directory
  end                              
end % END for part

cd(baseDir); cd

fprintf('\n~ END %s ~ ', prog_name); 
return
