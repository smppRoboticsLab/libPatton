
%__ plot circle of influnece of the rcb __
i=0;
for X=-.1:.025:.10,
  for Y=.3:.025:.6,
    i=i+1;
    test(i,:)=[X,Y,1,1];
  end
end
if length(RCB)<8, colors=colorcube(8); 
else colors=colorcube(length(RCB));
end
colors=['cgmybrkcgmybrk']';
for i=1:length(RCB)                         % these plot RCB circles 
  F=rcEval3(test,RCB(i),0); 
  for j=1:size(test,1)
    mag=sqrt(F(j,1)^2+F(j,2)^2)/200;
    if mag>.0001,
      ellipse(test(j,1),test(j,2),      ... % plot a bubble
          mag,mag,0,12,colors(i,:));        %  (rot=0, # of segments=12)
    end
    hold on
  end
  plot(RCB(i).C(1),RCB(i).C(2),'.'); hold on
end
