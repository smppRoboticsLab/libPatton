% ***************** MATLAB "M" function (jim Patton) ****************
% The following reads the __.eee (motion)  & finds the average
% angle between the hip-neck and hip-waist vectors.  This is for 
% rotation of the waist marker in the 'f_and_m3.m' prog.
%
% 	INPUTS:		id		subject id
%			day		experiment day
%			block		experiment block
%			Ntrials 	number of trials
%			dneck 		AP distance from neck marker to spine
% 	OUTPUTS:	rot 		average value for rotating 
%					waist marker to the line from
%					hip to neck while standing
% initiatied 16-AUG-1994 by jim patton from 'f_and_m2.m'
% function [mag, rot, AProt] = getwaist(id,day,block,dneck);
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [mag, rot, AProt] = getwaist(id,day,block,dneck);
fprintf('\n *** getwaist.m  (function) ***');

origin 		= [0 0];				% utility vector
anterior	= [-1 0];				% utility vector

EEEname=fileid(id,day,block,'.eee');			% filename
[EEEinfo,Ntrials,EEEfreq,EEEtime]=inopen(EEEname);	% open and get info

%__________ loop for each trial,  load data,  calc angle ____________
fprintf('\nAnalyzing Trial:'); 
for trial = 1:Ntrials,
    %fprintf('Loading: %s,  trial %2.0f of %2.0f...\n',EEEname, trial, Ntrials);
    fprintf(' %2.0f',  trial); 

    [EEE,EEEheader]=readdio(EEEinfo,trial);
    DV = getdvtxt(id,day,block,trial);
    if all(DV(2,:)==(-99999)*ones(1,11));
	if trial == 1,
	   fprintf('skipping trial %2.0f.\n',  trial);	
	   trial = trial  + 1;
          [EEE,EEEheader]=readdio(EEEinfo,trial);
          DV = getdvtxt(id,day,block,trial);
	   t_start = EEEfreq*DV(2,10);	t_end = EEEfreq*DV(2,11);
	   EEE = EEE / 1000;	% Convert to meters from mm
    	   [temple,ear,neck,shoulder,elbow,wrist,waist,hip,knee,ankle,toe,da,LCH] =  ...
	    	markers(EEE,EEEfreq,dneck);
	else
	   fprintf('skipping trial %2.0f -- substituting trial %2.0f.\n', 	...
		trial, trial-1);	
	end % if trial
    else
	% Load trial info & get the baseline index values from baseline times:
	t_start = EEEfreq*DV(2,10);	t_end = EEEfreq*DV(2,11);
	EEE = EEE / 1000;	% Convert to meters from mm
    	%fprintf('done. ');
    	[temple,ear,neck,shoulder,elbow,wrist,waist,hip,knee,ankle,toe,da,LCH] =  ...
	   markers(EEE,EEEfreq,dneck);
     end % if all

    %__________________________________________________
    % ANGLE and MAGNITUDE of VECTOR to ROTATE:
    for i = t_start:t_end,
	a1(i)  = angle_2d(hip(i,:), neck(i,:),  hip(i,:), waist(i,:))';
	a2(i)  = angle_2d(hip(i,:), waist(i,:), origin, anterior)';
    end % for i

    %plot(	[hip(i,1), waist(i,1)], 	[hip(i,2), waist(i,2)], 	'm',	...
    %		[origin(1), anterior(1)],	[origin(2), anterior(2)], 	'm'	);

    angle1(trial)	= mean(a1(t_start:t_end));
    angle2(trial) 	= mean(a2(t_start:t_end));

    % estimated superior distance from hip to L5S1 (SOURCE: Lanier): 
    dist(trial)  	= .195*distance(shoulder(t_start:t_end,:),hip(t_start:t_end,:));

end 	% for trial
fclose(EEEinfo(1));	

%__________________________________________________
% avg to find final angle for all trials
mag 	= mean(dist); 		% estimated superior distance from hip to L5S1 
rot 	= mean(angle1);	% estimated angle from hip-waist axis to L5S1 skin 
AProt 	= mean(angle2);	% estimated angle from hip-waist axis to pelvic AP axis

fprintf('\n *** getwaist.m DONE. ***\n '); 
return
