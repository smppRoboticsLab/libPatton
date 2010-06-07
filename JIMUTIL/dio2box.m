% ***************** MATLAB M function ***************
% read an entire DIO file into header and data matrices. 
% SYNTAX : [H,D,Ntrials,Nrecs]=dio2box(filename,noverbose);
% INPUTS : - filename : files's name 
%          - noverbose (optional): nonzero if no messages
% OUTPUTS: - H : the "header" (20 integers by N records)
%            H=-1 if it cant open the file
%          - D : the "body" (M values by N records by P trials)
%            D=[] if it cant open the file 
%          - Ntrials : # of trials in DIO file
%          - Nrecs : # records per trial. This should be 
%            consistent across trials.  If it is not,
%            Nrecs is the maximum.
% CALLS:	indiorec.m	read a dio record
% REVISIONS: 6/5/97 by Patton. Initiated from batch1.m
%            9/15/97 (by Patton) revised to accomodate fragmented dio files
%            7/19/01 (by ML Mille) revised to deal with the missing values (converts
%                      -9999's into Nan's) in DIO files & to obtain a 3D output matrix.
%            4-1-2002 renamed from dio2mat2.m   to   dio2box.m
% NOTES: * For information on DATAIO (DIO) FORMAT, see datio.doc
%
% for a quick fiew of data, try the following:
% [h,d,Ntrials,Nrecs]=dio2box(filename);
% for trial=1:Ntrials, 
%   figure(trial); 
%   plot(d(:,:,trial)); 
% end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [H,D,Ntrials,Nrecs]=dio2box(filename,noverbose)

%_____ SETUP VARS _____
global DEBUGIT						% nonzero for verbose
if ~exist('noverbose') noverbose=0; end		% if not inputted
if ~noverbose, fprintf(' ~ DIO2box.M ~ '); end	% message
endrec=[1; 8564]; 					% EOF INDICATOR (DATAIO)
endrec2=[1 0 8564 0]; 					% opt. EOF INDICATOR(FMC)
H=[];	D=[];						% initialize

%_____ OEPN FILE _____
fid=fopen(filename,'r');				% open file for read
if fid==-1, H=-1; D=[];				% if cant open, return
  if ~noverbose,					% if messages wanted
    fprintf(' ?  %s not found.\n',filename);		% message
  end 							%
  return;						% stop
end 

%_____ SCAN FILE _____
if ~noverbose,fprintf(' scan %s..',filename);end	% message
pause(.05);						% wait 50 msec to update 
count=0;						% init record counter
while (1)						% loop for loading records
  [h,d]=indiorec(fid); 				% read a record
  if h(1)==endrec(1)&h(2)==endrec(2),break; end;	% EOF detect
  if h(1)==endrec2(1)&h(3)==endrec2(3),break; end;	% optional EOF detect
  if h(1)<19, 						% misc problem
    fprintf('corrupt format. Reading up to error..')	% message
    break; 						%
  end;	
  count=count+1;					% increment recrod counter
  dleng=length(d);            % patch for matlab 5 (d will be empty on final pass)
end 							% End while
if ~noverbose,fprintf('found %d records.',count);end	% message

%_____ DIMENSION OUTPUT VARIABLES _____
H=NaN*ones(20,count);					% header dimen 20 by count
D=NaN*ones(dleng,count);				% header dimen N by count 

%_____ rewind FILE _____
frewind(fid);						% set pointer to file begin

%_____ READ FILE _____
if ~noverbose,fprintf(' Reading %s..',filename);end	% message
pause(.05);						% wait 5 msec to update 
for i=1:count
  [h,d]=indiorec(fid); 				% read a record
  H(:,i)=h;						% append record's header
  D(:,i)=d;						% append record's data
end 							% End while

%_____ CLOSE FILE _____
fclose(fid);

%_____ ANALYSIS OF FILE _____
Ntrials=max(H(3,:));					% number of trials
N=length(H(1,:));					% total # columns
trialchange=[1 find(diff(H(3,:)))+1];			% cols where trials start
trialrecords=diff([trialchange N+1]);			% # records per trial
Nrecs=max(trialrecords);				% # records (assumed max)
if ~noverbose 						% if no messages
  for trial=1:Ntrials 
    fprintf('\ntrial %d has %d records.',	...	% message
		trial,trialrecords(trial));	
  end 							% end for trial
end 							% end if ~noverbose

if ~noverbose, fprintf(' ~ END DIO2MAT.M ~ '); end	% message
if DEBUGIT, fprintf('\n'); end; 			% message

% Replace -9999 if there is by NaN (Added by Dr. Marie-Laure Mille)
D(D==-9999)=NaN;

% Reorganized the output matrix as a 3D matrix (Added by Dr. Marie-Laure Mille)
% D=(Nsample,Nrecs,Ntrial) H=(Nsample,Nrecs,Ntrial)
D=reshape(D,size(D,1),Nrecs,Ntrials);
H=reshape(H,size(H,1),Nrecs,Ntrials);

