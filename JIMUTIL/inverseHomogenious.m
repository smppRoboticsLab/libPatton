%% inverseHomogenious.m:  Inverse of a homogenious transform
% SYNTAX:       T=inverseHomogenious(T)
%                     where T is a 4 by 4 homogenious transformation
%                     defined in most robotics or computer graphics texts 
% REVISIONS:     PATTON feb 6 2009
%% ~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~
function T=inverseHomogenious(T)
R=T(1:3,1:3);
d=T(1:3,4);
T=[R' -R'*d; [0 0 0 1]];
end
