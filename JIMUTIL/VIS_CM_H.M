% ************** MATLAB "M" file  (jim Patton) *************
% determine CM height while standing for a list of vision subjects. 
% Use baseline of FMC file.
% 	INPUTS:		-
% 	OUTPUTS:	text to command window
%	CALLS:		subjdata
% initiatied1/28/97 jim patton from 'engin_v.m'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

disp('*** vis_cm_h.m (for vision protocol) ***');

%__________________________ SET VARIABLES: ________________________
Nblocks	= 12;							% number of blocks for vision
block=2; 							% preset for this anal
day	= 0;							% no day for this; set to 0
base_dir=cd;							% record where we are
if strcmp(base_dir(length(base_dir)),'\'), 			% fix directoryname if root
   base_dir(length(base_dir))=[]; 				% remove last char
end; % if
save c:\jim\matlab\base_dir base_dir 				% save in file
CMheight=[];
days=[1 5];							% artifact from learn_2
all_IDs=[	'AN';'BV';'CF';	... 			% list all SUBJ
		'GI';'HW';'JM';'KG';	...
		'LZ'; 'ST';'DQ';'YU';'MM'];
IDs=all_IDs;							% use all ids

%____________________________________________________________________________________
% ------------- BEGIN NESTED LOOPS FOR SUBJECT, DAY, BLOCK, AND TRIAL: --------------
disp('*** Begin processing:');
for SUBJ=1:length(IDs)
  CMyAVG=[]; avg_count=0;
  id=IDs(SUBJ,:); fprintf(['\n ~~~~~ N E W   S U B J E C T: %s  ~~~~~\n', id]); 
  eval(['cd ' base_dir '\' id]); 

  % ____________ SORT OUT THE SUBJECT NUMBER FOR VISION ____________ 
  for check=1:length(all_IDs), if strcmp(id,all_IDs(check,:)), sub_num=check; end; end;

  % ____________ LOOP FOR EACH BLOCK ____________ 
  FMCname=fileid3(lower(id),block,'.fmc');  	
  [FMCinfo,Ntrials,FMCfreq,FMCtime]=inopen(FMCname); 
  fclose(FMCinfo(1));
  [onset offset Fonset Foffset H mass]=getinfo2(lower(id),day,block,Ntrials); 

  %____________ LOOP FOR EACH TRIAL ______________
  for trial=1:Ntrials
    %fprintf('\n TRIAL#%d \n', trial);
    [FMCinfo,Ntrials,freq,FMCtime]=inopen(FMCname);
    %fprintf('\nloading: %s(trial %2.0f of %2.0fd)...',FMCname, trial, Ntrials)
    [FMC,FMCheader]=readdio(FMCinfo,trial); fclose(FMCinfo(1));	 fprintf('DONE.\n');
    if FMCheader(10,1)==-9999;
      fprintf('BAD TRIAL: (header file has -9999 in register 10) -- Aborted.\n')
    else
      [onset offset Fonset Foffset H mass]=getinfo2(lower(id),day,block,Ntrials); 
      CMy=FMC(:,11) / 1000;					% center of mass, Vertical
      CMx=FMC(:,10) / 1000;					% center of mass, AP
      clear FMC;						% clear big matrix
      fi=round(onset(trial)*freq); 				%
      plot(	FMCtime,CMx,FMCtime(4:fi),CMx(4:fi),	... 	% plot
		FMCtime,CMy,FMCtime(4:fi),CMy(4:fi)); 	
      title([id ' Trial ' num2str(trial)]);
      drawnow;
      CMyAVG=[CMyAVG; mean(CMy(4:fi))];			% add a value
      fprintf('\n %s Trial#%d %3.3f\n', id , trial, mean(CMy(4:fi)));
    end %if
  end %for trial
  CMheight(SUBJ)=mean(CMyAVG)
end %for SUBJ
disp('*** vis_cm_h.m (for vision protocol) DONE. ***');

