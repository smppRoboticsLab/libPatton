
%% script for setting a blank message window

set(gcf,'name','Message Window');
  put_fig(gcf, .77,.84,.22,.1); plot(0,0,'w.'); hold on; axis([0,1,0,1]); 
  set(gca,'box','off','XTick',[],'YTick',[],'visible','off');  % clear boxed fig window
  set(gcf,'color','w');
  plot([0 0 1 1 0],[0 .05 .05 0 0]); % progress bar area
  drawnow
