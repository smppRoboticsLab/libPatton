% ************** MATLAB "M" file  (jim Patton) *************
% The following manages the batch processing of multiple subjects, 
% blocks, and trials of regression analysis for learn2a processing
% This is the root program to run.
%
% 	INPUTS:		ROOTNAME 	string (<6chars) for programs. in memory
%			SAVEDIR		string of directroy to save to. in memory 
% 	OUTPUTS:	see subprograms below:
%	CALLS:		ROOTNAMEset.m	Mfile wherre ROOTNAME is string in memory
%			ROOTNAMEbdy.m 	Mfile wherre ROOTNAME is string in memory
%			ROOTNAMEend.m 	Mfile wherre ROOTNAME is string in memory 
%			fileid.m	Mfile
%			inopen.m	Mfile
%			getinfo2.m	Mfile
%			subjdata.m 	Mfile
%
% REVISIONS: 8/9/95 jim patton initiatied from 'non_opt9.m'
%            7/15/98 patton replaced menu2 with menu (better in matlab5)
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

disp('*** ENGIN.m (for learn2a) ***');

%__________________________ SET VARIABLES: ________________________
g 	= 9.8;							% gravity
day	=[];							% set to nil
protocol='practice';
base_dir=cd;
if strcmp(base_dir(length(base_dir)),'\'), base_dir(length(base_dir))=[]; end; % if
save c:\jim\matlab\base_dir base_dir 
days=[1 5];		all_IDs=['AS';'CK';'EV';'GH';'HI';'KM';'MF';'PM';'RP';'YW']; 
load('chirp'); 	y=y(1:round(length(y)/8));  

% __________________________get start info__________________________
IDs=getids(ROOTNAME) 		% get the subject names for processing

if ~exist('resume_switch') resume_switch=0; sound(y,Fs); sound(y,Fs); sound(y,Fs); end %if
if resume_switch,
  middle_start = 1;
  for check=1:length(IDs(:,1)), 	% sort out the IDs number for start
    if strcmp(IDs(check,:),all_IDs(best(5),:)), subj_start=check; end; 
  end;
  if best(6) > 1, day_start=2; else day_start=1; end; %if
  block_start	= best(7);
  trial_start	= best(8);
  subj_end	= length(IDs);
  day_end	= days(2);
  middle_end 	= 0;	
else
  if menu('Choose:','Start at beginning','Start in the middle (partially done)')-1;
    middle_start= 1;
    subj_start	= menu('Select start SUBJECT:','1','2','3','4','5','6','7','8','9','10');
    day_start	= menu('Select a starting DAY:', '1', num2str(days(2)));
    block_start= menu('Select starting BLOCK:','1','2','3','4','5','6','7','8','9');
    trial_start= menu('Select starting TRIAL:','1','2','3','4','5','6','7','more');
      if trial_start>7, 
      	trial_start=menu('Select starting TRIAL',	...
		 '8','9','10','11','12','13','14','more')+7;
	if trial_start>14
 	  trial_start=menu('Select starting TRIAL',		...
			'15','16','17','18','19','20','21')+14;
    	end; % if trial_start>14
      end; % if trial_start>7
  else middle_start=0;subj_start=1;day_start=1;block_start=1;trial_start=1; end 
end % if resume_switch

eval([ROOTNAME 'set']); % <=============== run the set program ================

%___________________________________________________________________________
% ------- BEGIN NESTED LOOPS FOR SUBJECT, DAY, BLOCK, AND TRIAL: -----------
%___________________________________________________________________________
disp('*** Begin processing:');
for SUBJ = subj_start:length(IDs)
  id=IDs(SUBJ,:); 
  fprintf(['\n~~~~~~  N E W   S U B J E C T: %s  ~~~~~~\n', id]); 
  sound(y,Fs*8);sound(y,Fs*8);sound(y,Fs*8);	sound(y,Fs*8); 

  % _______ sort out the subject number for learn2a ________ 
  for check=1:length(all_IDs), 
    if strcmp(id,all_IDs(check,:)), sub_num=check; end; %if 
  end; %

  % __ get paramter file for subject (c:\jim\lee\learn_2\) ___
  paramfilename=[ base_dir '\' id '.prm'];
  [dummy,subj_param]=hdrload(paramfilename);

  % ____________ loop for each DAY ____________ 
  for day = days(day_start):4:5,
    fprintf('____ NEW DAY: %d ____\n',day); 
    eval(['cd ' base_dir '\' id num2str(day)]); 
    if day==1,Nblocks=12; sk=1; else Nblocks=7; sk=1; end %if
    if sub_num==3&day==1&block_start<2,
      block_start=2; disp('~skip EV block 1~'); 
    end; %if
    sound(y,Fs*6); sound(y,Fs*6); sound(y,Fs*6); 

    % ____________ loop for each BLOCK ____________ 
    for block = block_start:sk:Nblocks
      if sub_num==3 & day==5 & block==3,
         disp('~skip block 3~'); block=4; 
      end; %if
      fprintf('\n ___ NEW BLOCK (FILE): #%d: ____ \n',block);
      sound(y,Fs*4); sound(y,Fs*4); 

      %____________ load BLOCK info ________________
      FMCname=fileid(id,day,block,'.fmc');
      [FMCinfo,Ntrials,FMCfreq,FMCtime]=inopen3(FMCname); 	
      fclose(FMCinfo(1));
      [onset offset Fonset Foffset H mass]=		...
        getinfo2(id,day,block,Ntrials); 

      %_____________ loop for each TRIAL _______________
      for trial = trial_start:1:Ntrials
        fprintf('\n _ _ _ _ _ NEW TRIAL FOLLOWS: #%d _ _ _ _ \n',trial);
        eval([ROOTNAME 'bdy']); % <======= run the bdy program ================
      end % for trial
      trial_start = 1;
    end	 % for block 
    block_start = 1;
  end % day
  day_start = 1;
end % for SUBJ
disp(['*** DONE processing ' name ' ***']); 
fclose('all'); load chirp; sound(y,Fs*3);

eval([ROOTNAME 'end']); % <======= run the end program ================ 

fclose('all'); sound(y,Fs*3); when=clock;
disp(['*** ENGIN.m DONE processing ' name ...
  ' at %s ' whenis(when) ' ***']); 


