% ************** MATLAB M function (Patton) **************
% calculates the relative 2 D angle between 2 vectors constructed from points.
% SYNTAX:	theta=angle_2d(x1,x2,x3,x4,noverbose)
% INPUTS:	x1,x2,x3,x4	Each is a matrix of x-y coordinates 
%				(in columns) and time (in rows). 
%		verbose 	(optional) zero (default) supresses messages 
% OUTPUTS:	theta		angle vs time vexctor FROM the vector formed 
% 				by x1 to x2 TO the vector formed by x3 to x4 
%				and returns theta vs time. The first element 
%				in the markers is x & second is y.  Therefore,
% 				postive theta is z or counter-clockwise.
% CALLS:	
% CALLED BY: 	
% REVISIONS: 	initiated way back in the summer of 1994 sometime by Patton.
% 		updated 24 June 1994 (Patton)
%		4/17/98 (Patton): Add feature that assures best continuity
% 		        remove bug near 180 degrees.	
% NOTES:	* Code is best viewed in MS word, courier new 8pt font
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function theta=angle_2d(x1,x2,x3,x4,verbose)

%____  PRELIM STUFF ____
if ~exist('verbose'), verbose=0;	end;		% set var
if verbose,fprintf('\n~angle_2d.m ~ '); end		% message
[rows cols] = size(x1);				% dimension of inputs
theta=zeros(rows,1);					% dimension output

%____  FIND VECTORS ____
v1 = x2-x1; 						% "FROM" vector 
v2 = x4-x3; 						% "TO" vector 

% ____NORMALIZE & FIND PERPENDICULARS____
for i=1:rows,  					% loop for each row (time)
    v1(i,:) 	= v1(i,:)/norm(v1(i,:));		% normalize
    v2(i,:) 	= v2(i,:)/norm(v2(i,:));		% normalize
    v1_p(i,1) 	= v1(i,2);				%
    v1_p(i,2) 	= -v1(i,1);				%
    v2_p(i,1) 	= v2(i,2);				%
    v2_p(i,2) 	= -v2(i,1);				%
	
  % ____ ANGLES ____
  if abs(  sum(v1(i,:).*v2(i,:)) ) > 0.7071   	% if near 0 or 180 degrees 
    if sum(v1(i,:) .* v2(i,:)) > 0			% near 0 degrees
      theta(i) = asin(sum(v2_p(i,:) .* v1(i,:)));	%
    else 						% near 180 degrees
      theta(i) = pi-asin(sum(v2_p(i,:) .* v1(i,:)));	%
    end  %if						%
  else							% if near 90 degrees 
    if sum(-v1_p(i,:) .* v2(i,:)) > 0			% near 90 degrees
      theta(i) = acos(sum(v2(i,:) .* v1(i,:)));	%
    else 						% near -90 degrees
      theta(i) = -acos(sum(v2(i,:) .* v1(i,:)));	%
    end  %if						%
  end %if						%

end %for i=1:rows


% ____ ASSURE BEST CONTINUITY ____
for i=2:rows,  					% loop: each row (time)

  if     abs(theta(i)+2*pi-theta(i-1)) < 	...	% if add 360 degr is better
         abs(theta(i)-theta(i-1))			%
         theta(i:rows)=theta(i:rows)+2*pi;		% then adjust the rest
  elseif abs(theta(i)-2*pi-theta(i-1)) < 	...	% if add 360 degr is better
         abs(theta(i)-theta(i-1))			%
         theta(i:rows)=theta(i:rows)-2*pi;		% then adjust the rest
  end

end %for i

if verbose,fprintf('\n~END angle_2d.m ~ '); end	% message

