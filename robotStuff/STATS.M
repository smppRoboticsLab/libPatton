%************** MATLAB "M" function  *************
% analyze data, subject's stat results & plot
% SYNTAX:       stats(plotIt,direction)
% INPUTS:       plotIt    nonzero for plots, ='individual' for individual pages 
%               direction direction in degrees to focus on
% REVISIONS:    9-1-00 INITIATED from fastLearnCurves (patton)
%               10-25-00 renamed stats.m from analysis3.m
%               6-13-02 added the direection input
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function PhaseByPhaseStruct=stats(plotIt,direction)

% __SETUP__
prog_name='stats.m';                                      % name of this program
fprintf('\n\n\n~ %s ~ \n', prog_name);                    % message
if ~exist('plotIt'), plotIt=1; end                        % if not passed
if ~exist('direction'), direction=[]; end                 % if not passed
set_params;                                               % set plethora o params
fsz=8; mkrSz=2;                                           % font & marker size
colors='mcrgby';
for i=1:1%Nmeas+1
  figure(i);clf; put_fig(i,(i)*.25,.25,.27,.67);          % setup figure windows
end
lastPart=0;                                               % last trial of prev. "part"
baseDir=cd;
if ~exist('performMeas.txd'), analysis1(0); end           % process if not already
phaseCounter=0;

%% __LOAD__
fprintf('\nLoading data..')
[EMh,EM]=hdrload('performMeas.txd');                      % LOAD MEASURES
colLabels=EMh(size(EMh,1),:);                             % GET MEAURE NAMES
colNames=parse(colLabels);                                % GET MEAURE NAMES
[Ntrials,Nmeas]=size(EM);                                 % dimensions
measureNames=colNames(3:Nmeas,:)  
Nmeas=Nmeas-2;                                            % DONT COUNT 1st 2COLs
measIndexes=3:Nmeas+2;                                    % index to "measure" cols
fprintf('.DONE. %d measures, %d trials. ',Nmeas,Ntrials); % display
nParts=findInTxt('performMeas.txd','Number of Parts=')
if isempty(nParts); nParts=2; end

% ____ GROUP the DATA for Barcharts ____
fprintf('\nGrouping the data...'); 
barMeans=[]; barStd=[]; bar95Width=[]; phaseNames=[];     % init
for part=1:nParts,                                        % loop for exp parts (protocols)
  filename=['targ_p' num2str(part) '.txd'];
  trialsStruct=probeTrialsStruct2(part,0);                % structure of names & list of
                                                          %  trials-of-interest for each phase
  [targHdr,targData]=hdrload(filename);

  for phase=1:length(trialsStruct)                        % loop for exp phases
    fprintf('\n\n  Part %d Phase %d ',part,phase);          % display
    fprintf('(%s):',trialsStruct(phase).name);            % display
    fprintf('Trials: ');                                  % display
    fprintf(' %d',trialsStruct(phase).trials)             % display
    fprintf(' ');                                         % display
    measures=[];                                          % init
    phaseCounter=phaseCounter+1;
    for i=1:length(trialsStruct(phase).trials)            % loop find trials on list
      %fprintf('\n\n   Looking for match for trial %d..',...% display
      %  trialsStruct(phase).trials(i));                  %
      
      % find this trial in targData
      for targNum=1:size(targData,1); 
        if(trialsStruct(phase).trials(i) ...
           ==targData(targNum,1))
          break;
        end 
      end
      targInfo=targData(targNum,:);                       % extract this trial's row 
      
      for EMrow=1:size(EM,1)                              % loop to search EM
        if (EM(EMrow,1)==trialsStruct(phase).trials(i) ...% if it matches trial&phase
           &EM(EMrow,2)==part),                           % ...
          fprintf('\nmatch at row %d:  %f',EMrow)          % display
          fprintf('%f',EM(EMrow,:));                      % display

          if(~isempty(direction))                         % if not all directions 
            if(direction==targInfo(7) & targInfo(10))     % if if dir==desired & a good trial
              measures=[measures; EM(EMrow,measIndexes)]; % stack data on summary
              fprintf('x')
            end
          else  
            if(targInfo(10))                              % if good trial
              measures=[measures; EM(EMrow,measIndexes)]; % stack data on summary
              fprintf('x')
            end
          end
%           if(direction==targInfo(7)|isempty(direction))   % if dir==desired or dont care
%             if(targInfo(10))                              % only if a good trial
%               measures=[measures; EM(EMrow,measIndexes)]; % stack data on summary
%             end
%           end
          break                                           % 
        end                                               % END if EM
      end                                                 % END for EMrow
    end                                                   % END for i
    if size(measures,1)==1,                               % if only one trial
      barMeans=[barMeans;     part phase measures];       % use values for mean
      barStd=[barStd;         part phase zeros(size(measures))];% zero dispersions
      bar95Width=[bar95Width; part phase zeros(size(measures))];%  
    else
      pause(.02)
      barMeans=[barMeans;     part phase mean(measures)];   %
      barStd=[barStd;         part phase std(measures)];    %
      bar95Width=[bar95Width; part phase confidence(measures,.95)];%  
    end 
    phaseNames=str2mat(phaseNames,trialsStruct(phase).name);% 
    PhaseByPhaseStruct(phaseCounter).measures=measures;
    PhaseByPhaseStruct(phaseCounter).name=trialsStruct(phase).name;
    PhaseByPhaseStruct(phaseCounter).colLabels=colLabels;
  end                                                     % END for phase
  if part==1&exist('part2')==7,                           % if part 2 is in a subdir
    cd part2; cd                                          % 
  end                                                     %
end % END for part                                        %
phaseNames(1,:)=[];                                       % clip off blank line 
cd(baseDir)                                               %

fprintf('\nsaving PhaseByPhaseStruct.mat... \n'); 
save 'PhaseByPhaseStruct.mat' PhaseByPhaseStruct

%barMeans,barStd,bar95Width,phaseNames 
fprintf('\nDone Grouping the data. \n'); 


% ____ make Barcharts ____
fprintf('\nBarcharts..'); 
figure(1); clf;
C=colorcube(8); 
for meas=1:Nmeas,
  fprintf('\n Measure#%d: %s ',meas,measureNames(meas,:));% 
  switch plotIt
    case 1,               
      subplot(Nmeas,1,meas);
    case 'individual',    
      figure(meas); 
      clf; put_fig(meas,(meas)*.05,.25-meas*.02,.5,.7);     % setup figure windows
      orient tall
  end 
  multbar3(barMeans(:,meas+2)',[],C,phaseNames,...
           [],[],bar95Width(:,meas+2)',0,'barInside');
  title(measureNames(meas,:));
  textOnPlot(num2str(direction),.9,.9);
end % END for meas

if strcmp(plotIt,'individual'), FN=Nmeas, else FN=1; end
  
fprintf('\nPrinting..'); 
for i=1:FN,
  figure(i);   orient tall
  suptitle(str2mat('Experimental Phases for', cd)); 
  drawnow; pause(.001);
  if i==1, print(gcf,'-dpsc2',['barcharts' num2str(direction)]);               % print to a file
  else     print(gcf,'-dpsc2', '-append',['barcharts' num2str(direction)]); end
end

% ____ output 2 file ____ 
fprintf('\nSaving..'); 
h=['Summary data for ' cd]; 
h=str2mat(h,                                              ... 
  ['Generated by ' prog_name ', ' whenis(clock)],         ... 
  'Each row is a experimental phase. See phaseNames.txd.',                      ... 
  phaseNames,...
  '____data:____');
col_labels=['Part' setstr(9) 'Phase' ];       % init w/tabSeparator
for meas=1:Nmeas,
  col_labels=[col_labels ... 
      setstr(9) deblank(measureNames(meas,:)) ]; 
end % END for meas 
h=str2mat(h,col_labels); 
mat2txt(['barMeans' num2str(direction) '.txd'],h,barMeans);
mat2txt(['bar95Width' num2str(direction) '.txd'],h,bar95Width);
mat2txt(['phaseNames.txd'],phaseNames,-9999);

fprintf('\n~ END %s ~ \n\n', prog_name); 

