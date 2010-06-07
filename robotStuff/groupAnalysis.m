%************** MATLAB "M" function  *************
% analyze data: overall group results
% SYNTAX:      groupAnalysis(plotIt,subjNums,prefix,phasesOfInterest,phases2highlight,symbol,linestyle,lw,stagger,label3)
% REVISIONS:    9-1-00  INITIATED from fastLearnCurves (patton) 
%               9-10-0  changed name from analysis4 to groupAnalysis
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function groupAnalysis(plotIt,subjNums,prefix,phasesOfInterest,phases2highlight,symbol,linestyle,lw,stagger,label3,directions,lineWingsMeasures)

% __SETUP__
prog_name='groupAnalysis.m';                              % name of this program
fprintf('\n\n\n~ * %s * ~ \n', prog_name);                % message
if ~exist('plotIt'), plotIt=1; end                        % if not passed
if ~exist('subjNums'),subjNums=input('Subject #s: '); end % if not passed
if ~exist('prefix'),prefix=input('File prefix: ','s');end % if not passed
if ~exist('phasesOfInterest'),                            % if not passed
  phasesOfInterest=input(                             ... % 
    ['phasesOfInterest (e.g., [2 5 7 8 11 12 13 15])' ...
     ' press enter for all of them']);% 
end                                                       % 
if ~exist('phases2highlight'), phases2highlight=[]; end   % if not passed
if ~exist('symbol'),symbol='.'; end                       % for line wings plots
if ~exist('linestyle'),linestyle='-'; end                 % for line wings plots
if ~exist('lw'),lw=1; end                                 % for line wings plots
if ~exist('stagger'),stagger=0; end                       % for line wings plots
if ~exist('label3'),label3=0; end                         % for line wings plots
if ~exist('lineWingsMeasures'),lineWingsMeasures=[], end  % for line wings plots
if ~exist('directions'), directions=[]; end                 % if not passed

fsz=6; mkrSz=2;                                           % font & marker size
for i=1:2                                                 % loop to set figures
  figure(i);clf; put_fig(i,(i-1)*.25+.1,.25,.27,.67);        % setup figure windows
end                                                       %
nPhases=length(phasesOfInterest);                         % number of phases
nSubj=length(subjNums);
subScale=.6/(nSubj+2);                                    % dist btwn subject lines
minSubj=min(subjNums);
subjCount=0;
AX=[0   nPhases+1   0   .06                               % preferred axis bounds
    0   nPhases+1   0   .06                               % each row is for a measure
    0   nPhases+1  -30   90 ];
singlePlots=1  % for splitting figure 2 into separate ones
baseDir=cd;
wd=parse(baseDir,'\'); wd=deTabBlank(wd(size(wd,1),:));   % get name of directory
 
% ___load & reorganize data (each line a subject)___
for subj=subjNums,                                        % subj loop
  subjCount=subjCount+1;
  cmd=(['cd ' prefix num2str(subj)]);disp(cmd);eval(cmd)  % change to directory
  fprintf('.       Subj %d Loading data..',subj)          % 
  
  if isempty(phasesOfInterest),                           % if not given presume all
    phasesOfInterest=1:size(hdrload('phaseNames.txd'),1)
    nPhases=length(phasesOfInterest);                     % number of phases
  end
    
  % 95 confidence intervals
  if isempty(directions)
    filename=['bar95Width.txd'];
  else
    filename=['bar95Width'  ...
        num2str(directions(subjCount)) '.txd'];  
    if ~exist(filename),                                  % no stats in indiv direction
      %stats('individual',directions(subjCount));          % so process these stats
      stats(0,directions(subjCount));          % so process these stats
    end
  end
  if ~exist(filename),error(['!Not there:' filename]);end 
  [h,d]=hdrload(filename); [Nphases,Ncols]=size(d);       % load
  if subjCount>1&Ncols~=Nmeas+2, 
    fprintf('\n\n!Subj#%d, columns=%d, expecting %d.\n',...% message  
      subj, Ncols, Nmeas+2);
    error(' Different # measures among subjects! ')       % ERR IF NO MATCH 
  end
  d(:,1:2)=[];   cubePMS95(:,:,subjCount)=d;              % clip 1st 2 cols & stack 
  
  % means
  if isempty(directions)
    filename=['barMeans.txd'];
  else
    filename=['barMeans' num2str(directions(subjCount)) '.txd'];
  end
  if ~exist(filename),error(['!Not there:' filename]);end % process if not already 
  [h,d]=hdrload(filename); [Nphases,Ncols]=size(d);        % load
  d(:,1:2)=[];  cubePMS(:,:,subjCount)=d;                 % clip 1st 2 cols & stack 
  
  % clip out 1st 2 cols
  measureNames=parse(h(size(h,1),:)); 
  measureNames(1:2,:)=[];                                 % remove trial and phase  
  Nmeas=Ncols-2;                                          % FIRST 2 ARE NOT  MEASURES
  
  % phase names
  phaseNames=hdrload('phaseNames.txd');
  fprintf('Done. '); 
  cd ..
end % END for subj

% ___stats____ 
fprintf('\nStats.. ')   % 
phaseNames
phasesOfInterest
phaseNames=phaseNames(phasesOfInterest,:);                % clip out intermediates
cubePMS95=cubePMS95(phasesOfInterest,:,:);                % clip out intermediates
cubePMS=cubePMS(phasesOfInterest,:,:);                    % clip out intermediates
cubeSPM=permute(cubePMS,[3 1 2]);                         % swap dimensions
if nSubj<8,  C=colorcube(8); 
else           C=colorcube(nSubj);  
end
if strcmp(lower(plotIt),'bw'), C=zeros(30,3);  end;       % remark out for color
OAmeans=cubeStat(cubePMS,'mean');
OAconfidence=cubeStat(cubePMS,'confidence',.95);

%============== PLOTS ================
fprintf('\nPlots.. ')                                     % 
for i=4:Nmeas+3,
  figure(i);clf; put_fig(i,i*.03+.3,.3-i*.02,.3,.7);      % setup figure windows
end

% ___segment plots____ 
figure(2); clf
mkrStr='sdv^<>px+*ohsdv^<>px+*oh';
for meas=1:Nmeas,
  fprintf('\nMeasure#%d(%s)',meas,measureNames(meas,:))   % 
  if singlePlots, 
    figure(3+meas); clf
  else
    subplot(Nmeas,1,meas);
  end
  
  fprintf('  Phase: ')   % 
  for phase=1:nPhases
    fprintf('%d ',phase)   % 
    patch(phase*ones(1,6)+.3*[1 1 -1 -1 1 1],    ...
      OAmeans(phase,meas)*ones(1,6)+OAconfidence(phase,meas)*...
      [ 0 1 1 -1 -1 0], [.7 .7 .7], ...
      'EdgeColor','none'); hold on
    plot(phase+.3*[-1 1],OAmeans(phase,meas)*[1 1],'k:');
    ax=axis;
    if singlePlots,       
      text(phase, ... 
        OAmeans(phase,meas)-OAconfidence(phase,meas), ...
        [num2str(phase) '. '                       ...
         deblank(phaseNames(phase,:)) '      '],  ...  
        'HorizontalAlignment','right',  ...  
        'VerticalAlignment','middle',  ...  
        'Rotation',90)      
    end    
    for subj=1:nSubj
      xpos=phase+subScale*(subj+.5-(nSubj+2)/2);          % x for this phase on plot
      yctr=cubePMS(phase,meas,subj);                      % y center
      yhi=yctr+cubePMS95(phase,meas,subj);                % plus 95
      ylo=yctr-cubePMS95(phase,meas,subj);                %
      %plot(xpos,yctr,'.','color',C(subj,:) );            % dot
      plot(xpos,yctr,mkrStr(subj),'markerSize', ...       % symbol
        4,'color',C(subj,:));                             %
      plot(xpos*[1 1],[yhi ylo],'-','color',C(subj,:) );  % line
      hold on
      set(gca,'XTickLabel',[],'Xtick',[], ...
        'box','off','XColor',[1 1 1])
    end    
  end % END for phase
  
  % lay down a highlighting patch to highlight if chosen:
  for phase=1:nPhases
    for i=1:length(phases2highlight)
      if phase==phases2highlight(i),                      % if on list
        ax=axis; 
%         rectangle('position',                         ... % highlight box
%           [phase-.5 ax(3) 1 ax(4)-ax(3)]...% 
%           ,'edgeColor',[1 1 0],'LineWidth',4);         
        patch([phase-.5 phase-.5 phase+.5 phase+.5], [ax(3) ax(4) ax(4) ax(3)],[1 1 0],'edgeColor','none');         
      end
    end % END for i
  end % END for phase

% plot again
  fprintf('  Phase: ')   % 
  for phase=1:nPhases
    fprintf('%d ',phase)   % 
    patch(phase*ones(1,6)+.3*[1 1 -1 -1 1 1],    ...
      OAmeans(phase,meas)*ones(1,6)+OAconfidence(phase,meas)*...
      [ 0 1 1 -1 -1 0], [.7 .7 .7], ...
      'EdgeColor','none'); hold on
    plot(phase+.3*[-1 1],OAmeans(phase,meas)*[1 1],'k:');
    ax=axis;
    if singlePlots,       
      text(phase, ... 
        OAmeans(phase,meas)-OAconfidence(phase,meas), ...
        [num2str(phase) '. '                       ...
         deblank(phaseNames(phase,:)) '      '],  ...  
        'HorizontalAlignment','right',  ...  
        'VerticalAlignment','middle',  ...  
        'Rotation',90)      
    end    
    for subj=1:nSubj
      xpos=phase+subScale*(subj+.5-(nSubj+2)/2);          % x for this phase on plot
      yctr=cubePMS(phase,meas,subj);                      % y center
      yhi=yctr+cubePMS95(phase,meas,subj);                % plus 95
      ylo=yctr-cubePMS95(phase,meas,subj);                %
      %plot(xpos,yctr,'.','color',C(subj,:) );            % dot
      plot(xpos,yctr,mkrStr(subj),'markerSize', ...       % symbol
        4,'color',C(subj,:));                             %
      plot(xpos*[1 1],[yhi ylo],'-','color',C(subj,:) );  % line
      hold on
      set(gca,'XTickLabel',[],'Xtick',[], ...
        'box','off','XColor',[1 1 1])
    end    
  end % END for phase

  
  % plot(OAmeans(:,meas),'k*')
  title(deblank(measureNames(meas,:)));
  ax=axis; plot([ax(1) ax(2)],[0 0],'k:'); % line

  
  figure(2)
  
end % END for meas

% ___overall barchart ___
figure(1); clf
for meas=1:Nmeas,
  fprintf('\nMeasure#%d(%s)',meas,measureNames(meas,:))       % 
  subplot(Nmeas,1,meas);
  multbar3(mean(cubeSPM(:,:,meas)),[],[.8 .8 .8],phaseNames,...
    .85,[],confidence(cubeSPM(:,:,meas),.95),0,'barInside');  %
  hold on
  title(deblank(measureNames(meas,:)));
end % END for meas

% __ print plots __
figure(1) 
cmd=['print -dpsc2 GroupCharts']; %disp(cmd); eval(cmd)         % print to PS file
%hgsave(gcf,'GroupBarChart');                                  % save in matlabFig format
figure(3) 
cmd=['print -dpsc2 -append GroupCharts']; %disp(cmd);eval(cmd) % print to PS file
%hgsave(gcf,'lineChart');                                      % save in matlabFig format

% __ finalize plots __
fprintf('\nFinalize plots.. ')   % 
for meas=1:Nmeas 
  if singlePlots, figure(3+meas);
  else            subplot(Nmeas,1,meas);
  end  
  drawnow;
  ax=axis; 
 if ~isempty(directions)
   textOnPlot('(Individual directions)',.8,.9);
 end
   
  % __ phase labels __
  if ~singlePlots&meas==Nmeas                                 % only if all on one
  ax=axis; 
    for phase=1:nPhases 
      text(   ...
           phase,ax(3)+.1, ... 
        ...%min(min(min(cubePMS))), ...                       %-max(max(max(cubePMS95))))
        [...%num2str(phase) '. '      ...
        deblank(phaseNames(phase,:)) ''],  ...  
        'HorizontalAlignment','right',  ...  
        'VerticalAlignment','middle',  ...  
        'Rotation',90);
      deblank(phaseNames(phase,:));
    end
  end
  orient tall
  %hdl=textonplot(['(' wd ')'],.93,.93);set(hdl,'fontsize',8)
  drawnow; pause(.001);
  
  % __ print post script & fig files __
  cmd=['print -dpsc2 -append GroupCharts'];
  %disp(cmd); eval(cmd)% print to PS file
  %hgsave(gcf,[deblank(measureNames(meas,:))       ...
  %    '_GroupSegmentChart']);  % save in matlabFig format
end % END for meas


%print also to a group chart
%cmd=['print -dpsc2 -append GroupCharts'];
%disp(cmd); eval(cmd)% print to PS file

if label3,
  figure(3);   ax=axis; 
  for phase=1:nPhases 
    text(   ...
      phase,ax(3)+.1, ... 
      ...%min(min(min(cubePMS))), ...                       %-max(max(max(cubePMS95))))
      [...%num2str(phase) '. '      ...
        deblank(phaseNames(phase,:)) ''],  ...  
      'HorizontalAlignment','right',  ...  
      'VerticalAlignment','middle',  ...  
      'Rotation',90)      
    deblank(phaseNames(phase,:));
  end
end

% ____ set & save output data files ____
fprintf('\nStore output.. ')   % 
h=['Summary data for ' cd]; 
h=str2mat(h,... 
  ['Generated by ' prog_name ', ' whenis(clock)],... 
  ['each row is a subject"s mean data'],... 
  '____data:____');
col_labels=['Subject'];
for i=1:size(phaseNames,1),
  col_labels=[col_labels setstr(9)  ...                   % init w/tabSeparator
              deblank(phaseNames(i,:))];        
end
h=str2mat(h,col_labels);
for meas=1:Nmeas,
  groupData=[subjNums' cubeSPM(:,:,meas)];
  mat2txt([deblank(measureNames(meas,:)) ...
           '_subject_means.txd'], h,groupData);
end

fprintf('DONE.'); 
fprintf('\n~ END %s ~ \n\n', prog_name); 

return

