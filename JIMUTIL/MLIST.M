% ***************** MATLAB M FUNCTION MLIST.M (A. Markworth)***************
% create table of contents of a directory's mfiles 
%
% **** must be run with directory to be cataloged (cd=current directory or pwd=present working directory)
%
% SYNTAX:		mlist
% INPUTS:		none		
% OUTPUTS 		text file table of contents
% CALLS:			hdrload
% REVISIONS: 	8/19/98 by Markworth. Initiated from dio2mat.m
% NOTES:			* Code is best viewed in MS word, courier new 8pt font
%					* For information on DATAIO (DIO) FORMAT, see datio.doc
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=mlist

%_____ SETUP VARS _____
!del contents.m																	
status=0;																			% initial status is good
prog_name='MLIST.M';																% this program's name
fprintf('\n ~ %s ~ \n PROCESSING:',prog_name)							% orient user
mdir=pwd;																			% mfile directory is pwd																
stringout=['%' mdir ' as of ' whenis(clock)];								% initialize output string with mdir 
sep='\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n'; fprintf(sep)    			% separator string

%_____ LOOP FOR MFILES _____
filelist=what(pwd);																% get filelist from pwd
mfilelist=filelist.m																% cur filelist down to only list of mfiles
[rows,cols]=size(mfilelist);													% get number of mfiles as rows
fid=fopen('contents.m','a');
fprintf(fid,'%s\n',stringout);
fclose(fid);
for mfilenum=1:rows
   matmfile=str2mat(mfilelist(mfilenum,1))								% define current mfile name in mat form
   [h,d]=hdrload(matmfile);													% load current mfile		
   strmfile=mat2str(matmfile);												% convert name of mfile to string
   brief=h(2,:);																	% define brief as line 2 of the curretn mfile
   strbrief=mat2str(brief);													% convert brief to string 
   outline=['%' strmfile '   ' strbrief];									% assemble output line for current mfile
   fid=fopen('contents.m','a');
   fprintf(fid,'%s\n',outline);
   fclose(fid);
end																					% END for block                                                                       

