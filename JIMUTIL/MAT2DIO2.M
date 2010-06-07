% ***************** MATLAB M function ***************
% Write an entire DIO file from header and data matrices.
% SYNTAX:	status=mat2dio2(filename,H,D)
% INPUTS	filename	files's name 
%		    H		the "header" (20 integers by N records)
%		    D		the "body" (M values by N records)
% OUTPUTS 	filename	file in DIO (dataio) format
%		    status		nonzero if errors
% CALLS:	indiorec.m	read a dio record
% REVISIONS: 	6/5/97 by Patton. Initiated from batch1.m
%               10/8/2001 Mille, added the substitution of NaN with -9999
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=mat2dio2(filename,H,D)

% Replace NaN if there is by -9999 (Added by Marie-Laure Mille)
D(isnan(D)==1)=-9999;

global DEBUGIT						% nonzero for verbose
if DEBUGIT, fprintf('\n ~ MAT2DIO.M ~ '); end;	% message
endrec=[1; 8564]; 					% EOF INDICATOR (DATAIO)

fid=fopen(filename,'w');				% open file for write
if fid==-1, status=1;	else status=0; end %if		% status=1 if cant open

if DEBUGIT, fprintf(' writing to file..'); end	% message
for i=1:length(H(1,:))
  count=fwrite(fid,H(:,i),'short');			% write header
  count=fwrite(fid,D(:,i),'float');			% write data
end %for i 						%

count=fwrite(fid,endrec,'short');			% write EOF indicatior
fclose(fid);

if DEBUGIT, fprintf(' ~ END MAT2DIO.M ~ '); end; 	% message

