% BarPlotOfChanges  - bARS showing categorical differences
% ***************** MATLAB M function ***************
% The result contains a plot that this attempts to show muliple dimensions
% on a 2d plot, showing (typically) subject, trialdata, before and after,
% error measures, and  summary statistics as wings and points.
% SYNTAX:     
% INPUTS:     D             cell array of 1-dataArrays. 
%                             each row of the cell array is data from a 'subject' 
%                             and each column is a 'phase' of the experiment
%             PhaseLabels   (optional) a 1D cell array of text labels for each phase
%             FontSize      (optional) desird font size for text. default=8
%             PlotFileName  (optional) different name for the output than
%                             the default, 'WingsPlot.eps'
% OUTPUTS:    plot and eps file of the plot (filename=PlotFileName
% CALLS:      
% REVISIONS: 	Adapted by Patton 3/29/05 from:
%                 WingsPlotOfChanges
% EXAMPLE:    
% D={ rand(10,1)  1.0+rand(10,1)  
%     rand(10,1)  1.2+rand(10,1) 
%     rand(10,1)  0.9+rand(10,1)  
%     rand(10,1)  0.7+rand(10,1) }
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [DiffOfMeans,meanDiff,confDiff,h,p,ci]=BarPlotOfChanges(D,PhaseLabels,FontSize,PlotFileName)

%____ SETUP ____
progName='BarPlotOfChanges';
fprintf('\n~ %s ~ ',progName);  
figHandle=gcf;
hold on;
[Drows,Dcols]=size(D);                                              % get dimensions
if ~exist('PhaseLabels'), PhaseLabels=[]; end                       % default
if ~exist('FontSize'), FontSize=8; end                              % default
if ~exist('PlotFileName'), PlotFileName='WingsPlot.eps'; end        % default
COLORLIST=colorcube(Drows+6);                                         % list of evenly spaced colors for each subject

% setup the spacing parameters for plotting
plotParams.xPhasePositions=1:Dcols;                                 %  horizongal phase group center 
%plotParams.xSubjWidth=0.15*(plotParams.xPhasePositions(2)-   ...
%                      plotParams.xPhasePositions(1))/Drows;        % spacing between subejcts
plotParams.xSubjWidth=0.15/Drows; % spacing between subejcts
plotParams.xSubjOffset=-plotParams.xSubjWidth*(Drows-1)/2;          % shift back this much

[Dmean,Dconf95]=StatsOnCells(D); % find the statistics for each cell array element


%____ plots ____ 
for SUBJECT=1:Drows;   % For each 'subject'
  for PHASE=1:Dcols-1;     % For each 'phase of the experiment'
    DiffOfMeans(SUBJECT,PHASE)=Dmean{SUBJECT,PHASE+1}-Dmean{SUBJECT,PHASE};
    LeftMean(SUBJECT,PHASE) = Dmean{SUBJECT,PHASE};
    RightMean(SUBJECT,PHASE+1) = Dmean{SUBJECT,PHASE+1};
  end
end
DiffOfMeans
meanDiff=mean(DiffOfMeans)
confDiff=confidence(DiffOfMeans,0.95)
EarlyMean = mean(LeftMean(:,1))
LateMean = mean(RightMean(:,2))
[h,p,ci] = ttest(LeftMean(:,1),RightMean(:,2));
h
p
ci



% Barchart
x=[(1:Dcols-1)]+0.5;
N='Change'; xNames=[]; for i=1:Dcols-1; xNames=[xNames; N]; end; xNames;
colors=[.8 .8 .8];
textLocation='barInside';
% multibar3(y,x,colors,xnames,width,offset,wings,zero,textLocation,fsz)
multbar3(meanDiff,x, colors, xNames, [],[],confDiff,[],textLocation,FontSize);

% print to file
if ~isempty(PlotFileName)
  print('-depsc2', PlotFileName)
end

fprintf('Done. \n~ END %s ~ \n',progName);                            % message
return;


