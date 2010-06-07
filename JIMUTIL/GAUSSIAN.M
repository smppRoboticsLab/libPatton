% ******************* MATLAB "M" file  (jim Patton) ******************
% evaluate gaussian time record and its derivative
%  SYNTAX:	[y,Dy,DDy]=gaussian(mag,t,t0,width99);
%  INPUTS:	M	magnitude
%		t	time vector (record of time)
%		t0	time of g center
%		width99 time-width of gaussian at 1% of magnitude
%  OUTPUTS:	y 	gaussian column vect
%		Dy	1st derivative, column vect
%		DDy 	2nd derivative, column vect
%  CALLS:	
%  CALLED BY:	
%  INITIATIED:	7/8/97 patton. 		
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~

function [y,Dy,DDy]=gaussian(M,t,t0,width99);

%______ SETUP ______
global DEBUGIT						% global declaration
global plot_or_not					% global declaration
if DEBUGIT, fprintf('\n ~ gaussian.m ~ '); end;	% message if DEBUGIT~=0
	
gsf=4.2919;						% factor that makes a 
							% gaussian have a width 
							% of 1 at 1% of the 
							% total magnitude.
if length(t(:,1))<length(t(1,:)), t=t'; end;		% transpose if row vect

%______ FUNCTION EVAL ______
q=gsf/width99;	
z=-2*q^2;
x=t-t0;
y=M*exp(-(q*x).^2);

%______ DERIVATIVES EVAL ______
Dy=z.*x.*y;
DDy=z*y + z.*x.*Dy;

%______ ______
%if plot_or_not&DEBUGIT,
%  dt=t(2)-t(1);
%  dy=[0;diff(y)]./dt;
%  ddy=[0;diff(dy)]./dt;
%  plot( t,y,  				...
%        t,Dy, 'y',  t,dy, 'b:', 	...
%        t,DDy,'g',  t,ddy,'k-.', 	...
%        'linewidth',3)
%  legend('G','Gprime','diffG','G2prime','diffdiffG');
%end;	

if DEBUGIT, fprintf('\n ~ END gaussian.m ~ '); end;	% message if DEBUGIT~=0

