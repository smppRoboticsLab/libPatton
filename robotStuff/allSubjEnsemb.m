% produce new ensembles plots for subjects
CI=0;
CI=.95
deflection=0
      
for subj=21:25
  cd(['sfd' num2str(subj)])                         % cd to subdir
  cd
  doEnsembles2(CI,deflection);                      % ensemble avg's and plot
  cd ..
end

playwav('done.wav')
fprintf('\n~ END Analysis.m  ~ \n')
