% ***************** MATLAB "M" function (Jim Patton) ****************
%
% The following reads the __.txt (event marks) & beginings and 
% ends of motion based on CMap velocity onset and offset plus and
% minus a 'buffer' time
%
% 	INPUTS:		id		subject id
%			day		experiment day
%			block		experiment block
%			Ntrials 	number of trials
% 	OUTPUTS:	onset 		beginning of Cmap velocity
%			offset 		ending of Cmap velocity
%			H 		body height
%			mass 		body mass
% 	INITIATIED:	17-AUG-1994 by jim patton 
% 	SEE:		c:\jim\matlab\getinfo2.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [onset, offset, Fonset, Foffset, H, mass] = getinfo(id,day,block,Ntrials);
fprintf(' ~ getinfo2.m (function) ~ ');

%___________________ LOAD DATA _______________________
if day==0, 	TXTname=fileid3(id,block,'dv.txt');  		% file id info for vision
else,  		TXTname=fileid(id,day,block,'dv.txt'); 	% file id info for learn_2
end;
fprintf('loading: %s...', TXTname);
FMCmarks = loadf(TXTname);

%_____________ EXTRACT THE OUTPUT VARIABLES _____________
onset(1:Ntrials) 	= FMCmarks(3:6:Ntrials*6,2); % Cmap velocity onset  for all trials
offset(1:Ntrials) 	= FMCmarks(3:6:Ntrials*6,3); % Cmap velocity offset for all trials 
Fonset(1:Ntrials) 	= FMCmarks(2:6:Ntrials*6,2); % Cmap velocity onset  for all trials
Foffset(1:Ntrials) 	= FMCmarks(2:6:Ntrials*6,3); % Cmap velocity offset for all trials 
H 			= FMCmarks(1,7);
mass 			= FMCmarks(1,8);
Fp_targ(1:Ntrials) 	= FMCmarks(1:6:Ntrials*6,11); % percent of max force (target force)

fprintf(' ~ getinfo2.m DONE. ~ ');

