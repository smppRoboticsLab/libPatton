%______*** MATLAB "M" function (jim Patton) ***_______
% The sets up directroies to search  environment for matlab.
% CALLS :      path.m	(matlab file)
% INITIATED:   10-12-98 by jim patton 
%______________________________________________________

  disp('_____________ jim.m _____________ ');
  fprintf('Setting up for JIM"s "Patton_shares_MFILES" mfiles library -- see: \n');
  which jim
  jimDir='\\165.124.30.17\robotics\Robotlab\patton_shares_MFILES';
  matlabpath=([path,                ...
		jimDir,                     ...
		[';' jimDir '\CONTRIB'],     ...
		[';' jimDir '\CONTRIB\EZtools'],         ...
		[';' jimDir '\CONTRIB\structdlg'],        ...
		[';' jimDir '\JIMUTIL\digitize'],        ...
		[';' jimDir '\JIMUTIL'],                 ...
		[';' jimDir '\robotStuff'],              ...
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

