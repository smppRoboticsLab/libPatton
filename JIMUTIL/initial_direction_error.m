%************** MATLAB "M" function (jim Patton) *************
% initial_direction_error betweeen 2 traj.
% SYNTAX:       ide=initial_direction_error(a,b,fraction,verbose,plotIt)
% INPUTS:       Each tracetory a& b is a nx2 of [xpos ypos]  
% REVISIONS:    2/22/99   (patton) took de.m (conditt) & enhanced comments ONLY
%               2/7/2000  (patton) revised for resampling
%               2/18/2000 (patton) add infinity norm
%               2/22/2000 (patton) add initial direction error
%~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

function [ide,a_count,b_count]=initial_direction_error(a,b,fraction,verbose,plotIt)

%____ SETUP ____
if ~exist('verbose'), verbose=1; end
if ~exist('plotIt'), plotIt=1; end
prog_name='initial_direction_error.m';
if verbose, fprintf('\n~ %s ~ ', prog_name); end 
if (size(a,2)~=2 | size(b,2)~=2)
  error('Inputs a & b must be nx3: [xpos ypos]. ')
end
fsz=8;

% ___ generate a path (s) distances ___
sa(1)=0;
sb(1)=0;
D=diff(a)+.000001;                                        % .000001 is for ideal traj
for i=1:size(a,1)-1,
  sa(i+1)=sa(i)+sqrt(D(i,1)^2+D(i,2)^2);
end
D=diff(b)+.000001;                                        % .000001 is for ideal traj
for i=1:size(b,1)-1,
  sb(i+1)=sb(i)+sqrt(D(i,1)^2+D(i,2)^2); 
end

% ___ calculate critical points ___
crit_distance=fraction*max(sa);                           % fraction of total dist
a_crit=interp1(sa,a,crit_distance);
if crit_distance>max(sb), crit_distance=max(sb); end
b_crit=interp1(sb,b,crit_distance);

% ___ calculate index of swhich point distance is exceeded ___
for i=1:size(a,1)-1,
  if sa(i)>crit_distance
    a_count=i; break
  end    
end
for i=1:size(b,1)-1,
  if sb(i)>crit_distance
    b_count=i; break
  end    
end

% ___ make vectors ___
a_vect=[a_crit(1,1)-a(1,1) a_crit(1,2)-a(1,2)];
b_vect=[b_crit(1,1)-b(1,1) b_crit(1,2)-b(1,2)];

% ___ calc angles___
ang=angle_2d(a(1,:),a_crit,b(1,:),b_crit,verbose);
ide=abs(ang*180/pi);
ide=(ang*180/pi);

%____ plot ____
if plotIt,
  clf
  plot(a(:,1),a(:,2),'r.'); hold on;
  plot(b(:,1),b(:,2),'b.'); hold on;
  plot([a(1,1) a_crit(1,1)],[a(1,2) a_crit(1,2)],'r'); 
  plot([b(1,1) b_crit(1,1)],[b(1,2) b_crit(1,2)],'r'); 
  ylabel('Y position (m)','fontSize',fsz);  
  xlabel('X position (m)','fontSize',fsz);
  axis equal
  title(['angle=' num2str(ang*180/pi) ' degrees'])
  disp('hit a key....'); pause
end  

if verbose, fprintf('~ END %s ~ ', prog_name); end 




