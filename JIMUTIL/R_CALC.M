%______*** MATLAB "M" function (jim Patton) ***_______
%
% Calculates the pearson r value between 2 time histories.
% The first time history provides the domain for the 
% second, so that the second time history is linearly
% interpolated to match the domain of the first (time1).
%
% CALLED BY: 	regress#.m	see this file for more info
%				(where # = version) 
% 
% INPUTS : 	time1		base time domain
%		var1		variable 1
%		time2		second time domain
%		var2		variable 2
%
% OUTPUTS : 	r		pearson product-moment 
%				correlation coeficient
%
% INITIATED:	8 may 1995 by Jim Patton from "ERR_CALC.m" 
%______________________________________________________
% FUNCTION STATEMENT:
function r = r_calc(time1, var1, time2, var2);
%disp('*** r_calc.m (function) ***'); 

new_var2 =	interp1(time2, var2, time1);
r = 		pearson(var1, new_var2,0);

