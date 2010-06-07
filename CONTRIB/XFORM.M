function y = xform( C, x )
% XFORM transforms the vector x using n rotation matrices
%
% usage:  y = xform( C, x)
%
% where
%
%       x = [x1 | x2 | ... | xn];
%       C = [C1 | C2 | ... | Cn];
% and
%       y = [C1*x1 | C2*x2 | ... | Cn*xn];
% and xi is a 3x1 column vector and Ci is a 3x3 rotation matrix
%

y = zeros( size( x ) );
ii = 1:3;
jj = 0:3:size(C,2)-1;

if( size(C,2) == 3 )
  for i = 1:size(y,2)
    y(ii,i) = C * x(ii,i);
  end
else
    for i = 1:size(y,2)
    kk = ii + jj(i);
    y(ii,i) = C(ii,kk) * x(ii,i);
  end
end

