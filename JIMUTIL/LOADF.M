% x=LOADF(pathfname) 
% loads ASCII input file pathfname.ext 
% if a path is not given, will look for the file in the matlabpath
% returns the data in matrix x
% if the load is not successful, -1 is returned for x
%
% updated 4 January 1994  A. Russo
% Modified 10/2/97 patton to contend with MATLAB 5 change: just piggy-back hdrload onto this, because the problem of using load is that the newer pogram preserves the file's  dot-extension in the variable name 

% ====== begin =======

function x=loadf(pathfname)

[h,x]=hdrload(pathfname);
