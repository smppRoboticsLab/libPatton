%___________*** MATLAB "M" function (jim Patton) ***_____________
%
% this is function that calculates the output of a unit based on
% its activation 
%
% CALLED BY: 	
% 
% INPUTS : 	z		activation
%		q		factor to scale z by before calc.
%		g		linear gain of final value
%		offset		linear offset of final value
%		
% OUTPUTS : 	y
%
% INITIATED:	19 OCT 1994 by Jim Patton from "regres5.m" code
%________________________________________________________________
% FUNCTION STATEMENT:

function y = sigmoid(z,q,g, offset);
%disp('*** sigmoid.m (function) ***'); 

%______________________________________________________
% 
y = g/(1+exp(-q*z)) + offset;


%disp('*** END sigmoid.m (function) ***'); 
return;

