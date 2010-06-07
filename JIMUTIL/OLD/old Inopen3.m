%______*** MATLAB "M" FUNCTION (Patton, modified from Russo) ***_______
% open an input datio file and get some of the header info.
% to close file: fclose(fileinfo(1))
%  VERSIONS:	6/19/96 by jim patton from Russo's inopen.m 
%  INPUTS: 	fname 	file name string of dataio format binary file
%  OUTPUTS: 	fileinfo=[fid pts Ntypes]; fid: file id 
%		pts	# of data points per data type; Ntypes: # of data types per trial
%		Ntrials	# of trials in the data file	                                                              
%		Hz 	sampling frequency
%		time	time array
%  CALLS: 	
%  CALLED BY:	
%  SYNTAX:	[fileinfo,Ntrials,Hz,time]=inopen3(fname)
%  SEE:   	C:\jim\matlab or C:\jim\matlab\devel
%  INITIATED:	6/19/96 by jim patton from A. Russo's inopen.m
%  VERSIONS:	2/12/97 patton. Renamed to inopen3 due to conflict with 
%		another inopen.m, which had different outputs.  This is
%		more similar to inopen1.m, which I also found.
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [fileinfo,trialcnt,Hz,timearray]=inopen(fname)
fprintf(' ~ inopen3.m (open & get info on a dataio file) ~ ');

% ______ OPEN FILE _______
inputid=fopen(fname,'rb');				% OPEN FILE
if inputid<2,						% IF FILE NOT FOUND
  fprintf('cannot open %s\n',fname);
  break;				
end

% ______ GET INFO FROM HEADER _______
[a,count]=fread(inputid,20,'short');			% READ 20 ELEMENT HEADER INTO a
typecnt=1;						% RESET THE #-OF-TYPES COUNTER 
pts=a(5,1);						% NUMBER OF POINTS IN RECORD
interval=a(9,1)/1000;					% SAMPLING INTERVAL
Hz=1/interval;						% SAMPLING FREQUENCY
sampletime=pts*interval; 				% SAMPLING TIME FOR TRIAL 
timearray=0.0:interval:sampletime;			% MAKE AN ARRAY FOR TIME
timearray=timearray(1:pts)';				% ?FIX?
old=a(3,1);						% TRIAL ID #
s=fseek(inputid,pts*4,0);				% ADVANCE TO END OF DATA RECORD

% ______ EVALUATE # OF DATATYPES PER TRIAL _______
while inputid>1					% ?UNTIL END OF FILE?
  [a,count]=fread(inputid,20,'short');		% READ 20 ELEMENT HEADER INTO a
  if a(3,1)~=old break; end;				% STOP WHEN NEW TRIAL 
  s=fseek(inputid,pts*4, 0);				% ADVANCE TO END OF DATA RECORD 
  typecnt=typecnt+1;					% COUNT # OF DATATYPES PER TRIAL
end %while 						

% ______ COUNT # OF TRIALS _______
frewind(inputid);					% RESET FILE TO BEGINNING
offset=typecnt*(pts*4+40);				% AMOUNT TO JUMP (1 TRIAL'S DATA) 
trialcnt=1;						% RESET THE #-OF-TRIALS COUNTER
while inputid>2					% ?UNTIL END OF FILE?
  s=fseek(inputid,offset,0);				% JUMP 1 TRIAL'S DATA AHEAD
  [a,count]=fread(inputid,20,'short');		% READ 20 ELEMENT HEADER INTO a 
  if a(1,1)==1, break; end; 				% STOP WHEN FIRST # IS 1 (EOF MARK)
  %fprintf('\nnum%d chan%d trial%d class%d',a(1,1),a(2,1),a(3,1),a(4,1)); % DISPLAY
  trialcnt=trialcnt+1;					% COUNT # OF TRIALS
  s=fseek(inputid,-40,0);				% BACK TO START OF HEADER (20 INTEJR) 
end %while 

fileinfo=[inputid pts typecnt];			% CONSTRUCT FILEINFO FOR OUTPUT

fprintf(' ~ END inopen3.m ~ ');

