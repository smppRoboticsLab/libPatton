% ************** MATLAB M function **************
% Derivative function: DX=VEL(T,X)
% If X is a vector [x(1) x(2) ... x(n)], and t is the corresponding time 
% vector [t1 t2 ... tn] then vel(t,X) returns a vector which is the first 
% derivative. If X is a matrix, the derivative is calculated for each 
% column. If t is a scalar value, it is presumed to be sampling frequency.
% SYNTAX:	dx=vel(t,x);
% REVISIONS:	A. Russo 21 January 1995
%		5/8/98 (Patton) accomodates input sampling freq instead of time
% NOTES:	Numerical Methods for Engineers; p.529, first derivative.
% 		dt is the step size e.g. dt=time(2)-time(1);
%	TEST:  derivative of sin(2*pi*t) should be -2*pi*cos(2*pi*t)!!!
%	min(x) should be -2*pi
%	  t=[0:.01:1]';
%	  x=sin(2*pi*t); 
%	  dx=vel(dt,x);
%	  subplot(211),plot(x); 
%	  subplot(212),plot(x)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function dx=vel(t,x);

% __ TIME STEP __
if length(t)==1, dt=1/t; else, dt=t(5)-t(4); end;
	
% __ DIFFERENTIATE __
[m,n]=size(x);
if m==1&n==length(x), x=x'; end    % transpose if row vect
x=(-1*x(5:m,:) +8*x(4:m-1,:) -8*x(2:m-3,:) + x(1:m-4,:))/(12*dt);

%__ ADD TWO DATA POINTS AT THE BEGINNING AND TWO __
%__ DATA POINTS AT THE END FOR EACH COLUMN OF N __
for i=1:n 
  dx(:,i)=[x(1,i) x(1,i) x(:,i)' x(size(x,1),i) x(size(x,1),i)]';
end

return
