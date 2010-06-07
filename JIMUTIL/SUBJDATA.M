%______*** MATLAB "M" file (jim Patton) ***_______
% The following reads the __.fmc (forceplate) and ___dv.txt
% (discrete variables) files and assembles the variables for 
% optimization/regression.
%  VERSIONS:	subjdata.m	This was the 1st working version.
%  INPUTS : 	g, id, day, block, trial (see set_opt#.m files 
%		for descriptions)
%  OUTPUTS : 	all motion variables used in set_opt#.m files 
%  CALLS : 	fileid.m	(matlab function)
%		getinfo.m	(matlab function)
%		inopen.m	(matlab function)
%		readdio.m	(matlab function)
%		cmplot.m	(matlab file)
%  INITIATED:	30-AUG-1994 by jim patton from 'set_opt3.m'
%		10/2/97 patton modified to work in matlab 5
%_________________________begin:_______________________

fprintf('\n*** subjdata.m: ***');

%______ GET PRELIMINARY INFO (SUBJECT PARAMTERS: GEOMETRY, ETC.)____
if day==0, 	% if vision
  [junk,subj_param]=hdrload(['c:\jim\lee\vision\' id '.prm']);
else,  		% if learn_2
  [junk,subj_param]=hdrload(['c:\jim\lee\learn_2\' id '.prm']);
  vision=[];
end; %if day==0

%________________________ LOAD fmc DATA:__________________________
if day==0, FMCname=fileid3(lower(id),block,'.fmc');	% name for vision
else,      FMCname=fileid(id,day,block,'.fmc'); 	% name for learn_2
end;							% end if day
[FMCinfo,Ntrials,freq,FMCtime]=inopen3(FMCname);	% 
fprintf('\nload: %s(trial %2.0f of %2.0fd)...', ...	% 
   FMCname, trial, Ntrials);				% ...
[FMC,FMCheader]=readdio(FMCinfo,trial); 		%
fclose(FMCinfo(1)); fprintf('DONE.\n');		%
if FMCheader(10,1)==-9999;				%
  fprintf(['BAD TRIAL: (header has -9999 in ' ...	% message
  'register 10) -- Aborted.\n'])			% ...
  return;						% stop this mfile
end %if							%
[onset offset Fonset Foffset H mass]=		...	% get info on this block
   getinfo2(lower(id),day,block,Ntrials); 		% ...

%______ EXTRACT THE VARIABLES FROM THE MATRICIES GENERATED ABOVE:________
fprintf('CM motions and forces...');
Fgx 		=  FMC(:,4);  			% x forces at floor	
Fgy 		=  FMC(:,5);  			% y forces at floor	
d		= -FMC(:,8) / 1000;		% AP center of pressure from ankle
Fp		=  FMC(:,7);			% pulling force
CMx		=  FMC(:,10) / 1000;		% center of mass, AP
CMy		=  FMC(:,11) / 1000;		% center of mass, Vertical
dCMx		=  FMC(:,12) / 1000;		% Velocity of center of mass, AP
dCMy		=  FMC(:,13) / 1000;		% Velocity of center of mass, Vertical
ddCMx		=  FMC(:,14) / 1000;		% Acceleration of center of mass, AP
ddCMy		=  FMC(:,15) / 1000;		% Acceleration of center of mass, Vertical
clear FMC;					% clear big matrix

%_____________ CALC PENDULUM ANGLES and RADII______________
CMr		=  sqrt(CMx.^2 + CMy.^2);	% radial position of center of mass
CMth		=  pi/2-atan2(CMy,CMx); 	% !!!NOTE: CMth is the angle of the
						% pendulum clockwise from vertical!!!
% ____________ DIFFERENTIATE __________
fprintf('derivatives...');
dCMr 	= diff(CMr)*freq;		dCMth 	= diff(CMth)*freq;
ddCMr 	= diff(dCMr)*freq;		ddCMth 	= diff(dCMth)*freq;

% ____________ add points to make sizes of all variables the same __________
dCMr(length(dCMr)+1)		= dCMr(length(dCMr));
dCMth(length(dCMth)+1)		= dCMth(length(dCMth));
ddCMr(length(ddCMr)+1)		= ddCMr(length(ddCMr));
ddCMth(length(ddCMth)+1)	= ddCMth(length(ddCMth));
ddCMr(length(ddCMr)+1)		= ddCMr(length(ddCMr));
ddCMth(length(ddCMth)+1)	= ddCMth(length(ddCMth));

%_____________ FRAME/TIMING PARAMS ______________
onset_frame 		= round(onset(trial)*freq); 
offset_frame 		= round(offset(trial)*freq); 
Fonset_frame 		= round(Fonset(trial)* freq); 
Foffset_frame 		= round(Foffset(trial)*freq);
[Fp_max, Fp_frame] 	= max(Fp);				% frame&mag: max pull force
delta_t			= FMCtime(2)-FMCtime(1);  		% sample period

% __ Check for the end of a trial based on PATTON's criterion.__
vf_critierion=0;	off=offset_frame;			% store origianl offset fr.
for q=onset_frame+1:offset_frame,
  %fprintf('.');
  if Fp(q)>.5*max(Fp) & dCMth(q)<.1*min(dCMth), vf_critierion=1; end %if
  if dCMth(q) > 0 & vf_critierion,  
    offset_frame=q;
    fprintf('\nre-adjust "end" based on PATTONs criterion to frame %d from %d\n',q, off);
    break;
  end % if dCMth(q) > 0 & f_critierion & vneg_critierion,
end 	% for q

% __ change event marks if conflict __
fi=onset_frame; fb=Fonset_frame; fpk=Fp_frame; fe=Foffset_frame; ff=offset_frame;
e_o_f=length(FMCtime-2);
if fi>=fb, 	fb=fi+1; 	end;				% fix event mark if conflict
if fb>=fpk, 	fpk=fb+1; 	end; 				% fix event mark if conflict 
if fpk>=fe, 	fe=fpk+1; 	end; 				% fix event mark if conflict 
if fe>=ff, 	fe=ff-1; 	end; 				% fix event mark if conflict 
if fpk>=fe, 	fpk=fe-1; 	end; 				% fix event mark if conflict 
ti=FMCtime(fi); tb=FMCtime(fb); tpk=FMCtime(fpk); te=FMCtime(fe); tf=FMCtime(ff);
FMCtf = offset(trial)-onset(trial);
pull_targ = FMCheader(4,1);

%______________ MISC CALCS USING PARAMTERS (GEOMETRY, ETC):_______________
mf 		= 2 * 0.0145 * mass;		% foot mass 			(estimated)
m 		= mass - mf;			% pendulum mass 		(estimated)
%lf 		= 0.152*H;			% foot length 		  	(estimated)
%a 		= 0.1923*lf;			% horiz:  ankle to heel 	(estimated)
%b 		= 0.039*H;			% vert:  ankle to floor 	(estimated)
BOSa 		= subj_param(11);		% ankle to anterior base of support limit
BOSp 		= subj_param(9);		% ankle to posterior base of support limit
lf 		= subj_param(12);		% foot length 		  	
a 		= subj_param(8);		% horiz:  ankle to heel 	
b 		= subj_param(7);		% vert:  ankle to floor	
wrist_height	= subj_param(14);		% ankle-to-wrist vertical distance
c 		= 0.5*lf;			% horiz:  foot CM to heel 	(estimated)
r 		= CMr(fi);			% pendulum height above ankle	(measured)
theta_i		= CMth(fi); 			% initial theta used for simulations
theta_toe  	= -asin(lf-a);			% theta at which CM projection is over toe
theta_heel 	= asin(a);			% theta at which CM projection is over heel
toe		= lf-a;				% minus x-ankle-to-toe horizontal distance
heel		= -a;				% minus x-ankle-to-heel horizontal distance

%___ SET UP VARS FOR PHI (ALTERNATIVE) COORDS (PHI IS CLOCKWISE FROM X POSITIVE AXIS) ___
CMphi=pi/2-CMth;		dCMphi=-dCMth;			ddCMphi=-ddCMth;
phi_i=pi/2-theta_i; 		phi_toe=pi/2-theta_toe;	phi_heel=pi/2-theta_heel;

% _____ ANKLE KINETICS FROM FORCEPLATE (ASSUMES STATIC FOOT)_______
COP		= (lf-a)-d;			% COP measured from toe (non-normalized)
Fx	 	= Fgx;				% x force at ankle
Fy 		= Fgy - mf;			% y force at ankle
T 		= -(b.*Fgx - d.*Fgy);		% Torque  at ankle

% _____ description VARIABLE THAT DESCRIBES THE TRIAL _______
if ~exist('description'), description=FMCname; end;  % create only if nonexistent

fprintf('\n*** subjdata.m DONE. ***\n');

