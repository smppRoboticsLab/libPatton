% learnCurves2: analyze data by plotting curves for each trial
% ************** MATLAB "M" function (Patton) *************
% SYNTAX:       learnCurves2(inFileName)
% REVISIONS:    9-1-00 INITIATED from fastLearnCurves (patton) 
%               10-25-00 renamed learnCurves.m from analysis2.m
%               05-01-2008 made into learnCurves2; made more general
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function learnCurves2(inName)

% __SETUP__
prog_name='learnCurves.m';                                % name of prog
fprintf('\n~ %s ~ ', prog_name);                          % message
if ~exist('inName'),inName='TargsPlusPerformMeas.txd';end % if not passed
MeasuresStartCol=1;                                      % init/default
% set_params;                                             % set plethora o params
fsz=7;                                                    % font size
mkrSz=2;                                                  % marker size
%colors='mcrgbymcrgbymcrgbymcrgbymcrgbymcrgbymcrgby';     % string of colors
EC=[1 1 1];                                               % for MarkerEdgeColor
mkr='o';                                                  % default marker type
FC=[0 0 .6];                                              % for MarkerFaceColor
     
% __LOAD & GET importantNumbers __
fprintf('\nLoading data..')
[EMh,EM]=hdrload(inName);                                 % LOAD MEASURES
[Ntrials,Ncols]=size(EM);                                 % dimensions
colLabels=EMh(size(EMh,1),:);                             % GET MEAURE NAMES
colNames=parse(colLabels);                                % GET MEAURE NAMES
for i=1:Ncols
  colNamesInCellArray{i,1}=deblank(colNames(i,:));
end
fieldTypes=textract(inName,'fieldType');                  % load  col
parts=textract(inName,'part');                            % load  col
GoodTrials=textract(inName,'Good trial');                 % load  col
phases=textract(inName,'phase');                          % load  col
if distill(phases)==-8888,                                % no phases found
  phases=textract(inName,'experimental_phase');           % TRY ONE MORE 
end

% find the names of experimental phases (if there)
phaseNames{max(phases),1}=[];                             % init
if distill(phases)~=-8888,                                %                      
  for i=1:max(phases),                                    % 
    fprintf('.')
    searchText=['phase '  num2str(i) ' name='];           %
    phaseNames{i,1}=deTabBlank(findIntxt(inName,searchText,'string'));%
    if isempty(phaseNames{i,1}),                          % if no name
      searchText=['phase '  num2str(i) ' name ='];        %
      phaseNames{i,1}=deTabBlank(findIntxt(inName,searchText,'string'));%
    end
    if isempty(phaseNames{i,1}),                          % if no name
      searchText=['phase '  num2str(i) ' ='];             %
      phaseNames{i,1}=deTabBlank(findIntxt(inName,searchText,'string'));%
    end
    if isempty(phaseNames{i,1}),                          % if no name
      phaseNames{i,1}=['Phase ' num2str(i)];              % make default
    end
    if phaseNames{i,1}(1)==char(9),                       % if there is /t
      phaseNames{i,1}(1)=[];                              % clip out
    end  
  end
end
fprintf('Done loading. \n')
phaseNames %#ok<NOPRT>

% find where the measures start, using goodTrial:
for i=1:Ncols                                            % loop:search4goodTrial column
  %fprintf('\n[%s]',deblank(lower(colNames(i,:))))
  if strcmp(deblank(lower(colNames(i,:))),'good trial')
    MeasuresStartCol=i+1;
  break; break;
  end
end

% The following is a special error trap for 
% situations where there are too many colums to 
% plot and MATALB will crash. Ask for a start column
if Ncols-MeasuresStartCol>15,                           % If too long                          
  MeasuresStartCol=menu(...                             % graphical menu 
    ['The number of columns in the file is too'...
    ' long to plot. Please choose a column name'...
    ' to start your plotting'],colNamesInCellArray)
end
measureNames=colNames(MeasuresStartCol:Ncols,:)
measures=EM(:,MeasuresStartCol:Ncols);
Nmeas=Ncols-MeasuresStartCol+1;                           % COLs measure values
fprintf('.DONE. %d measures, %d trials. ',Nmeas,Ntrials); % display
nParts=max(parts); if isempty(nParts); nParts=1; end
DD=[]; 

% set figs: 
for i=1:Nmeas+1
  figure(i);clf; put_fig(i,(i)*.03,.25-i*.02,.5,.7);      % setup figure windows
end

%___LOOP FOR TRIALS___
for meas=1:Nmeas, %loop for each measure
  figure(meas);
  for trial=1:Ntrials,

    % Set marker charatersitics
    if trial>2 ...
        && (  fieldTypes(trial)~=fieldTypes(trial-1) ...
        && fieldTypes(trial)~=fieldTypes(trial-2))
      EC=[.6 0 0];  FC=[.6 0 0];                          % plot chars
    else
      EC=[1 1 1];  FC=[.5 .5 .5];                         % plot chars
    end
    if GoodTrials(trial)
      mkr='x';
    else
      mkr='o';
    end
    plot(trial,measures(trial,meas),'o',...
      'markersize',mkrSz,...
      'MarkerFaceColor',FC,...
      'MarkerEdgeColor',EC);
    if trial==1,
     plot((trial-.5)*[1 1],[min(measures(:,meas)) max(measures(:,meas))],'k:')
     plot(Ntrials+.5*[1 1],[min(measures(:,meas)) max(measures(:,meas))],'k')
     hold on; set(gca,'fontsize',fsz);
      title(deblank(measureNames(meas,:)));
%       plot([0 Ntrials],[0 0],'k:');  % horiz line
      xlabel('Trial number','fontsize',fsz);
%       axis tight
    end
    if trial>1 && (phases(trial)~=phases(trial-1)),
      plot((trial-.5)*[1 1],[min(measures(:,meas)) max(measures(:,meas))],'k:')
      ax=axis; yrange=ax(4)-ax(3);
      text(trial,ax(4)-.01*yrange*phases(trial),                 ...
        ['Phase ' num2str(phases(trial)) ': ' phaseNames{phases(trial)}]         ...
        ,'fontsize',fsz-1);
    end

    if trial/40==round(trial/40),drawnow;pause(.001);end    % update display every 40
  end % END for trial
end % END for meas

% ____ finalize plot ____
for meas=1:Nmeas,
  figure(meas);
  fprintf('\nFinalizing plot & printing to a file..');
  orient tall
  suptitle(['Learning curves for ' cd]);
  drawnow; pause(.001);

  %   fprintf('\nFinalizing plot & printing to a file..');
  %   if meas==1, print -dpsc2 learnCurves.ps
  %   else        print -dpsc2 -append learnCurves.ps
  %   end
end % END for meas
fprintf('DONE. ');
fprintf('\n~ END %s ~ \n\n', prog_name);
end % end of function


