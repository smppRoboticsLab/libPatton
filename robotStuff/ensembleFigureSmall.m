%************** MATLAB "M" fcn ************
% make an ensemble figure
% SYNTAX:     analysis 
% REVISIONS:  10/25/00 (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

% __SETUP__
deflection=findInTxt('parameters.txt',          ... % desired bend in trajectory
        'trajectory deflection=')                   % 
      
%_this overrides "phasesOinterest" (see targ_?.txd)_
what2do(1).phases=[];
what2do(2).phases=[2];
what2do(3).phases=[3 6];

plotDims=[3 1]
plotAxes=[-0.14,0.14,-0.125,0.09];

doEnsembles2(.95,deflection,what2do,plotDims,plotAxes);% ensemble avg's and plot
orient portrait
print -depsc2 smallEnsembles

playwav('done.wav')
fprintf('\n~ END Analysis.m  ~ \n')

return



