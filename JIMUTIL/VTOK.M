% function [okay]=vtok(subj, block, trial);
% tests whether a trial from the vision experiment has good data
% V-ision T-rial O K
%
% Given subject identity (as a two letter string, e.g. 'kg'), block number and 
% trial number, this function  returns whether the trial can be retrieved and 
% its data are good.
% note1: trials are not filtered to exlcude those which are not classifed as 65% or 35%
% note2: specifically the function f_vt.m was used to determine a trial's validity
% note3: vestibular subjects not yet supported
%       
% EXAMPLE:     trialok=vtok('an',1,3)
% 
% REQUIRES:    vtokdat.zzz (good trial/bad trial record file)
% INPUTS:      subject id, block, trial
% OUTPUTS:     0 if trial is bad for one reason or another; 
%              1 if trial is good; 
%              2 if vtok failed to work properly, or its data file vtokdat.zzz has been corrupted
%
% dyn_v.m 29 May 1996 J.W.Steege
% f_vt.m  27 Jan 1997 D.F. Bedford 
% vtok.m  29 Feb 1997 D.F. Bedford 

function [okay]=vtok(subj,block,trial);

%   ~~~~~~~~~~~~~~begin~~~~~~~~~~~~~~~~~~~

clear vtokdat; 
load vtokdat.zzz;

clear subjectlist;
clear row;
clear i0;
clear thisblock;
clear thistrial
clear result;


subjectlist=['an','bv','cf','er','gi','hw','jm','kg','lz','st'];

% ... calculate row number of required block and trial
row=0;
okay=2; % an error trap value tested for later
for i0=1:2:length(subjectlist)      % loop through subjects
 id=subjectlist(i0:i0+1);		% identify the subject for this iteration
 for thisblock=1:12
  for thistrial=1:10

    row=row+1;
    
    % ... test for match of function input parameters
    if ( (id==subj)&(block==thisblock)&(trial==thistrial) )

		% ... begin checking that we have the right entry in vtokdat.zzz
		if(i0~=vtokdat(row,1))
		 fprintf('mismatch of subject id in vtokdat.zzz; exiting.\n');
		 okay=2;
		 return;
		end % if i0...

		if(block~=vtokdat(row,2))
		 fprintf('mismatch of block number in vtokdat.zzz; exiting.\n');
		 okay=2;
		 return;
		end % if block...
		
		if(trial~=vtokdat(row,3))
		 fprintf('mismatch of trial number in vtokdat.zzz; exiting.\n');
		 okay=2;
		 return;
		end % if trial...	

		% ... as far as is possible we have now checked that the entry in vtokdat is correct
		
		% ... IS THE TRIAL OKAY?
		okay=vtokdat(row,4);

    end % if id==subj...

  end     % looping through trials
 end     % looping through blocks
end     % looping through subjects

if okay==0
 fprintf('warning: vtok has detected a bad trial... returning zero.\n');
 return;
end % if

if okay==2
 fprintf('warning: vtok has failed to operate properly: INVESTIGATE IMMEDIATELY.\n');
 fprintf('Note: shareware version does not support vestibular subjects\n');	
 return;
end % if

return;


%   ~~~~~~~~~~~~~~~~ the end ~~~~~~~~~~~~~~~~~~~

