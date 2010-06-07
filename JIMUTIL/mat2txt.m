% ***************** MATLAB M function ***************
% Write an ASCII text file with header and data matrices, readable by HDRLOAD.M
% OUTPUT DATA IS TAB-DELIMITED FOR EASY VIEWING IN SPREADSHEET PROGRAM (EXCEL).
% It will also facilitate reading and appending to an existing file that is
% in this type of format.
% SYNTAX:	status=mat2txt(filename,H,D,append2file,keepH,delimiter)
% INPUTS	 filename	files's name 
%         H		               the "header" (text). A word of advice:
%                             make the last line of this be 
%         D		               the "body" (M values by N records)
%         append2file		         (optional) if present and nonzero, then open 
%                             the file , read it in, and append data to it. 
%         keepH               (optional - use with append2file if you want) If present
%                             &nonzero, keep_Header makes it so the OLD header
%                             (found in "filename") is placed back in the 
%                             output file. The newly inputted header (H) is
%                             thrown out, so it can be a dummy variable. 
%         delimiter           ascii code for delimiter. if not given, 9 (tab) is used
% OUTPUTS filename	         file in text data format
%         status		         nonzero if errors
% CALLS:	indiorec.m	read a dio record
% REVISIONS: 	6/5/97 by Patton. Initiated from batch1.m
%             2-26-99 Patton: allowed for null header (H)
%             9/20/99 patton: allowed for optional delimiter other than tab
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=mat2txt(filename,H,D,append2file,keepH,delimiter)

%____ SETUP ____
global DEBUGIT					                       % nonzero for verbose
if DEBUGIT, fprintf('\n ~ MAT2TXT.M ~ '); end;	% message
[Drows,Dcols]=size(D);                          % get dimensions
%[Hrows,Hcols]=size(H);                         % get dimensions
if ~exist('append2file'), append2file=0; end    % set to default if not inputted
if ~exist('keepH'), keepH=0; end                % set to default if not inputted
if ~exist('delimiter'), delimiter=9; end        % set to default if not inputted
if append2file~=0 & ~exist(filename)
  wrn_msg=['!cannot find file "' filename   ... %
   '" for append! (writing new one)...'];       %
  warning(wrn_msg)
end   

%___ IF APPENDING, LOAD PREVIOUS FILE & APPEND __
if append2file&exist(filename),                 % if appending & file exists
  fprintf(' (appending to %s) ',filename)       % message
  [h,d]=hdrload(filename);                      % load previous file
  [drows,dcols]=size(d);                        % get dimensions
  D=[d; D]; Drows=Drows+drows;                  % setup appended output mtx
  if keepH, H=h; end;                           % keep previous header
end %if append2file

%____ OPEN FILE FOR WRITING ____
fid=fopen(filename,'w');			                % open file for write
if fid==-1,   
  status=1;	
  warning(['Cannot open "' filename '" for writing. '])
  return
else 
  status=0; 
end %if	% status=1 if cant open

%____ WRITE HEADER ____
if DEBUGIT, fprintf(' writing to file..'); end	% message
if ~isempty(H), 
  for i=1:length(H(:,1))					            % each row of header
    fprintf(fid,'%s\n',deblank(H(i,:)));		  % write header text
  end %for i 					                        %
else
  warning(' NUL Header -- data only.')
end

%____ WRITE DATA ____
for i=1:Drows                                   % loop for rows
  for j=1:Dcols                                 % loop for cols
    fprintf(fid,'%g',D(i,j));                   % write data
    if j~=Dcols, 
      fprintf(fid,setstr(delimiter));           % write column delimiter char
    end;        
  end %for i% 
  %if i~=Drows, fprintf(fid,'\r'); end;		       % new line 
  %if i~=Drows, fprintf(fid,'\n'); end;		   % new line 
  if i~=Drows, fprintf(fid,'\r\n'); end;		   % new line 
end %for i 						% 

%____ CLOSE FILE ____
fclose(fid);                                    % close output file
if DEBUGIT, fprintf(' ~ END MAT2TXT.M ~ '); end;% message

