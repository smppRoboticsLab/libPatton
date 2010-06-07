%______*** MATLAB "M" function (jim Patton) ***_______
%
% The following reads the 
% INITIATED:	 24-jan-95 by Jim Patton 
%______________________________________________________

disp('______________ *** setpath.m  (M-File) *** _____________');

cwd = cd;
disp('Appending the current directory to the matlab path:');
fprintf('%s\n',cwd); 		cwd = [';' cwd ];
matlabpath = ([path, cwd]);  path(matlabpath);

disp('________________________________________________________');

