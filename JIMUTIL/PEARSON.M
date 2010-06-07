% ************** MATLAB "M" file  (jim Patton) *************
% This calculates the pearson product-moment correlation coff (r). 
%
%	FORMULA:			sum[(x-xbar)(y-ybar))]
%			r  =	-------------------------------------
%				sqrt{sum[(x-xbar)^2]*sum[(y-ybar)^2]}
%
%
% 	INPUTS:		x and y vectors (same length),  plot_yes variable (nonzero to plot)	
% 	OUTPUTS:	r value
%	CALLS:		-
%
% initiatied 9-april-1995 by jim patton from 'non_opt6.m'
% revised 2-23-2003 by patton for regression line
% revised 9-30-2005 by patton for handle to data
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [r,a,h]=pearson(x,y,plotIt);

disp('~pearson.m (matlab function) ~ ');

if ~exist('plotIt'),	plotIt='y'; end;
if size(x,2)>1, x=x'; end; % make column
if size(y,2)>1, y=y'; end; % make column 

% clear any NaN's:
D=[x y];
D=cleannan(D);
x=D(:,1); y=D(:,2);

% r-value
xbar = mean(x);
ybar = mean(y);
num = sum( (x-xbar).*(y-ybar) );
den = sqrt(    sum(  (x-xbar).^2  )      *    sum(   (y-ybar).^2   )       );
r=num/den;

% regression 
X=[ones(size(x)) x];
a=X\y;

if plotIt,	
  h=plot(x,y,'ko'); hold on
  ax=axis;
  x=[ax(1) ax(2)]';                                 % simple corners for x points
  y=[ones(size(x)) x]*a;
  hold on; 
  h(2)=plot(x,y);
end;


%disp('*** (END pearson.m (matlab function) ***');

