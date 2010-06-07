% ***************** MATLAB "M" file  (jim Patton) ****************
% The following reads the __.eee (motioin)  & __.fmc (forceplate)
% files and reassigns all the values to variables for inverse dynamic
% analysis (IDA).
%  INPUTS:	needs the following variables:
%  		id		2 letter identification string for a subject
%  		day		day of practice 
%  		block		datablock number
%  		trial 		trial number 
%  		dneck 		AP distance from neck marker to spine (usually .04)
%		___.fmc files	(dataio)
%		___.eee files	(dataio)
%  OUTPUTS:	Fgx, Fgy, d			forceplate parameters
%		Fp				pull force
%		time				syncronized time
%		num_seg				number of joints in model
%		phi,Dphi,DDphi			segment angles&deriv's(from horiz-right)
%		l				segment length (joint to joint)
%		r				segment center of mass location
%						(distal joint to segment CM)
%		a 				horiz:  ankle to heel 	(estimated)
%		c				horiz: ankl to foot CM	(estimated)
%		mf				foot mass
%		If				foot inertia
%		m				segment masses
%		I				segment inertias
%  CALLS:	'inopen.m'  function
%		'readdio.m'  function
%		'geninfo2.m' finction
%		'markers.m'  function                          \\/
%		'distance.m'  function                         ( )
%		'angle_2d.m'  function                          o
%			                                        /|
%			                                       5 4
%  MODEL:	#   	SEGMENT                               /  o
%  ~~~~~~	0	foot (stationary)                --6-o   |3 
%		1	leg                                      o               
%		2	thigh                                   2
%		3	pelvis                                 /
%		4	thorax_and_abdomen 	(TA)            o    
%		5	upper_arm 		(UA)             1 
%		6	lower_arm_and_hand 	(LA)              \
%								 ===o=
%							     ~~~~~~~~~~~~
%                                                              
% INITIATIED:	18-jan-1995 by jim patton from 'f_and_m3.m'
% VERIONS:	12/11/96 f_and_m5 (patton) new various inverse dynamics
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

fprintf('\n*** f_and_m5.m M-FILE ***');

%__________________________________________________
% new VARIABLES
EEEname		= fileid(id,day,block,'.eee');
FMCname		= fileid(id,day,block,'.fmc');
half_target	= .0025; 		% half the target depth (half radius)
in_from_skin 	= .0604+half_target;	% skin surface to L5S1 joint center. Source: 

%_______________________ LOAD DATA:___________________________
% ____Load motion data____
[EEEinfo,Ntrials,EEEfreq,EEEtime]=inopen3(EEEname);
%fprintf('Loading motion data: %s,  trial %2.0f of %2.0f',EEEname, trial, Ntrials);
fprintf('Loading: %s...',EEEname);  [EEE,EEEheader]=readdio(EEEinfo,trial);
EEE = EEE / 1000;	% Convert to meters from mm
fclose(EEEinfo(1));  fprintf('...Convert to meters from mm...DONE.');

%____ Load forceplate data____
[FMCinfo,Ntrials,FMCfreq,FMCtime]=inopen3(FMCname);
%fprintf('loading forceplate data: %s,  trial %2.0f of %2.0fd',FMCname, trial, Ntrials)
fprintf('Loading: %s...',FMCname);   [FMC,FMCheader]=readdio(FMCinfo,trial);
if FMCheader(10,1) == -9999;	return;		end %if
fclose(FMCinfo(1));	fprintf('done.\n');

%____ load DV.txt data ____
if trial==1 | last_block~=block | last_day~=day | last_id~=id, 	% if new block
  TXTname=fileid(id,day,block,'dv.txt'); fprintf('Load:%s...',TXTname);
  FMCmarks=loadf(TXTname);			
  if FMCmarks==-1, fprintf('\nCAN"T OPEN FILE %s\n', TXTname); return; end;
  fprintf('DONE.');
  [onset offset Fonset Foffset H mass]=getinfo2(id,day,block,Ntrials); 
end %if trial

% _________ get the paramter file for this subject (in: c:\jim\lee\learn_2\)________
if (block==1 & trial==1) | last_id~=id,
  fprintf('\nUpdating parameter file.')
  eval(['load c:\jim\lee\learn_2\' id '.prm']);  eval(['subj_param =' id '; clear ' id]);
end %if block..

% =======  EXTRACT THE VARIABLES FROM THE MATRICIES LOADED ABOVE:  ========

% ___ marker positions from motion data___
[temple,ear,neck,shoulder,elbow,wrist,waist,hip,knee,ankle,toe,da,LCH] = 		...
	   markers(EEE,EEEfreq,dneck);

% ___ center of pressure and forces ___
Fgx 		=  FMC(:,4);  		% x forces at floor	
Fgy 		=  FMC(:,5);  		% y forces at floor	
d		= -FMC(:,8) / 1000;	% center of pressure from ankle
Fp		=  FMC(:,7);		% pulling force
[Fp_max, Fp_frame] = max(Fp);

clear EEE;				% clear big matrix
clear FMC;				% clear big matrix

%_____________ SEGMENT GEOMETRIES AND MASS DISTRIBUTIONS:______________
% __ segment geometry (estimates from Winter, 1990):__
H	= subj_param(3);		% body height			(measured)
mass 	= FMCmarks(1,8);		% body mass			(measured)
lf 	= 0.152*H;			% foot length 			(estimated)
l(1) 	= distance(ankle,knee);	% leg length 			(measured)
l(2) 	= distance(knee,hip);		% thigh length 		(measured)
l(3) 	= distance(hip,waist);		% pelvis length 		(measured)
l(4) 	= distance(waist,shoulder);	% thorax&abdomen length 	(measured)
l(5) 	= distance(shoulder,elbow);	% upper arm length 		(measured)
l(6) 	= distance(elbow,wrist);	% lower arm length 		(measured)
a 	= 0.1923*lf; 			% horiz:  ankle to heel 	(estimated)
b	= da(2);			% vert ankle height		(measured)
c 	= 0.500*lf;			% horiz: ankl to foot CM	(estimated)
r(1) 	= 0.567*l(1);			% leg distal end to CM  	(estimated)
r(2) 	= 0.567*l(2);			% thigh distal end to CM 	(estimated)
r(3) 	= 0.105*distance(hip,shoulder); 	% pelvis distal end to CM	
r(4) 	= 0.63*distance(hip,shoulder); 	% thorax&abdomen distal end to CM
r(5) 	= 0.564*l(5);			% upper arm distal end to CM 	(estimated)
r(6) 	= 0.570*l(6);			% lower arm distal end to CM 	(estimated)

% __ segment masses & inertias (estimates from Winter, 1990):__
mf 	= 2 * 0.0145 * mass;		% foot mass 			(estimated)
m(1) 	= 2 * 0.0465 * mass;		% leg mass 			(estimated)
m(2) 	= 2 * 0.1000 * mass;		% thigh mass 			(estimated)
m(3) 	= 1 * 0.142 * mass;		% pelvis mass 			(estimated)
m(4) 	= 1 * 0.355 * mass + ...	% thorax, abdomen, head, and
	  1 * 0.081 * mass;		    % neck mass 		(estimated)
m(5) 	= 2 * 0.016 * mass;		% upper arm mass 		(estimated)
m(6) 	= 3 * 0.028 * mass;		% lower arm mass 		(estimated)
If	= mf   * (lf    * 0.475)^2; 	% foot inertia 		(estimated)
I(1) 	= m(1)* (l(1) * 0.302)^2;   	% leg inertia 			(estimated)
I(2) 	= m(2)* (l(2) * 0.323)^2;  	% thigh inertia 		(estimated)
I(3) 	= m(3)* (l(3) * 0.496)^2;	% ??? pelvis inertia 		(estimated)
I(4) 	= m(4)* (l(4) * 0.496)^2 +...	% ??? thorax, abdomen, head, and
	  1 * 0.081 * mass *      ...		% neck inertia		(estimated)
	  (distance(shoulder,ear) * 0.495)^2 *  (distance(shoulder,ear))^2;	  
I(5) 	= m(5)* (l(5) * 0.322)^2;  	% upper arm inertia		(estimated)
I(6) 	= m(6)* (l(6) * 0.303)^2;  	% lower arm inertia		(estimated)

% __ PULLING FORCE BIN __
pointer=(trial-1)*6+1;   						% index trials 1st row 
pct_peak_force=FMCmarks(pointer+1,4)/FMCmarks(pointer,10)*100;	% Peak force, % of max
pull_targ=round(FMCmarks(pointer,11)/FMCmarks(pointer,10)*100); 	% calc targ percentage
bin=round(pct_peak_force/10)*10;					% sort into a forcebin
fprintf('\nPull force=%2.0fpctOmax, bin %d\n', pct_peak_force, bin); 			

%___________ TRANSFORMATIONS OF WAIST MARKER TO ESTIMATED L5S1 CENTER:_________
% ___ estimate the waist rotation for this subject ___
if trial==1 | last_block~=block | last_day~=day | last_id~=id, 	% load if new block
  [mag,rot,AProt]=getwaist(id,day,block,dneck);	% estimate avg rotation of
				  			% waist marker to L5/S1 joint
							% & avg rotation to AP axis
							% from hip-waist marker
end %if trial
waist1=waist;						% store the original value 
% ___ find AP transformation matrix (const for all times): ___
spine_offset = -30*pi/180;	% anterior axis 30 degrees INFERIOR (change 2-23-95)
AP = 	[ cos(AProt-spine_offset) 	-sin(AProt-spine_offset);	...
	  sin(AProt-spine_offset) 	 cos(AProt-spine_offset)  ];
% ___find the pelvic/lumbar AP axis by transforming the hip_to_waist vector: ___
hip_to_waist =  waist - hip;
APaxis = (AP*(hip_to_waist)')';	
APaxis = [	APaxis(:,1)./sqrt((sum((APaxis.^2)')')) ...	% normalize this array
		APaxis(:,2)./sqrt((sum((APaxis.^2)')'))];
% ___find the pelvic/lumbar inferior-superior axis by rotating Apaxis -90 deg: ___
ROT90 =	[ cos(-90*pi/180) 	-sin(-90*pi/180);	...
	  sin(-90*pi/180) 	 cos(-90*pi/180)  ];
ISaxis = (ROT90*( APaxis)')' ;
% ___Transform the waist marker to the estimated L5/S1 skin surface ___
waist(:,1) 	= hip(:,1) +	mag.*cos(-rot) + mag.*sin(-rot);
waist(:,2) 	= hip(:,2) -	mag.*sin(-rot) + mag.*cos(-rot);
%description = [description ' waist_rot=' num2str(rot/pi*180) 'deg'];
waist2 = waist;
% ___Transform the waist marker to the estimated L5/S1 joint center along AP axis: ___
waist = waist + (in_from_skin*APaxis);

%___________ JOINT ANGLES AND SEGMENT ANGLES FROM MARKERS __________
% ___ segment angles from markers___
fprintf('Calc angles...');
origin 			= zeros(length(hip), 2);				% utility vect
right_one(:,1) 	= ones(length(hip), 1);				% utility vect
right_one(:,2) 	= zeros(length(hip), 1);				% utility vect
ang(:,1) 		= angle_2d(origin ,right_one, ankle, knee)';		% shank
ang(:,2) 		= angle_2d(origin ,right_one, knee,  hip)' ;		% thigh
ang(:,3) 		= angle_2d(origin ,right_one, hip, waist)' ;		% pelvis
ang(:,4) 		= angle_2d(origin ,right_one, waist, neck)';		% HAT
ang(:,5) 		= angle_2d(origin ,right_one, shoulder, elbow)';	% upper arm
ang(:,6) 		= angle_2d(origin ,right_one, elbow, wrist)';	% lower arm
fprintf(' DONE.');

% ___ filter segment angles ___
fprintf(' Filter angles...');
for i=1:6,
  ang(:,i)=butterx(ang(:,i),EEEfreq,3,8);
end; %for
fprintf(' DONE.');

% ___ plot ___
%clg;	plot(ang*180/pi,'linewidth', 5);	title('segment angles');
%legend('leg', 'thigh', 'pelvis', 'HAT', 'humerous', 'arm');
%drawnow;

% ___ joint angles from markers NOTE:   % omitted for speed of calculations ___
%j_angle(:,3) = angle_2d(	hip, 	waist, 	knee,	hip)' + pi;	% HIP 
%j_angle(:,4) = angle_2d(	waist, 	neck,	hip,	waist)' + pi;	% LUMBAR

% ___ plot ___
%figure(5); 	clg;	plot(j_angle*180/pi);	title('joint angles');
%text(0,j_angle(1,3) *180/pi,'hip'); 	text(0,j_angle(1,4) *180/pi,'lumbar');
%text(0,min(min(j_angle))*180/pi,description);
%drawnow;

% __ CUBIC SPLINE INTERPOLATE THE DATA TO MATCH THE SAMPLING RATE OF FORCE PLATE__
fprintf('splining...');
phi = [];	J_angle = [];
phi(:,1) 	= spline(EEEtime, ang(:,1), FMCtime);
phi(:,2) 	= spline(EEEtime, ang(:,2), FMCtime);
phi(:,3) 	= spline(EEEtime, ang(:,3), FMCtime);
phi(:,4) 	= spline(EEEtime, ang(:,4), FMCtime);
phi(:,5) 	= spline(EEEtime, ang(:,5), FMCtime);
phi(:,6) 	= spline(EEEtime, ang(:,6), FMCtime);
fprintf(' DONE.');

% omitted for speed of calculations
%J_angle(:,3) 	= spline(EEEtime, j_angle(:,3), FMCtime);
%J_angle(:,4) 	= spline(EEEtime, j_angle(:,4), FMCtime);

ISaxis = [(spline(EEEtime,ISaxis(:,1),FMCtime)) (spline(EEEtime,ISaxis(:,2),FMCtime))];

%_________________ DERIVATIVES OF SEGMENT ANGLES _______________
fprintf('Calc derivatives...');
Dphi=diff(phi)*FMCfreq;			% DIFFERENTIATE
Dphi=[Dphi(1,:); Dphi];			% ADD POINTS TO MAKE SIZE THE SAME 
DDphi=diff(Dphi)*FMCfreq; 			% DIFFERENTIATE
DDphi=[DDphi(1,:); DDphi];			% ADD POINTS TO MAKE SIZE THE SAME 
fprintf(' DONE.');

%_____________ FRAME/TIMING PARAMS ______________
onset_frame 		= round(onset(trial)*FMCfreq); 		% movement onset
offset_frame 		= round(offset(trial)*FMCfreq); 		% movement offset 
Fonset_frame 		= round(Fonset(trial)* FMCfreq);		% force onset
Foffset_frame 		= round(Foffset(trial)*FMCfreq);		% force offset 
[Fp_max, Fp_frame] 	= max(Fp);				% frame&mag: max pull force
delta_t			= FMCtime(2)-FMCtime(1);  		% sample period
% __ Check for the end of a trial based on PATTON's criterion.__
vf_critierion=0;	off=offset_frame;			% store origianl offset fr.
for q=onset_frame+1:offset_frame,
  %fprintf('.');
  if Fp(q)>.5*max(Fp) & Dphi(q,1)<.1*min(Dphi(:,1)), vf_critierion=1; end %if
  if Dphi(q,1) > 0 & vf_critierion,  
    offset_frame=q;
    fprintf('\nre-adjust "end" based on PATTONs criterion to frame %d from %d\n',q, off);
    break;
  end % if 
end 	% for q
% __ change event marks if conflict __
fi=onset_frame; fb=Fonset_frame; fpk=Fp_frame; fe=Foffset_frame; ff=offset_frame;
if fi>=fb, 	fb=fi+1; 	end;				% fix event mark if conflict
if fb>=fpk, 	fpk=fb+1; 	end; 				% fix event mark if conflict 
if fpk>=fe, 	fe=fpk+1; 	end; 				% fix event mark if conflict 
if fe>=ff, 	fe=ff-1; 	end; 				% fix event mark if conflict 
if fpk>=fe, 	fpk=fe-1; 	end; 				% fix event mark if conflict 
ti=FMCtime(fi); tb=FMCtime(fb); tpk=FMCtime(fpk); te=FMCtime(fe); tf=FMCtime(ff);
FMCtf = offset(trial)-onset(trial);

% _____ ANKLE KINETICS FROM FORCEPLATE (ASSUMES STATIC FOOT)_______
COP		= (lf-a)-d;			% COP measured from toe (non-normalized)
Fx	 	= Fgx;				% x force at ankle
Fy 		= Fgy - mf;			% y force at ankle
T 		= -(b.*Fgx - d.*Fgy);		% Torque  at ankle

% _____RENAME TIME VARIABLES;  CLEAR OLD _____
%time 		= FMCtime;
freq 		= FMCfreq;
%clear 		FMCtime;
%clear 		FMCfreq;
clear 		EEEtime;
%clear 		EEEfreq;
clear 		angle;
clear 		j_angle;

% _____ TEXT VARIABLE THAT DESCRIBES THE TRIAL _______
description = ['Subject ' upper(id) ', day ' num2str(day) 			...
		' block ' num2str(block) ' trial ' num2str(trial) 		...
		' (Fp_target=' num2str(pull_targ)	' Fp_max=' num2str(Fp_max) ')'];

% ___ PLOT SEGMENT ANGLES AND FP___
clg;	plot(phi*180/pi,'linewidth', 5);	title('segment angles');
legend('leg', 'thigh', 'pelvis', 'HAT', 'humerous', 'arm');
hold on; plot(Fp); text(fpk,Fp(fpk), ' Pulling Force');
xlabel('frame number');  title(description); drawnow;

fprintf('done.   \n *** ~ END f_and_m5.m ~ ***\n'); 

