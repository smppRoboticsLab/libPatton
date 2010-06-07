% ***************** MATLAB M function ***************
% Write an entire DIO file from header and data matrices.
% SYNTAX:	status=mat2dio(filename,H,D)
% INPUTS	filename	files's name 
%		H		the "header" (20 integers by N records)
%		D		the "body" (M values by N records)
% OUTPUTS 	filename	file in DIO (dataio) format
%		status		nonzero if errors
% CALLS:	indiorec.m	read a dio record
% REVISIONS: 	6/5/97 by Patton. Initiated from batch1.m
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=mat2dio(filename,H,D)

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

