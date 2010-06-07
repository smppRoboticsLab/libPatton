function [fileinfo,trialcnt,Hz,timearray]=inopen1(fname)
% opens an input datio file which contains only one trial and gets some info.
%[fileinfo,Ntrials,Hz,time]=inopen1(fname)
%fileinfo=[fid pts Ntypes]; fid: file id 
%pts: # of data points per data type; Ntypes: # of data types per trial
%Ntrials: # of trials in the data file	                                                              
%Hz: sampling frequency
%time:  time array
%to close file: fclose(fileinfo(1))

	[inputid,message]=fopen(fname,'rb');
	if inputid < 2				%means file cannot be opened
		fprintf('cannot open ')
		disp(fname)
		break;
	end
	%READ IN THE FIRST HEADER, DATATYPE 1, TRIAL 1
	[a,count] = fread(inputid,20,'short');
	%START COUNTING DATA TYPES (GROUPS OF HEADER AND DATA)
	typecnt = 1;
	%READ IN GENERAL INFO FROM THE HEADER
	pts = a(5,1);
	interval = a(9,1)/1000;
	Hz = 1 / interval;	
	sampletime = pts*interval;
	timearray = 0.0:interval:sampletime;
	timearray=timearray(1:pts)';
	%Trial number
	old = a(3,1);
	%Since data pts are 4 bytes/number; advance pointer past data from first datatype of trial 1
	s= fseek(inputid, pts*4,0);
	while inputid > 1
		%Read in header from all the other datatypes in Trial 1
		%Use to get a count of the data types
		[a,count] = fread(inputid,20,'short');
		%Means end of file -- no more data
		if  a(1,1) == 1
			break;
		end
		%If you move to a new trial, break out of the loop
		if  a(3,1) ~= old
			break;
		end
		%After reading in header, advance past the data for that datatype
		s = fseek(inputid, pts*4, 0);
		%Update the count of data types
		typecnt = typecnt + 1;
	end
	%Move pointer to beginning of file
	frewind(inputid);
	%Now offset pointer past first trial's worth of data
	offset = typecnt*(pts*4+40);
	trialcnt = 1;
	%Loop through all the data in each trial at once 
	while inputid>2
		s = fseek(inputid,offset,0);
		%Read in first header of new trial's data
		[a,count] = fread(inputid,20,'short');
		%The end of the file is marked by 1 and 8564
		if a(1,1) == 1
			break;
		end
		%Update count of number of trials
		trialcnt = trialcnt + 1;
		%Return pointer to beginning of trial's data before moving on to next trial
		s= fseek(inputid,-40,0);
	end
	fileinfo=[inputid pts typecnt];
	
