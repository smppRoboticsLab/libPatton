%************** MATLAB "M" fcn  *************
% exponential function with free offset, magnitude and time constant (p)
% SYNTAX:    f=expDecay(p,xdata)
%            p(1)     offset
%            p(2)     magnitude of the shift
%            p(3)     time constant (1/decay rate)
%            xdata    point(s) for domain of the function
% See also expRegression
% REVISIONS: initiated 4/26/3 patton from sterpTypeCurve3 in SFD writeup directory
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function f=expDecay(p,xdata)

f = p(1)*ones(size(xdata))+p(2)*exp(-xdata./p(3));

