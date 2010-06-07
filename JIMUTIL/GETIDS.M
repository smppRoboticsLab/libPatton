% ************** MATLAB "M" file  (jim Patton) *************
% The following determines the subject data avialable for processing
%
% 	INPUTS:	 					
% 	OUTPUTS:	
%	CALLS:		
%
% initiatied 8/9/95 jim patton from 'non_opt9.m'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function IDs=getids(ROOTNAME);
disp(['*** getids.m (M function) for ' ROOTNAME ' ***']);

%____________________ GETids matrix on this disk: ____________________
if exist('ids.mat'),  load Ids;
else
  ok = 'n'; IDs = ['00'];

  while ok ~= 'y',
    disp('Enter the subject IDs on this drive: ');
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ');
    i = 1; newIDs = 'null';
    while newIDs ~= '9', 
	newIDs = input('ENTER SUBJECT ID <enter 9 to indicate no more subjects>: ','s');
	if newIDs == '9', 
	  break; 
	else 
	  IDs(i,:) =  newIDs;
	end; % if
	i = i+1;
    end; % while newIDs 
    IDs
    ok = input('Is this OK? (y/n)','s');
  end; % while ok...
  save IDs IDs;
end 	% if exist...	

return;
