%************** MATLAB "M" function  *************
% analyze data: learning curves in the wing-Dots format sorted by movement direction
% SYNTAX:       learnCurves.m(plotIt)
% REVISIONS:    INITATED 4-4-02 from learnCurves.m (PATTON)
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function wingDots(print2ps)

% __SETUP__
prog_name='learnCurves.m';                                % name of this program
fprintf('\n~ %s ~ ', prog_name);                          % message
if ~exist('print2ps'), print2ps=1; end                    % if not passed
set_params;                                               % set plethora o params
oldPart=-9999;                                            % init
fsz=7;                                                    % font size
mkrSz=2;                                                  % marker size
colors='mcrgbymcrgbymcrgbymcrgbymcrgbymcrgbymcrgby';

% __LOAD__
fprintf('\nLoading data..')
[EMh,EM]=hdrload('performMeas.txd');                      % LOAD MEASURES
colLabels=EMh(size(EMh,1),:);                             % GET MEAURE NAMES
colNames=parse(colLabels);                                % GET MEAURE NAMES
[Ntrials,Nmeas]=size(EM);                                 % dimensions
measureNames=colNames(3:Nmeas,:)                          % first 2 are not measures
Nmeas=Nmeas-2;                                            % DONT COUNT 1st 2COLs
fprintf('.DONE. %d measures, %d trials. ',Nmeas,Ntrials); % display
nParts=findInTxt('performMeas.txd','Number of Parts=');
if isempty(nParts); nParts=1; end
DD=[];

% set figs: 
for i=1:Nmeas+1
  figure(i);clf; 
  %put_fig(i,(i-1)*.25,.25,.27,.67);                      % setup figure windows
  put_fig(i,(i)*.05,.25-i*.02,.5,.7);                     % setup figure windows
end

%___LOOP FOR TRIALS___
for cumTrial=1:Ntrials,
  trial=EM(cumTrial,1);
  part=EM(cumTrial,2);
  
  % load a trailsruct if part is new
  if part~=oldPart, 
    load(['trialsStruct_p' num2str(part)]); 
    for i=1:length(trialsStruct)                          % loop for exp part
      fprintf('\nPart %d phase %d= %s, trials:', ...
        part,i,trialsStruct(i).name);
      fprintf(' %d',trialsStruct(i).trials);
    end
    oldPart=part;
    for meas=1:Nmeas,                                     % vert line to separate parts
      figure(meas); ax=axis; 
      plot((cumTrial-.5)*[1 1],[ax(3) ax(4)],'k:')
    end % END for meas    
    [targHeader,targData]=hdrload(['targ_p'           ... % load targets & trial info
        num2str(part) '.txd']);                           % 
  end % END if part..
      
  % ___ PLOT MEASURES ON LEARN CURVES___
  for meas=1:Nmeas,
    mkr='ko';                                             % init
    FC=[.8 .8 .8];                                        % for MarkerFaceColor
    EC=[1 1 1];                                           % for MarkerEdgeColor
    EC='none';                                            % for MarkerEdgeColor
    mkrSz=2;                                              % marker size
    if 1,
    for i=1:length(trialsStruct)                          % loop for exp part
      for j=1:length(trialsStruct(i).trials)              % loop for trials in part list 
        if trial==trialsStruct(i).trials(j),  
          %fprintf('found phase %d trial %d.\n ',i,trial);
          mkr=[colors(i) 'o']; %mkrSz=1;                  % marker size
          FC=colors(i);                                   % for MarkerFaceColor
          mkrSz=2;                                        % marker size
          break
        end
      end % END for j
    end % END for i
    end
    %figure(meas+1); 
    figure(2); 
    %subplot(3,ceil(Nmeas/3),meas)
    %subplot(Nmeas,1,meas)
    figure(meas); 
    plot(cumTrial,EM(cumTrial,meas+2),'o',...
        'markersize',mkrSz,...
        'MarkerFaceColor',FC,...
        'MarkerEdgeColor',EC);
    if trial==1, 
      hold on; set(gca,'fontsize',fsz); 
      title(deblank(measureNames(meas,:)));
    end
  end % END for meas
  if trial/40==round(trial/40),drawnow;pause(.001);end    % update display every 40
    
end % END for cumTrial

% ____ finalize plot ____
fprintf('\nFinalizing plot...'); 
for meas=1:Nmeas,  
  fprintf('DONE. '); 
  %subplot(Nmeas,1,meas);
  figure(meas); 
  ax=axis; 
  plot([ax(1) ax(2)],[0 0],'k:')
  %subplot(Nmeas,1,1)
  ax=axis; 
  for part=1:nParts
    lgndX=((part-1)/nParts+.1)*(ax(2)-ax(1));
    load(['trialsStruct_p' num2str(part)]); 
    for i=1:length(trialsStruct)                              % loop for exp part
      mkr=[colors(i) 'o']; 
      FC=colors(i);        % for MarkerFaceColor
      EC='none';           % for MarkerEdgeColor
      lgndY=ax(3)+.98*(ax(4)-ax(3))-.02*i*(ax(4)-ax(3));
      plot(lgndX,lgndY,'o','markersize',mkrSz,...
        'MarkerFaceColor',FC,'MarkerEdgeColor',EC);
      text(lgndX,lgndY,['  ' trialsStruct(i).name],'fontsize',fsz);
    end% END for i
  end % END for part
  xlabel('Trial','fontsize',fsz);
  
  orient tall
  suptitle(['Learning curves for ' cd]);
  drawnow; pause(.001);
  
  % print to file
  if print2ps
    fprintf('\nFinalizing plot & printing to a file..'); 
    if meas==1, print -dpsc2 learnCurves.ps
    else        print -dpsc2 -append learnCurves.ps
    end
  end
  
  fprintf('DONE. '); 
  
end % END for meas


fprintf('\n~ END %s ~ \n\n', prog_name); 

