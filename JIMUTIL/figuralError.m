%************** MATLAB "M" function (jim Patton) *************
% Figural error (average dist error forwards & backwards) betweeen 2 traj.
% SYNTAX:       FE=figuralError(a,b,spacing,verbose,plotIt)
% INPUTS:       Each tracetory a& b is a nx3 of [time xpos ypos]  
% REVISIONS:    2/22/99   (patton) took de.m (conditt) & enhanced comments ONLY
%               2/7/2000  (patton) revised for resampling
%               2/18/2000 (patton) add infinity norm
%               2/22/2000 (patton) add initial direction error
%~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

function [FE,infinityNorm]=figuralError(a,b,spacing,verbose,plotIt)

%____ SETUP ____
if ~exist('spacing'), spacing=0; end
if ~exist('verbose'), verbose=1; end
if ~exist('plotIt'), plotIt=0; end
prog_name='figuralError.m';
if verbose, fprintf('\n~ %s ~ ', prog_name); end 
if (size(a,2)~=3 | size(b,2)~=3)
  error('Inputs a & b must be nx3: [time xpos ypos]. ')
end
fsz=8;

%____ uniform ____
if spacing,
  ar=uniformDistance(a,spacing,verbose); 
  br=uniformDistance(b,spacing,verbose);
else
  ar=a; 
  br=b;
end

%____ plot ____
if plotIt,
  plot(a(:,2),a(:,3),'r'); hold on;
  plot(b(:,2),b(:,3),'b'); hold on;
  plot(ar(:,2),ar(:,3),'ro','markersize',3); 
  plot(br(:,2),br(:,3),'b^','markersize',3);
  ylabel('Y position (m)','fontSize',fsz);  
  xlabel('X position (m)','fontSize',fsz);
  axis equal
end

%____ a to b ____
distance=[];
for i=1:size(br,1),
  for j=1:size(ar,1),
     distance(j)=sqrt((br(i,2)-ar(j,2))^2 ...
                    + (br(i,3)-ar(j,3))^2);
   end
   [b_a_dist(i),j]=min(distance);
   
   if plotIt,
     plot([br(i,2) ar(j,2)],            ...
          [br(i,3) ar(j,3)],'m:');
     hold on;
   end  % if
   %drawnow; pause(.01);
end

%____ b to a ____
distance=[];
for i=1:size(ar,1),
   for j=1:size(br,1),
      distance(j)=sqrt((ar(i,2)-br(j,2))^2 ...
                     + (ar(i,3)-br(j,3))^2);
   end
   [a_b_dist(i), j]=min(distance);
   
   if plotIt,
     plot([ar(i,2) br(j,2)],            ...
          [ar(i,3) br(j,3)],'g:')
     hold on;
   end  % if
   %drawnow; pause(.01);
end

%____ average ____
FE=(sum(b_a_dist) + sum(a_b_dist))/ ...
   (size(ar,1) + size(br,1));

infinityNorm=min([max(b_a_dist) max(a_b_dist)]);

if verbose, fprintf('~ END %s ~ ', prog_name); end 




