%______*** MATLAB "M" function (jim Patton) ***_______
% The sets up directroies to search  environment for matlab.
% CALLS :      path.m	(matlab file)
% INITIATED:   10-12-98 by jim patton 
%______________________________________________________

  disp('____________________ startup.m ___________________________ ');
  fprintf('Setting up for JIM"s "Patton_shares_MFILES" mfiles library -- see: ');
  which jim
  matlabpath=([path, ...
		';Z:\Robotlab\patton_shares_MFILES',...
		';Z:\Robotlab\patton_shares_MFILES\CONTRIB',...
		';Z:\Robotlab\patton_shares_MFILES\CONTRIB\EZtools',...f
		';Z:\Robotlab\patton_shares_MFILES\JIMUTIL\digitize',...
		';Z:\Robotlab\patton_shares_MFILES\JIMUTIL',...
		';Z:\Robotlab\patton_shares_MFILES\robotStuff',...
		]);
  path(matlabpath);
  disp('Directories have been are added to the path. Type PATH to see'); 

  global DEBUGIT 
  DEBUGIT=0;		% default is for no debugging to be done
  disp('variable DEBUGIT has been set to global.');
  
disp('________________ END startup.m __________________ ');
fprintf('\7');
% load ('train');	sound(y,Fs*6); clear y; clear Fs

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

