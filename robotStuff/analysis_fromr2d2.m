%************** MATLAB "M" script ************
% batch file to Analyze data
% SYNTAX:     analysis 
% REVISIONS:  10/25/00 (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

fprintf('\n~ Analysis.m (analysis batch file) ~')

% __SETUP__
CI=.95;
doPlot=2; 
doPrint=1;
analFrames=20;
phases2skip=[1 1 1 1 2 2 2 3 3 3; ...               % list of phases for no ensembles
             1 3 4 5 1 2 4 1 4 5]                   % row1=part, row2=phase#
deflection=input('Deflection: ')

% __ANALYSIS__
plotIFDForces
doEnsembles(CI,phases2skip,deflection);           % ensemble avg's and plot
performMeas(doPlot,doPrint,analFrames,deflection);% performance measures
learnCurves(doPlot);                              % learning curves 
stats(doPlot)                                     % statistical summary & plot

playwav('done.wav')
fprintf('\n~ END Analysis.m (analysis batch file) ~ \n')
