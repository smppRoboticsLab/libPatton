% ***** MATLAB M FUNCTION DIOMESH.M (Aaron Markworth)******
% M-file program to extract a specified datatype(s) from a dio file(s) and output it to a new designated dio file.
% SYNTAX: diomesh(filenames,dtvectors,outname);
% INPUTS:	filenames	filename string list with extensions inputed before
%								running diomesh...
%								example: filenames=str2mat('name1.xxx','name2.xxx','name3.xxx')
%			  	dtvectors	desired datatype vectors corresponding respectively to
%								filenames string list. MUST BE IN CELL ARRAY FORMAT!
%								example: {[name1 types],[name2 types],[name3 types]}
%				outname		name of output file.  example: 'mesh.dat'	
% OUTPUTS: 'outname'		dio file of combined data
% CALLS:			dio2mat.m
%					dio_rec.m
%					mat2dio.m
% CALLED BY:	 
% REVISIONS: 	5/13/98 Aaron Markworth
% NOTES:			ONLY WORKS IN MATLAB 5.2!  USES CELL ARRAY FORMAT FOR
%					INPUT OF DATATYPES AND TRIALS CORRESPONDING TO INPUT FILES.  
%					CAN USE ANY NUMBER OF INPUT FILES AND ANY NUMBER OF DATATYPES
%
%					* Code is best viewed in MS word, courier new 8pt font
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function status=diomesh(filenames,dtvectors,outname);

%_____ SETUP VARS _____
H=[]; D=[];																% initialize matrices
h=[]; d=[];																% initialize matrices
hd=[]; dd=[];															% initialize matrices
hout=[]; dout=[];														% initialize matrices
[numrows,numcols]=size(filenames);								% size of filename string vector
numfiles=numrows;														% get number of input files
fprintf('\n ~ DIOMESH.M ~ \n DIOMESH PROCESSING:')			% orient user
filenames																% list filenames
status=0;																% START WITH OK STATUS
sep='\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';					% separator string

%_____ BEGIN DATATYPE LOOP FOR EACH FILE IN FILENAMES _____ 
	for file=1:numfiles												% file=1 to total # of input files
      filename=filenames(file,:);								% get filename
      fprintf('\n PROCESSING file "%s": \n',filename); 	% MESSAGE
      [H,D,numtr]=dio2mat(deblank(filename));	    		% read in file header and data
      if file>1,
         if numtr~=last_numtr
            error(' !inconsistent # trials! ')
         end
      end
      last_numtr=numtr;
      
		%_____ EXTRACT SPECIFIC DATATYPE _____             
      dtvec=dtvectors{file};										% get dtype vec from cell array
      numdt=length(dtvec);											% number of datatypes
			for dt=1:numdt 											% datatype=1 to total # of datatypes
         	datatype=dtvec(1,dt);							 	% set datatype
     			[d,h,col]=dio_rec(D,H,2,datatype); 				% dio_rec to extract dataypes   
           	hd=[hd h];									 			% append ouput header
            dd=[dd d];												% append ouput data (cop) 
         end
	end
   
%_____ REORGANIZE OUTPUT MATRIX BY TRIALS _____ 
[numtrow,numtcol]=size(hd);										% get number of columns
for trial=1:numtr														% loop for each trial
  for col=1:numtcol													% loop for each column
    if hd(3,col)==trial,   										%
      hout=[hout hd(:,col)];						   			% put data dtypes together by trials 
   	dout=[dout dd(:,col)];				   					% put data dtypes together by trials
	 end																	% end
  end																		% end 
end																		% end 

%__  WRITE DATAIO OUTPUT FILE __
fprintf(' writing to file..');									% message
mat2dio(outname,hout,dout); 										% write file
	
fprintf('\nOUTPUT FILE: %s',outname); 							% display output file name

fprintf(' ~ END DIOMESH.M ~ \n ');								% message


