%function [a,b,c,d,e,f,g] = inopen(fname)
%A=inopen(fname) open an input datio file and get some info.

function [inputid,timearray,Hz,pts,typecnt,trialcnt,typearray]=inopen(fname)
global inputid pts typecnt
	                                                              
	inputid=fopen(fname,'rb');
	if inputid < 2
		fprintf('cannot open ')
		disp(fname)
		break;
	end
	realflag = 0;
	[a,count] = fread(inputid,20,'short');
	
	if a(11,1) == 0
		realflag = 1;
	end
	typecnt = 1;
	endflag = 1;
	pts = a(5,1);
	interval = a(9,1)/1000;
	Hz = 1 / interval;	
	sampletime = pts*interval;
	timearray = 0.0:interval:sampletime;
	timearray = timearray(1,1:pts);
	old = a(3,1);
	typearray = a(2,1);
	if realflag == 1
		s= fseek(inputid, pts*2,0);
	else
		s= fseek(inputid, pts*4,0);
	end
	while inputid > 1
		[a,count] = fread(inputid,20,'short');
		if a(1,1) == 1
			endflag = 0;
			break;
		end
		if  a(3,1) ~= old
			break;
		end
		typearray = [typearray a(2,1)];
		if realflag == 1
			s = fseek(inputid, pts*2,0);
		else
			s = fseek(inputid, pts*4,0);
		end
		typecnt = typecnt + 1;
	end
	frewind(inputid);
	trialcnt = 1;
	if endflag == 1
		if realflag == 1
			offset = typecnt*(pts*2+40);
		else
			offset = typecnt*(pts*4+40);
		end
		while inputid > 2
			s = fseek(inputid,offset,0);
			[a,count] = fread(inputid,20,'short');
			if a(1,1) == 1
				frewind(inputid);
				break;
			end
			trialcnt = trialcnt + 1;
			s= fseek(inputid,-40,0);
		end
	end

	