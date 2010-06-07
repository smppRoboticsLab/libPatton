% ************** MATLAB "M" function  (jim Patton) *************
% subject correlations for learn_2 datafile results
% INPUTS:	name	learn2 file name, which loads the 
%				ROOTNAME.mat file, that contains the variables:
%			MAT	 	N by 20 matrix cols 9-20 are data. The 
% 					columns of MAT are:
% 					1) 	subject #
%					2) 	mass		(m)
%					3) 	height 		(H)
%					4) 	Day		
%					5) 	Block		
%					6) 	trial
%					7) 	target force 
%					8) 	norm peak force (Fpeak/H/m)
%					9-20)  data to be sorted 
%			header 		12 by N string matrix of header titles
%			name		short string describing the project (<7 char)
% OUTPUTS:	
% CALLS TO:	
% CALLED FROM:	
%		
% SYNTAX:	
% SEE:   	c:\jim\matlab 
% INITIATIED: 	11/25/96 jim patton from sort3way.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function S=lrn2_sc(name)

%____________ PRELIM STUFF ________
fprintf('\n~ lrn2_sc.m MATLAB m-function (Patton) subject correlations ~\n');
load splat; y=y(1:4:2000); y=([y;flipud(y)]); Fs=Fs/3; sound(y,Fs);

%_______ LOAD FILE ________
eval(['load ' name]); 						% load the mat file
MAT=col_sort(MAT,[1 4 8]);					% remove gunk & sort

[M,N] = size(MAT);
for S=1:10							% loop: each subject
  eval(['Q' num2str(S) '=[];']); % add this to the 
  i=1; while(MAT(i,1)~=S), i=i+1; end %while			% advance to current subj
  first(S)=i;
  while (MAT(i,1)==S & i<M), 
    last(S)=i; 						
    eval(['Q' num2str(S) '=[Q' num2str(S) '; MAT(i,:)];']); % add this to the 
    i=i+1; 
  end %while
  eval(['corMAT' num2str(S) '=corrcoef(Q' num2str(S) ');']); % correlations
  CMDstr=['save ' name 'C' num2str(S) '.dat corMAT'	...
		num2str(S) ' -ascii -double -tabs']; 
  disp(CMDstr); 
  eval(CMDstr); 
end %for S

fprintf(' ~ lrn2_sc.m DONE. ~ \n');

