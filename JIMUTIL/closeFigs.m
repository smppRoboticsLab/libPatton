
fprintf(' Closing all figs')
lastFig=0;

while(gcf~=lastFig)
  fprintf('.')
  lastFig=gcf;
  figure(gcf); close; 
end
figure(gcf); close; 

fprintf('Done.\n')
