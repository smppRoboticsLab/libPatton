% ************** MATLAB "M" file  (jim Patton) *************
% returns a zero if no negative values exist in the matrix, a 
% positive value otherwise, indicating how many negative values
%  INPUTS:	q 		matrix
%  OUTPUTS:	y 		# of negative elements in q
%  CALLS:	-
%  CALLED BY:	?
%  SYNTAX:	y=isneg(q);
%  INITIATIED:	6/12/96 jim patton 
%  SEE:		\jim\matlab (or possibly the OLD subdirectory)
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function y=isneg(q)
y=sum(sum(isinf((1./((abs(q)-q)-(max(max(q))/2))))));

