%% make3DTargetsList: make list of motions in a volume 
%  inpuyts are colume limits and possible vectors of movement
%% ================== FUNCTION ==================
function make3DTargetsList()
clf
clc

% from original tests 
% shiftx	 = 	0
% shifty	 = 	0.85
% shiftz	 = 	-0.4

minMax=[-.40   .6  -.50 
         .40  1.1  -.20]
unitVectors=[ 1  0  0 
             -1  0  0
              0  1  0
              0 -1  0
              0  0  1
              0  0 -1]
            
unitVectors=[ 0         0.5773    0.8166
             -0.8103   -0.586     0
              0         0.5773   -0.8166
              0.8103	 -0.586     0        ]
dist=.15 ;
C='bgrykmcbgrykmcbgrykmcbgrykmcbgrykmc';
NmovementsPerDir=5;
Nblocks=8;
startPoint=mean(minMax)-[0 0 .07]; % for now


%% plot
clf
plotVRROOMman
for i=1:2
  for j=1:2
    for k=1:2
    plot3(minMax(i,1),minMax(j,2),minMax(k,3),'m+', 'markersize',10); hold on
    end
  end
end
plot3(startPoint(1),startPoint(2),startPoint(3),'mo', 'markersize',10); hold on
axis equal
grid on
% axis(minMax(1:6)*1.2)

%% make list
points=[];
for i=1:Nblocks
  points=[points
    makeTargList(minMax,NmovementsPerDir,unitVectors,dist,startPoint)];
end
points
%%


end % END OF makeList FUNCTION



%% ================== FUNCTION ==================
function endpoints=makeTargList(minMax,mvmtsPerDir,uVects,dist,startPoint)
Ndir=size(uVects,1);
Nmovements=mvmtsPerDir*Ndir;

mvmtSeq=[];
for dir=1:Ndir
  for mvmt=1:mvmtsPerDir
    mvmtSeq=[mvmtSeq
            uVects(dir,:)*dist];
  end 
end
endpoints=calcEndpoints(mvmtSeq,startPoint);
mvmtH=plot3(endpoints(:,1),endpoints(:,1),endpoints(:,1));
[junk,I]=sort(rand(Nmovements,1));  % random order
mvmtSeq=mvmtSeq(I,:); % random seq
endpoints=calcEndpoints(mvmtSeq,startPoint);
set(mvmtH,'xData',endpoints(:,1),'yData',endpoints(:,2),'zData',endpoints(:,3) )

% adjust
i=0;
while i<Nmovements
  i=i+1;
  title(['Working on movement number ' num2str(i)])
  while(  endpoints(i,1)<minMax(1,1) || endpoints(i,1)>minMax(2,1) ...
        ||endpoints(i,2)<minMax(1,2) || endpoints(i,2)>minMax(2,2) ...
        ||endpoints(i,3)<minMax(1,3) || endpoints(i,3)>minMax(2,3) )
    i=i-1;
    title(['Working on movement number ' num2str(i)])
    mvmtSeq=swapRows(mvmtSeq,i,i+round(rand(1,1)*(Nmovements-i)));
    endpoints=calcEndpoints(mvmtSeq,startPoint);
    set(mvmtH,'xData',endpoints(:,1),'yData',endpoints(:,2),'zData',endpoints(:,3) )
    drawnow; %pause(.8)
  end

end
 
end %END OF makeTargList FUNCTION

%% ================== FUNCTION ==================
function endpoints=calcEndpoints(mvmtSeq,startPoint)
  N=size(mvmtSeq,1);
  endpoints=startPoint;
  for i=1:N
   endpoints=[endpoints
              endpoints(i,:)+mvmtSeq(i,:)];
  end
end   %END OF calcEndpoints FUNCTION
