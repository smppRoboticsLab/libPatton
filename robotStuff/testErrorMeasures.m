%************** MATLAB "M" script  *************
% test & compare Figural error, velocity inner product, and 
% SYNTAX:       
% REVISIONS:    2/8/2000  (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function EM=testErrorMeasures()

% ____ SETUP ____
figure(1); clf;
put_fig(1,.1,.05,.7,.8); orient tall;     % setup figure window
drawnow;
verbose=1; plotIt=1;                      % switches for display
fsz=8;                                    % font size
mvmtDist=.2; mvmtDeflect=0;
mag=[mvmtDist mvmtDeflect];
startPt=[0 .4];
rot=90/180*pi;
L=[8888 8888];                            % dummyvalues for limb length
names=[];
spacing=0.01;                             % amount of spacing for resampling
                                          % with even space.

% ____ MAKE TRAJECTORIES ____
mvmtDeflect=0;
d=getTrajectory('pt2pt.txd'           ... % nominal (ideal) traj
 ,L,rot,[mvmtDist mvmtDeflect],startPt);

mvmtDeflect=-0.02;
D{1}=getTrajectory('sin-morphed.txd'  ... % small deflection
 ,L,rot,[mvmtDist mvmtDeflect],startPt);
names=(                               ... %
  ['deflection=' num2str(mvmtDeflect)]);

mvmtDeflect=-0.04;
D{2}=getTrajectory('sin-morphed.txd'  ... % small deflection
 ,L,rot,[mvmtDist mvmtDeflect],startPt);
names=str2mat(names,                  ... %
  ['deflection=' num2str(mvmtDeflect)]);

mvmtDeflect=-0.08;
D{3}=getTrajectory('sin-morphed.txd'  ... % small deflection
 ,L,rot,[mvmtDist mvmtDeflect],startPt);
names=str2mat(names,                  ... % 
  ['deflection=' num2str(mvmtDeflect)]); 

D{4}=getTrajectory('nonBel.txd'       ... % Non-bel shaped velocity
 ,L,rot,[mvmtDist mvmtDeflect],startPt);
names=str2mat(names,                  ... % 
  ['Non-bel shaped' num2str(mvmtDeflect)]); 


% 'nonBel.txd'

% ____ LOOP FOR EACH ANALYSIS ____
for traj=1:length(D)
  clf;  drawnow;
  fprintf('\n traj %d: ',traj); 
  

  % __ figural error __
  clf%subplot(3,2,1); 
  e=figuralError(d(:,1:3),D{traj}(:,1:3),0,verbose,plotIt); 
  set(gca,'fontSize',fsz);%axis off;
  title(['Figural Error=' num2str(e)],'fontSize',fsz);
  EM(traj,1)=e;
  
  if traj==1, print -dpsc2 measure_comparisons
  else        print -dpsc2 -append measure_comparisons
  end                                           % END if traj
  
  clf%subplot(3,2,2); 
  e=figuralError(d(:,1:3),D{traj}(:,1:3),spacing,verbose,plotIt);
  set(gca,'fontSize',fsz);%axis off;
  title(['Resampled Figural Error=' num2str(e)],'fontSize',fsz);
  EM(traj,2)=e;
  print -dpsc2 -append measure_comparisons
  
  % __ Vel inner product __
  clf%subplot(3,2,3); 
  e=velocityInnerProd(d(:,1:5),D{traj}(:,1:5),0,verbose,plotIt);
  set(gca,'fontSize',fsz);
  title(['Velocity Inner Product=' num2str(e)],'fontSize',fsz);
  EM(traj,3)=e;
  print -dpsc2 -append measure_comparisons 
  
  clf%subplot(3,2,4); 
  e=velocityInnerProd(d(:,1:5),D{traj}(:,1:5),spacing,verbose,plotIt);
  set(gca,'fontSize',fsz);
  title(['Resampled Velocity Inner Product=' num2str(e)],'fontSize',fsz); 
  EM(traj,4)=e;
  print -dpsc2 -append measure_comparisons 
  
  % __ VAF (not plotted) __   
  [junk,junk,EM(traj,5)]=rmsError(d(:,1:5), ...
    D{traj}(:,1:5),0,~verbose,~plotIt);
  [junk,junk,EM(traj,6)]=rmsError(d(:,1:5), ...
    D{traj}(:,1:5),spacing,~verbose,~plotIt);
  
  % __ rmsError __ 
  clf%subplot(3,2,5);
  e=rmsError(d(:,1:5),D{traj}(:,1:5),0,verbose,plotIt);
  ax=axis;  set(gca,'fontSize',fsz);
  title(['rmsError=' num2str(e)],'fontSize',fsz);
  EM(traj,7)=e; 
  print -dpsc2 -append measure_comparisons 
 
  clf%subplot(3,2,6);
  e=rmsError(d(:,1:5),D{traj}(:,1:5),spacing,verbose,plotIt);
  ax=axis;  set(gca,'fontSize',fsz);
  title(['Resampled rmsError=' num2str(e)],'fontSize',fsz);
  EM(traj,8)=e; 
  print -dpsc2 -append measure_comparisons 
  
end                                             % END for traj

%___ Plot bar chart ___
figure(2); clf; orient tall
C=colorcube(8); C=C(4:8,:);

subplot(4,1,1); multbar3(EM(:,1:2)',[1 2 3 6],C); 
title('Figural error');

subplot(4,1,2); multbar3(EM(:,3:4)',[1 2 3 6],C);
title('Velocity Inner Product');
ax=axis;  axis([ax(1) ax(2) .7 1]);             % zoom in

subplot(4,1,3); multbar3(EM(:,5:6)',[1 2 3 6],C); 
title('Vaf'); 
ax=axis;  axis([ax(1) ax(2) .95 1]);             % zoom in

subplot(4,1,4); multbar3(EM(:,7:8)',[1 2 3 6],C,names); 
title('RMS error'); 

print -dpsc2 -append measure_comparisons 

return
