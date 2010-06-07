
% produce new ensembles plots for subjects
CI=.95
CI=0;
deflection=.03


%_this overrides "phasesOinterest" (see targ_?.txd)_
what2do(1).phases=[2 5];
what2do(2).phases=[2 3];
what2do(3).phases=[2 3 4 6];

plotDims=[2 4];

for subj=12:18
  cd(['ifd' num2str(subj)])                         % cd to subdir
  cd
  doEnsembles2(CI,deflection,what2do,plotDims);                      % ensemble avg's and plot
  cd ..
end

playwav('done.wav')
fprintf('\n~ END Analysis.m  ~ \n')
