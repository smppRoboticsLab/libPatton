% ***************** MATLAB "M" function (jim Patton) ****************
% The following reads the __dv.txt (dicreet variable trials) & 
% returns dv.txt data for trial in matrix DV
% 	INPUTS:		id		subject id
%			day		experiment day
%			block		experiment block
%			trial	 	experiment trial
% 	OUTPUTS:	rot 		average value for rotating 
%					waist marker to the line from
%					hip to neck while standing
% initiatied 18-jan-95 by patton from 'readdv.m' by Russo(see a_fmc)
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function DV = getdvtxt(id,day,block,trial);
%disp('*** getdvtxt.m  (function) ***');

% load a dv.txt file:
fname =fileid(id,day,block,'dv.txt');
dvdata =loadf(fname);

if dvdata == -1 
    fprintf('warning: file %s does not exist\n', fname);
    return;
end

% extract trial info:
DV=dvdata((trial-1)*6+1:(trial-1)*6+6,:);

if all(DV(2,:)==(-99999)*ones(1,11));
    fprintf('warning: trial %d deleted\n',trial);
end

%disp('*** END getdvtxt.m (function) ***');	

