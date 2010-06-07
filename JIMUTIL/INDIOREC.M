% ***************** MATLAB M function ***************
% read a single record of a DIO file.
% SYNTAX:	[H,D]= indiorec(fid);
% INPUTS	fid	fileid (file must be must be previously opened) 
% OUTPUTS 	H	the records "header" (20 integers)
%		D	the records "body" 
% REVISIONS: 	6/5/97 by Patton. Initiated from batch1.m
%		9/15/97	(patton) revised to detect H(1)<19 & quit
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [H,D]=indiorec(fid)

%_____ SETUP VARS _____
global DEBUGIT						% nonzero for verbose
if DEBUGIT, fprintf('\n ~ indiorec.M ~ '); end;	% message
endrec=[1; 8564]; 					% EOF INDICATOR (DATAIO)
endrec2=[1 0 8564 0]; 					% opt. EOF INDICATOR(FMC)

%_____ READ HEADER _____
if DEBUGIT, fprintf('\nRead Header..'); end;	% message
%count=0;						% initialize
[H,count]=fread(fid,20,'short');			% read header
if DEBUGIT, fprintf('=');fprintf(' %d',H);end	% message
if H(1)==endrec(1) & H(2)==endrec(2), D=[]; return; end;	% EOF detected, exit
if H(1)==endrec2(1) & H(3)==endrec2(3), D=[]; return; end;	% optional EOF, exit
if H(1)<19, fprintf('\nError reading '); D=[]; return; end% misc error

%_____ READ DATA RECORD _____
if DEBUGIT,fprintf('\nReading %d values..',H(5));end	% message
count=0;						% initialize 
[D,count]=fread(fid,H(5),'float');			% read data
%if DEBUGIT, fprintf(' %d',D); end			% message
if DEBUGIT,fprintf(' %d records read.',count); end	% message

%if DEBUGIT, disp('pause'); pause; end; 		% message

if DEBUGIT, fprintf(' ~ END indiorec.M ~ '); end; 	% message
