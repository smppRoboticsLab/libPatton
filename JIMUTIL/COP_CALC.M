% ************** MATLAB "M" file  (jim Patton) *************
% this calciulates the center of pressure (COP) of a force plate.
% INPUTS:	fp		matrix of 6 channels from the 
%				force plate in collumns and each 
%				row is an instant of time. 
%				(Mx My Mz Fx Fy Fz)
%		origin		the vector indicating the position 
% 				of the force plate instrument 
%				center from the center of the 
%				surface of the forceplate
% OUTPUTS:	COP		a matrix of x and y positions	in each		 
%				column and each row is an instant of time.
%				COP is from instrument center.
% SEE:		C:\JIM\PERSONAL\HTML\COP.HTM%
% initiatied 3-may-1994 by jim patton from 'anal_1.m'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

% disp('*** COP_calc.m function (for force plate) by Jim Patton ***');
function COP = cop_calc(fp, origin)
h = origin(3);

COP(:,1) = (h*fp(:,4) - fp(:,2))./fp(:,6);
COP(:,2) = (h*fp(:,5) + fp(:,1))./fp(:,6);

