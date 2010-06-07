%______*** MATLAB "M" script (jim Patton) ***_______
% plot a quiver/vector field plot of the force field
%______________________ BEGIN: ______________________

function field_plot(fsz);

fprintf(' field_plot.m ')
global DEBUGIT L field_gain
% where:
% DEBUGIT    =nonzero for extra debugging messages
% L          =segment length (interjoint)
% field_gain =MATRIX of gains that govern endpoint force see field2.m

%___ set fig: ___
mkr='gbr';
plot(1,1,'g',1,1,'b',1,1,'r',1,1,'k');      % dummys so legend will work
hold on

%___ EVALUATE FIELD AT POINTS ON GRID: ___
xx=-.6:.1:.6;  yy=-.6:.1:.6;                % establish grid
xx=-1:.2:1;  yy=-1:.2:1;                % establish grid
k=0;                                        % init couter
QP=NaN*zeros(length(xx)*length(xx),4,3);    % init an array
for i=1:length(xx)                          % loop x points on grid
  for j=1:length(yy),                       % loop y points on grid
    k=k+1;
    QP(k,:,1)=[xx(i) yy(j)              ... % put results in a matirx
        field4([xx(i) yy(j) 0 0 0 0],1)];   
    QP(k,:,2)=[xx(i) yy(j)              ... % put results in a matirx
        field4([0 0 xx(i) yy(j) 0 0],1)];
    QP(k,:,3)=[xx(i) yy(j)              ... % put results in a matirx
        field4([ 0 0 0 0 xx(i) yy(j)],1)];
  end                                       %
end

%___ QUIVER PLOT ARROWS: ___
for i=1:3                                   % loop for  each derivative
  if (sum(sum(QP(:,3:4,i)))),
    fprintf('plotting .. ')
    quiver(QP(:,1,i),QP(:,2,i),         ... % plot arrows 
      QP(:,3,i),QP(:,4,i),mkr(i));    
  end
end %for i
axis equal; 

set(gca,'fontsize',fsz)
title(['Field=[' num2str(field_gain(1))    ... 
             ' ' num2str(field_gain(2))    ...
            '; ' num2str(field_gain(3))    ...
             ' ' num2str(field_gain(4))    ...
             ']'],'fontsize',fsz);
legend('pos','vel','acc')

clear QP 
return

