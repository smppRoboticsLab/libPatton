%______*** MATLAB "M" function (jim Patton) ***_______
%
% Calculates the sum of sqares of error of 2 time histories.
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
% OUTPUTS : 	err		sum of sqares of error
%
% INITIATED:	9 may 1995 by Jim Patton from "R_CALC.m" 
%______________________________________________________
% FUNCTION STATEMENT:
function err = ss_calc(time1, var1, time2, var2);
%disp('*** err_calc.m (function) ***'); 

new_var2 =	interp1(time2, var2, time1);
err = 		sum(   (var1-new_var2).^2    );

