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
%		
% OUTPUTS : 	y
%
% INITIATED:	23 OCT 1994 by Jim Patton from "sigmoid.m" code
%________________________________________________________________
% FUNCTION STATEMENT:

function y = dsigmoid(z,q,g);
%disp('*** sigmoid.m (function) ***'); 

%______________________________________________________
% 
y = g*q*exp(-q*z)/(1+exp(-q*z))^2;


%disp('*** END sigmoid.m (function) ***'); 
return;

