% ************** MATLAB "M" function (jim Patton) *************
% Fit a linear model of a sum of coefficients times basis fcns.
% Uses the "numerical recipes in C" nomenclature and approach: construct an 
% A matrix and b vector, and a alpha matrix and beta vector from these.
% SYNTAX:    [d,r,norm_ssq]=linear_least_squares(A,b,verbose);
% INPUTS:    A,b
% OUTPUTS:   d,
%            r_squared
% VERSIONS:  5/11/99     INITIATED by Patton 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [d,r,norm_ssq]=linear_least_squares(A,b,verbose);

%_________ SETUP ________
fcnName='linear_least_squares.m';
global DEBUGIT 
if ~exist('verbose'), verbose=1; end                 % if not passed
if verbose,fprintf('\n ~ %s ~ \n',fcnName); end      %
r_squared=NaN;                                       % fix this!

%_________ LEAST SQUARES SOLUTION ________
alpha=A'*A;
beta=A'*b;
d=pinv(A)*b;

if DEBUGIT
  diary, 
  disp('pausing before showing variables..'), 
  pause, A,b,alpha,beta, 
  diary off
end

%_________ r & SUM of SQUARES of ERRORS ________
corMTX=corrcoef(A*d,b);
r=corMTX(1,2);
norm_ssq=sum((A*d-b).^2)/length(A(:,1));

%________ Wrap this fcn up ________
if verbose,fprintf(' ~ END %s ~ ',fcnName); end      %
return