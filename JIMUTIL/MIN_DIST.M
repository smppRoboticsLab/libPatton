% ************** MATLAB "M" file  (jim Patton) *************
% The following calculates an array of minimum distances in 2d
% space from x1 to x2. 
%
% 	INPUTS:		x1	series of x & y points, length N
%			x2	series of x & y points, length M
% 	OUTPUTS:	dist	series of minimum distances from 
% 				x1 to some x2 point, length N
%
% initiatied 29-march-1995 by jim patton 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function dist=min_dist(x1,x2);

for i=1:length(x1),
  dist(i) = sqrt((x1(1,1)-x2(1,1))^2 + (x1(1,2)-x2(1,2))^2);
  for j=1:length(x2),
    current_dist = sqrt((x1(i,1)-x2(j,1))^2 + (x1(i,2)-x2(j,2))^2);
    if current_dist < dist(i),
	dist(i) = current_dist;
	end % if
  end % for j
end % for i

return ;
