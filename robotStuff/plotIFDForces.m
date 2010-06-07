
% plots the forces in iterative field design
clf; put_fig(gcf,.6,.1,.3,.8)

nDirs=(findInTxt('targ_p1.txd','number of directions='));       % directionsOmovement

for i=0:12 % scan all
  filename=['f' num2str(i) '.txd'];
  if exist(filename)
    [h,d]=hdrload(filename); 
    subplot(6,1,i+1); 
    t=(-1:size(d,1))/100;
    d=[0 0;d;0 0];
    plot(t,d,'.'); hold on;  plot(t,d);  grid on; 
    multbar3(d',t)
    title(filename)
    i=i+1;
    filename=['f' num2str(i) '.txd']
    i=i+1;
  end
end

suptitle(str2mat('IFD force profiles vs time for',cd))
orient tall; 
print -depsc2 IFDforces
  
  