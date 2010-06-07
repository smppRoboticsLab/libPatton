% render a dice combination
% to automatically create a character in dungeons and dragons, use
% for i=1:, max([dice(3,6), dice(3,6),dice(3,6)]), end

function x=dice(n,d);

clf;
x=0;
for i=1:n;
  x=x+ceil(d*rand(1,1));
end;

text(.5,.5,num2str(x),'fontsize',100);
set(gca,'box','off','xtick',[],'ytick',[])