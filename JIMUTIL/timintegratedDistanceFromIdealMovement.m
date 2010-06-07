%% timintegratedDistanceFromIdealMovement.m:  time based mistake
% SYNTAX:   D = timintegratedDistanceFromIdealMovement(d0,d1,t,x) 
% IMPUTS:   d0    desired starting point
%           d1    desired ending  point
%           t     time associated with x (N by 3 or N by 2 matrix)
%           x     locations of the actual trajectory
% ~~~~~~~~~ BEGIN: ~~~~~~~~~ 
 
function D = timintegratedDistanceFromIdealMovement(d0,d1,t,x,plotit)

%% INITIAL STUFF
if ~exist('plotit','var'), plotit='plotIt'; end
[N,Dim]=size(x);
D=0;
mvUnitVec=(d1-d0)/norm(d1-d0);


if plotit, 
  if Dim==3,
    plot3(x(:,1),x(:,2),x(:,3),'b.'); hold on
    plot3(x(:,1),x(:,2),x(:,3),':','color',[0 0 .8])
    plot3([d0(1) d1(1)],[d0(2) d1(2)],[d0(3) d1(3)],'r')
  else
    plot(x(:,1),x(:,2),'b.'); hold on
    plot(x(:,1),x(:,2),':','color',[0 0 .8])
    plot([d0(1) d1(1)],[d0(2) d1(2)],'r')
  end
  
end

for i=1:N
  
  if      dot(x(i,:)-d0, mvUnitVec)<0   % if behind the starting plane/line
    if plotit,
      if Dim==3,
        plot3([x(i,1) d0(1)],[x(i,2) d0(2)],[x(i,3) d0(3)],'g')
      else
        plot([x(i,1) d0(1)],[x(i,2) d0(2)],'g')
      end
    end
    D=D+norm(x(i,:)-d0);
    
  elseif dot(x(i,:)-d1,-mvUnitVec)<0   % if beyond the end plane/line
    if plotit,
      if Dim==3,
        plot3([x(i,1) d1(1)],[x(i,2) d1(2)],[x(i,3) d1(3)],'g')
      else
        plot([x(i,1) d1(1)],[x(i,2) d1(2)],'g')
      end
    end    
    D=D+norm(x(i,:)-d1);
    %% INSERT point x(i,:) to a line calc here
    
  else % if between from start to end the normal planes 
    SX=x(i,:)-d0;                           % vect from start 2 actual x
    TDC=dot(SX,mvUnitVec);                  % target direction component
    xi=d0+TDC*mvUnitVec;                    % perp intersection along se 
    pdVect=x(i,:)-xi;                       % COMPLEMENT=perpendicular dist
    pDist=norm(pdVect);                     % Perpendicular distance 
    D=D+pDist;                              % stack on the distances
    if plotit,
      if Dim==3,
        plot3([x(i,1) xi(1)],[x(i,2) xi(2)],[x(i,3) xi(3)],'m')
      else
        plot([x(i,1) xi(1)],[x(i,2) xi(2)],'m')
      end
      axis equal
    end
  
  end

end

end