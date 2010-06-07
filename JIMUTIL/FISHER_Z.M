% ************** MATLAB "M" function (jim Patton) *************
% function z=fisher_z(r) 
% The following performs a fisher z transform on a value:
% 	see: Glass, G. V., J. C. Stanley  (1970)  Statistical 
%	Methods in Education and Psycology,  Prentice Hall,  
%	Englewood Cliffs, NJ. pg 265
% Make sure that the r value and not the the r-square is the input!
% 	INPUTS:	 	r	
% 	OUTPUTS: 	z
%
% initiatied 7/19/95 by jim patton 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function z=fisher_z(r) 
  ratio = (1+r)./(1-r);
  z = log(sqrt(ratio));
return
