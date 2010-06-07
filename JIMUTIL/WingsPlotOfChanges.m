%% WingsPlotOfChanges - scatter, avg, & wings showing differences of groups
% ************************ MATLAB M function ***************************
% The result contains a plot that this attempts to show muliple dimensions
% on a 2d plot, showing (typically) subject, trialdata, before and after,
% error measures, and  summary statistics as wings and points.
% SYNTAX:     
% INPUTS:     D             cell array of 1-dataArrays. 
%                           each row of the cell array is data from a
%                           'subject' and each column is a 'phase' of the
%                           experiment
%             PhaseLabels   (optional) a 1D cell array of text labels for
%                           each phase. This should have the same number
%                           of columns of cells as D. 
%             Dlabels       (optional) a cell array of the same dimensions
%                           as D, with each cell containing another 1-
%                           dimensional cell array, where each element is a 
%                           text string corresponding to the points in D                        
%             FontSize      (optional) desird font size for text. default=8
%             PlotFileName  (optional) different name for the output than
%                           the default, 'WingsPlot.eps'
% OUTPUTS:    eps file      the plot (filename=PlotFileName, default name
%                           is 'WingsPlot.eps')
% CALLS:      
% REVISIONS: 	WingsPlotOfChanges.m Adapted by Patton 3/25/05 from: 
%               -- $Id: calc_blae.m 258 2005-02-21 22:00:55Z scharver $
%               -- $Id: fig_blae.m 257 2005-02-17 00:09:37Z scharver $
%             Patton 5-12-05 added statistical significance for each
%                            subject, indicated by dotted lines for not
%                            significant.
% A SIMPLE EXAMPLE:    
%   D={ rand(12,1)  1.0+rand(10,1)  
%       rand(10,1)  1.2+rand(10,1) 
%       rand(10,1)  0.1+rand(10,1)  
%       rand(10,1)  0.7+rand(10,1) }
%   WingsPlotOfChanges(D);
% 
% A MORE COMPLICATED EXAMPLE:
%   D={ rand(10,1)  1.0+rand(10,1)  1.0+rand(10,1)
%       rand(10,1)  1.2+rand(10,1)  1.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.2+rand(10,1)  0.2+rand(10,1)
%       rand(10,1)  0.7+rand(10,1)  0.7+rand(10,1)}
%   [Drows,Dcols]=size(D); % get dimensions
%   for P=1:Dcols;    
%     PhaseLabels{P}=['Phasetext #' num2str(P)];
%     for S=1:Drows;   
%       for i=1:size(D{S,P},1); 
%         Dlabels{S,P}{i,1}=['text (' num2str(S) ',' num2str(P) ')'];
%       end; 
%     end;
%   end 
%   WingsPlotOfChanges(D,PhaseLabels,Dlabels,8);
%
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ end of header ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function WingsPlotOfChanges(D,  PhaseLabels,Dlabels,FontSize,PlotFileName)

%% ____ SETUP ____
progName='WingsPlotOfChanges.m';
fprintf('\n~ %s ~ ',progName);  
figHandle=gcf;
hold on;
[Drows,Dcols]=size(D);                                              % get dimensions
if ~exist('PhaseLabels'), PhaseLabels=[]; end                       % default
if ~exist('Dlabels'), Dlabels=[]; end                               % default
if ~exist('FontSize'), FontSize=8; end                              % default
if ~exist('PlotFileName'), PlotFileName='WingsPlot.eps'; end        % default
COLORLIST=colorcube(Drows+6);                                         % list of evenly spaced colors for each subject

% setup the spacing parameters for plotting
plotParams.xPhasePositions=1:Dcols;                                 %  horizongal phase group center 
%plotParams.xSubjWidth=0.15*(plotParams.xPhasePositions(2)-   ...
%                      plotParams.xPhasePositions(1))/Drows;        % spacing between subejcts
plotParams.xSubjWidth=0.15/Drows; % spacing between subejcts
plotParams.xSubjOffset=-plotParams.xSubjWidth*(Drows-1)/2;          % shift back this much

[Dmean,Dconf95]=StatsOnCells(D);                                    % find statistics for cell array elements


%% ____ plots ____ 
for SUBJECT=1:Drows;   % For each 'subject'
  for PHASE=1:Dcols;     % For each 'phase of the experiment'

    fprintf('\n Subject %d, Phase %d... ', SUBJECT,PHASE)
    % find the horizontal position for this phase and subject:
    xSubject=plotParams.xPhasePositions(PHASE)    ...               % horiz pos for these set of points
            +plotParams.xSubjOffset               ...
            +(plotParams.xSubjWidth*(SUBJECT-1)); 
    
    % Plot the values first so that they appear under the lines. 
    Xs=ones(length(D{SUBJECT,PHASE}))*xSubject;                     % create 'ones' array & multiply by x value
    plot(Xs, D{SUBJECT,PHASE},'.',                    ...           % plot indiv. points with color
        'markerSize', 4, 'color',COLORLIST(SUBJECT,:));
%     plot(Xs, D{SUBJECT,PHASE},'.','color',[.7 .7 .7], ...         %  plot indiv. points w/grey
%         'markerSize', 4);

    if ~isempty(Dlabels)
      for i=1:size(Dlabels{SUBJECT,PHASE},1) 
        dotLabel=['  ' Dlabels{SUBJECT,PHASE}{i}(:,:)];
        text(xSubject, D{SUBJECT,PHASE}(i,1), dotLabel,   ...
          'color',COLORLIST(SUBJECT,:), 'FontSize',FontSize-2)
      end  
    end
    
    % plot the mean and confidence wings
    plot(xSubject, Dmean{SUBJECT,PHASE}, '+',                  ...  % plot mean
      'markerSize', 5, 'color',COLORLIST(SUBJECT,:)); 
    plot( [xSubject xSubject],                                 ...  % plot confidence wings
          Dmean{SUBJECT,PHASE}+Dconf95{SUBJECT,PHASE}*[1 -1],  ...   
          'color',COLORLIST(SUBJECT,:),                        ...
            'lineWidth',1);
   
    if PHASE>1
      [H,P]=ttest2(D{SUBJECT,PHASE-1},D{SUBJECT,PHASE});
      if isnan(H)|H, lineType='-'; lineWidth=2; 
      else  lineType=':'; lineWidth=1; 
      end
      plot([xSubjectPrevious xSubject],                        ...  % plot lines connecting phases
           [Dmean{SUBJECT,PHASE-1} Dmean{SUBJECT,PHASE}],      ...
           lineType,                                           ...
           'color',COLORLIST(SUBJECT,:),                       ...
           'lineWidth',lineWidth);
   end

    xSubjectPrevious=xSubject;                                      % store position for later

  end % END for phase of the experiment
end % END for subject

%% put on labels and grand means/ci's for the 'phases'
ax=axis;
for PHASE=1:Dcols;     % For each 'phase of the experiment'
  if (length(PhaseLabels)>=PHASE);        % if there is a label
    text(plotParams.xPhasePositions(PHASE),ax(3),PhaseLabels{PHASE} ...
      , 'horizontalAlignment','center'                              ...
      , 'verticalAlignment','Top'                                   ...
      , 'FontSize',FontSize)
  end

%   fprintf('\n\n\n-----------------------------------\n')
%   Dmean{:,PHASE}
%   fprintf('\n')
%   Dmean{SUBJECT,PHASE}\

  Means=zeros(Drows,1);
  for SUBJECT=1:Drows;
    Means(SUBJECT,1)=[Dmean{SUBJECT,PHASE}];% pull out the mean
  end
  
  MM=mean(Means) % mean of means for this phase
  CM=confidence(Means,.95) % confidence of means for this phase
  
  h=patch(PHASE+[.1 0 -.1 0 .1], ...
    [MM MM+CM MM MM-CM MM],.2*[.6 .6 .9],...
    'EdgeColor','none','FaceAlpha',.5);
end % END for phase of the experiment

%% tweak the figure
set(gca, 'box','off', 'xTick',[], 'FontSize',FontSize);

%% print to file
if ~isempty(PlotFileName)
  print('-depsc2', PlotFileName)
end


fprintf('Done. \n~ END %s ~ \n',progName);                            % message
return;

