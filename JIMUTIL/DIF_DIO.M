% ***** MATLAB M FUNCTION DIF_DIO.M (Aaron Markworth)******
% M-file program to take first derivative of a datatype from a block of data and output it to a designated dio file.
% SYNTAX: dif_dio('INname','OUTname',INdtype,OUTdtype);
% INPUTS:  INname			input block filename (.scd, .cm, .ang, .gha etc...)
%			  OUTname		output block filename of data (header and data in dio format)
%			  INdtypes		datatype vector to be differentiated
%			  OUTdtypes    datatype vector to replace INdtypes for dif data
% OUTPUTS: 'OUTname'		dio file of differentiated data
% CALLS:   dio2mat.m		read INname
%			  dio_rec.m		extract specific datatype 			
%			  vel.m			differentiate data
% CALLED BY:	 
% REVISIONS: 	5/13/98 Aaron Markworth
% NOTES:		* Code is best viewed in MS word, courier new 8pt font
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function status=dif_dio(INname,OUTname,INdtypes,OUTdtypes);
fprintf('\n ~ DIF_DIO.M ~  processing "%s"..' ,INname)

%_____ SETUP VARS _____
t=[]; 
H=[]; D=[]; 
h=[]; d=[];
hdif=[]; ddif=[];
hd=[]; dd=[];
num_dt=length(INdtypes);											% get number of datatypes

%____ LOAD INPUT FILE ____
fprintf('\nINPUT FILE: %s',INname);								% message
[H,D]=dio2mat(INname);												% load block

%____ LOOP FOR EACH DATATYPE ____
for dt=1:num_dt														% loop for each datatype

	%_____ EXTRACT SPECIFIC DATATYPE _____ 
   [d,h,col]=dio_rec(D,H,2,INdtypes(1,dt));					% dio_rec to extract dataypes	
         
		%_____ CREATE TIME VECTOR T _____
		freq=h(12,1);													% freq is in row 12 						
		t=0:1/freq:length(d)/freq-.0001;
		t=t';																% make a column

			%_____ DIFFERENTIATE _____
			d=vel(t,d);													% first derivative  

				%____ MAKE DIF HEADER HDIF____
				h=h;														% make hdif	 
				h(2,:)=OUTdtypes(1,dt);		     					% replace INdtype w/ OUTdtype

					%____ ASSEMBLE OUTPUT MATRICES ____
  					hdif=[hdif h];										% append ouput header
  					ddif=[ddif d];										% append ouput data (cop) 

end 																		% end datatype loop

[NumTRow,NumTCol]=size(hdif);										% get number of trials

%____ RENAME DATATYPE NAME ~ HDIF ROWS 13-20 IN ASCII CODE ____
hdif(20,1:NumTCol)=hdif(19,1:NumTCol);							% replace row 20 with row 19
hdif(19,1:NumTCol)=hdif(18,1:NumTCol);							% replace row 19 with row 18							
hdif(18,1:NumTCol)=hdif(17,1:NumTCol);							% replace row 18 with row 17
hdif(17,1:NumTCol)=hdif(16,1:NumTCol);							% replace row 17 with row 16
hdif(16,1:NumTCol)=hdif(15,1:NumTCol);							% replace row 16 with row 15
hdif(15,1:NumTCol)=hdif(14,1:NumTCol);							% replace row 15 with row 14
hdif(14,1:NumTCol)=hdif(13,1:NumTCol);							% replace row 14 with row 13
hdif(13,1:NumTCol)=68;												% replace row 13 with D for differentiated

%____ REORGANIZE OUTPUT MATRICES ____
for tn=1:10																% loop to reorganize header columns
   for trial=tn:10:NumTCol 												
		hd=[hd hdif(:,trial)];										% put data dtypes together by trials 
   end
end																		% end header loop

for tn=1:10																% loop to reorganize data columns
   for trial=tn:10:NumTCol																						   
      dd=[dd ddif(:,trial)];										% put data dtypes together by trials
   end						
end																		% end data loop

%__  WRITE DATAIO OUTPUT FILE __
fprintf(' writing to file..');									% message
mat2dio(OUTname,hd,dd); 											% write file
	
fprintf('\nOUTPUT FILE: %s',OUTname); 							% display output file name

fprintf(' ~ END DIF_DIO.M ~ \n ');								% message


