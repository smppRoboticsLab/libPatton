%seeddd
% cycles through a datio file allowing you to locate "BAD" data
%
% cycles through a datio file, printing the first header (and first couple data pts) of each new trial to the screen, allowing you to locate "BAD" data
%The program can be edited to print the first header of each data type, to better pinpoint problems
%Must specify file name and number of data points, data types, and trials
%
%9 July 1996  J.W.Steege

%Input the pertinent information***************************************************
pathfname=input('File name (w/path and extension):  ','s'); 
pts=input('Number of data pts:   ');
types=input('Number of data types:   ');
numtrials=input('Number of trials:   ');
%****************************************************************************

%Read in datio file**************************************************************
[inputid,message]=fopen(pathfname,'rb');
if inputid<2
	fprintf('cannot open ');
	disp(fname)
	break;
end	
fid=inputid;
%***************************************************************************

%Set pointer to beginning of file
frewind(fid);

for i0=1:numtrials						%LOOP THRU TRIALS

	for i1=1:types						%LOOP THRU DATA TYPES
		[a,count]=fread(fid,20,'short'); 	%Read in the header 
		[b,count]=fread(fid,pts,'float'); 	%Read in the data

		if i1==1			%If it is the first datatype
			a		%Print the header to screen
			b(1:5)		%Print beginning of data to screen
			pause;
		end

	end	%for i1/types

	if i0==numtrials 			%If this is the last trial, see if the end of trial is indicated
		[c,count]=fread(fid,2,'short');	%Last two numbers should be ?????
		c
	end
end	%for i0/trials

fclose('all');




