%************** MATLAB "M" function (jim Patton) *************
% figural error (average dist error forwards & backwards) betweeen 2 traj.
% 
% SYNTAX       FE=figural_error(a, b,uniform,verbose,plot_or_not)   
% INPUTS:      Each position tracetory a & b is a nx2 of [xpos ypos]  
% CALLS:       
% CALLED BY:	 ?
% REVISIONS:   2/22/99   (patton) took de.m (by conditt) & enhanced 
%                        comments ONLY
%              2/4/00     added the ability to resample space uniformly
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function FE=figural_error(a,b,uniform,verbose,plot_or_not)

%____ SETUP ____
if ~exist('uniform'), uniform=0; end
if ~exist('verbose'), verbose=1; end
if ~exist('skip'), skip=1; end
if ~exist('plot_or_not'), plot_or_not='n'; end
if verbose, fprintf(' ~ figural_error.m ~ '); end

%____ plot ____
if plot_or_not=='y',
  plot(a(:,1),a(:,2),'r.'); hold on;
  plot(b(:,1),b(:,2),'b.'); hold on;
  axis equal
end  

% ___ Resample uniformly in space ___
a=uniform_resample(a);
b=uniform_resample(b);

%____ a to b ____
distance=[];
for i=1:length(b),
   for j=1:length(a),
      distance(j)=sqrt((b(i,1)-a(j,1))^2 + (b(i,2)-a(j,2))^2);
   end
   [b_a_dist(i),j]=min(distance);
   
   if plot_or_not=='y',
     plot([b(i,1) a(j,1)],[b(i,2) a(j,2)],'b');
     hold on;
   end  % if
   %drawnow; pause(.01);
end

%____ b to a ____
distance=[];
for i=1:length(a),
   for j=1:length(b),
      distance(j)=sqrt((a(i,1)-b(j,1))^2 + (a(i,2)-b(j,2))^2);
   end
   [a_b_dist(i), j]=min(distance);
   
   if plot_or_not=='y',
     plot([a(i,1) b(j,1)],[a(i,2) b(j,2)],'r')
     hold on;
   end  % if
   %drawnow; pause(.01);
end

%____ average ____
FE=(sum(b_a_dist) + sum(a_b_dist))/(length(a) + length(b));

if verbose, fprintf('  ~ END figural_error.m ~ '); end

return



%************** MATLAB "M" function (jim Patton) *************
% Uniformly resample so that there is an equivalent space between points
% SYNTAX       out=uniform_resample(in);   
% INPUTS:      in   position tracetory: nx2 of [xpos ypos]  
% CALLED BY:	 ?
% REVISIONS:   2/4/00     INITATED BY PATTON
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function out=uniform_resample(in);



return

