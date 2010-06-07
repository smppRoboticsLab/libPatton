function C = rotmat( theta, raxis )
% ROTMAT calculates a fundamental rotation matrix
%
% usage:  C = rotmat( theta, raxis )
%
% where
%       theta is vector of rotation angles and
%       raxis is either 'x', 'y', or 'z' indicating the axis of rotation
% and
%       C = [ C1 | C2 | ... | C4 ] with Ci = rotmat(theta(i), raxis )
%



ctheta = cos( theta );
stheta = sin( theta );

% The calculations below take advantage of matlab's column-oriented
% matrix storage where
% C = [ C(1) C(4) C(7) | C(10) C(13) C(16) | ... C(1 + 3n);
%       C(2) C(5) C(8) | C(11) C(14) C(17) | ... C(2 + 3n);
%       C(3) C(6) C(9) | C(12) C(15) C(18) | ... C(3 + 3n)]
n = length( theta );
C = zeros( 3, 3*n );
ii = 1:9:length(C(:));

if raxis == 'x'
%  C = [ 1         0            0;
%        0  cos( theta ) sin( theta );
%        0 -sin( theta ) cos( theta ) ];
  C(ii)     =  ones( size( ii ) );
  C(ii + 4) =  ctheta;
  C(ii + 8) =  ctheta;
  C(ii + 5) = -stheta;
  C(ii + 7) =  stheta;
elseif raxis == 'y'
%  C = [ cos( theta ) 0 -sin( theta );
%               0     1         0;
%        sin( theta ) 0  cos( theta ) ];
  C(ii + 4) =  ones( size( ii ) );
  C(ii)     =  ctheta;
  C(ii + 8) =  ctheta;
  C(ii + 2) =  stheta;
  C(ii + 6) = -stheta;
elseif raxis == 'z'
%  C = [ cos( theta ) sin( theta ) 0;
%       -sin( theta ) cos( theta ) 0;
%               0            0     1 ];
  C(ii + 8) =  ones( size( ii ) );
  C(ii)     =  ctheta;
  C(ii + 4) =  ctheta;
  C(ii + 1) = -stheta;
  C(ii + 3) =  stheta;
else
  error(sprintf('raxis == %s is not one of ''x'', ''y'', or ''z''', raxis ))
end
