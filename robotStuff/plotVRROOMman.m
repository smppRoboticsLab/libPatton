%%% 3D plot of a primitive man at VRROOM
%% PATTON 27-June-2006
% all arguements are optional

function plotVRROOMman(trunkCenter,mirrorCenter,mirrorPitch)

if ~exist('trunkCenter');  trunkCenter=[0,.65,.3];  end % not used yet
if ~exist('mirrorCenter'); mirrorCenter=[0,1.25,-.35]; end % not used yet
if ~exist('mirrorPitch');  mirrorPitch=60;  end              % degrees

%% head      
colormap('copper')
plot3(0,0,0,'.'); hold on

%% trunk      
trunkRadii=[.2 .4 .13];
ellipsoid(trunkCenter(1),trunkCenter(2),trunkCenter(3), ...
           trunkRadii(1),trunkRadii(2),trunkRadii(3)); 

%% head      
head=trunkCenter+[0,.5,0]; 
headRadii=[.1 .13 .1];
ellipsoid(head(1),head(2),head(3), ...
          headRadii(1),headRadii(2),headRadii(3)); 

%% humerous      
humerous=trunkCenter+[.14,.3,-.15]; 
humerousRadii=[.03 .03 .15];
ellipsoid(humerous(1),humerous(2),humerous(3), ...
          humerousRadii(1),humerousRadii(2),humerousRadii(3)); 
      
%% arm      
arm=trunkCenter+[.14,.3,-.36]; 
armRadii=[.03 .03 .15];
ellipsoid(arm(1),arm(2),arm(3), ...
          armRadii(1),armRadii(2),armRadii(3)); 

%% VRROOM screen      
plot3([-.6 .6 .6 -.6 -.6],  ...
      [1 1 1.5 1.5 1],      ...
      [0 0 -.7 -.7 0],      ...
      'k', 'linewidth', 3); % 

campos([-1,1.1,.1])
camup([0 1 0])
axis equal