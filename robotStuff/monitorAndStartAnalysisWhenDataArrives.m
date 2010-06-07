%monitorAndStartAnalysisWhenDataArrives: wait4data2arrive,thenSpawnAnalysis
%%************** MATLAB "M" function  *************
% analyze data: performance measures and plot individual traject
% SYNTAX:     performMeas(doPlot,doPrint)
% REVISIONS:  2/8/2000  (patton) INITIATED
%             9-1-0 RENAMED analysis1.m from fastLearnCurves.m (patton)
%             10-25-0 renamed performMeas.m
%             11/3/0 add deflection
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function monitorAndStartAnalysisWhenDataArrives()

%% ____ SETUP ____
prog_name='monitorAndStartAnalysisWhenDataArrives.m';   % name of program
fprintf('\n~ %s ~\n\n   Waiting for files to arrive..');% announce
%if ~exist('doPlot'), doPlot=1, end                     % if not passed
drawnow; pause(.01);
ctr=0;
tic


%% ____ Loop continuously & check for a file ____
while ~exist('P1_682.DAT','file'),
    ctr=ctr+1;
    if ctr==6; 
      ctr=0; 
      fprintf('\n waiting for data (%3.2f min) ...', toc/60); 
    end
    pause(5);
end
analysis

