% ************** MATLAB "M" file  (jim Patton) *************
% The following manages the batch processing of multiple subjects, 
% blocks, and trials of for VISION processing. This is the root program to run.
% 	INPUTS:		ROOTNAME 	string (<6chars) for programs. In memory
%			SAVEDIR		string of directroy to save to. In memory 
% 	OUTPUTS:	see subprograms below:
%	CALLS:		ROOTNAMEset.m	Mfile wherre ROOTNAME is string in memory
%			ROOTNAMEbdy.m 	Mfile wherre ROOTNAME is string in memory
%			ROOTNAMEend.m 	Mfile wherre ROOTNAME is string in memory 
%			fileid.m	Mfile
%			inopen.m	Mfile
%			getinfo2.m	Mfile
%			subjdata.m 	Mfile
% initiatied 1/27/97 jim patton from 'engin.m'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

disp('*** ENGIN_v.m (for vision protocol) ***');

%__________________________ SET VARIABLES: ________________________
g=9.8;								% gravity
Nblocks	=12;							% #blocks for vision
day	= 0;							% no days; set to 0
protocol='vision';						% protocol name
%load c:\jim\lee\vision\params;      				% load subj param
base_dir=cd;							% record CWD 
if strcmp(base_dir(length(base_dir)),'\'), 			% if CWD=root
   base_dir(length(base_dir))=[]; 				% remove last char
end; % if							%
save c:\jim\matlab\base_dir base_dir 				% save in file
days=[1 5];							% learn_2 artifact
%all_IDs=[	 'AN';'BV';'CF'		... 		% list all SUBJ
%		;'GI';'HW';'JM'		... 		%  list all SUBJ
%		;'KG';'LZ';'ST'		... 		%   list all SUBJ
%		;'DQ';'YU';'MM'	]			%    last 3 are BVD
all_IDs=['AN';'BV';'CF';'GI';'HW';'JM';'KG';'LZ';'ST'];	% list all SUBJ
								% ER not used?!?
load('chirp'); y=y(1:round(length(y)/8));  			% load & fix sound
IDs=getids(ROOTNAME) 						% subject names 

% _______________GET START INFO_______________
if ~exist('resume_switch'),
  resume_switch=0; sound(y,Fs); sound(y,Fs); sound(y,Fs); 
end %if
if resume_switch,
  middle_start = 1;
  for check=1:length(IDs(:,1)), 				% get ID# for start
    if strcmp(IDs(check,:),all_IDs(best(5),:)), 
      subj_start=check; 
    end;  %if
  end; %for check
  if best(6) > 1, day_start=2; else day_start=1; end; %if
  block_start	= best(7);
  trial_start	= best(8);
  subj_end	= length(IDs);
  day_end	= days(2);
  middle_end 	= 0;	
else
  if menu2('Choose:','Start at beginning', 	...
           'Start in the middle (partially done)')-1;
    middle_start= 1;
    subj_start=menu2('Select start SUBJECT:',	...
      '1','2','3','4','5','6','7','8','9','10');
    block_start= menu2('Select starting BLOCK:', 	...
      '1','2','3','4','5','6','7','8','9');
    trial_start= menu2('Select starting TRIAL:', 	...
      '1','2','3','4','5','6','7','more');
      if trial_start>7, 
      	trial_start=menu2('Select starting TRIAL',	...
         '8','9','10','11','12','13','14','more')+7;
	if trial_start>14
 	  trial_start=menu2('Select starting TRIAL',	...
           '15','16','17','18','19','20','21')+14;
    	end; % if trial_start>14
      end; % if trial_start>7
  else 
    middle_start=0;
    subj_start=1;
    day_start=1; 
    block_start=1; 
    trial_start=1; 
  end %if menu2
end % if resume_switch

eval([ROOTNAME 'set']); 		% <=============== RUN THE SET PROGRAM 

%_______________________________________________________________________________
% -------- BEGIN NESTED LOOPS FOR SUBJECT, DAY, BLOCK, AND TRIAL: --------------
%_______________________________________________________________________________
disp('*** Begin processing:');
for SUBJ=subj_start:length(IDs)
  id=IDs(SUBJ,:); 
  fprintf(['\n~~~  N E W   S U B J E C T: %s  ~~~\n',id]); 
  eval(['cd ' base_dir '\' id]); 
  sound(y,Fs*8);	sound(y,Fs*8); 	sound(y,Fs*8); 	sound(y,Fs*8); 

  % ______ SORT OUT THE SUBJECT NUMBER FOR VISION ______ 
  for check=1:length(all_IDs), 				%
   if strcmp(id,all_IDs(check,:)), sub_num=check; end; %if	%
  end; % for check						%

  % _____GET THIS SUBJECT's PARAMTER FILE  ________
  eval(['load ' base_dir '\' id '.prm']);  			%
  eval(['subj_param =' id '; clear ' id]);			%

  % ____________ LOOP FOR EACH BLOCK ____________ 
  for block=block_start:Nblocks				%
    if id=='AN'&block==1, 					%
      fprintf('Skip AN block1');				%
    else							%
      fprintf('\n ___ BLOCK #%d: FOLLOWS: __ \n', block);	%
      sound(y,Fs*4); sound(y,Fs*4); 				%

      %_____________ LOAD BLOCK INFO ____________
      if day==0, FMCname=fileid3(lower(id),block,'.fmc');  	% file info vision
      else,  	FMCname=fileid(id,day,block,'.fmc'); 		% file info learn_2
      end;
      [FMCinfo,Ntrials,FMCfreq,FMCtime]=inopen3(FMCname); 	%
      fclose(FMCinfo(1));					%
      [onset offset Fonset Foffset H mass]= 	...
        getinfo2(lower(id),day,block,Ntrials); 

      %____________ LOOP FOR EACH TRIAL ______________
      for trial=trial_start:1:Ntrials
        fprintf('\n __ TRIAL #%d FOLLOWS: __ \n', trial);	%
        eval([ROOTNAME 'bdy']); 				% ** RUN BDY PROGRAM 
      end %for trial
      trial_start=1;
    end; %if id==...
  end %for block 
  block_start=1;
end %for SUBJ

eval([ROOTNAME 'end']); 					% ** RUN END PROGRAM 

fclose('all'); sound(y,Fs*3); when=clock;
disp(['*** ENGIN_v.m DONE processing ' name ...
  ' at %s ' whenis(when) ' ***']); 

