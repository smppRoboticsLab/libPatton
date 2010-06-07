% ************** MATLAB "M" file  (jim Patton) *************
% sorts a matrix (M1) first into subject, then day, then force based 
% on the following structure for M:
%  INPUTS:	M1 	matrix whose columns are:		
%  				1  	sub_num        
%  				2  	mass           
%  				3  	H              
%  				4  	day            
%  				5  	block          
%  				6  	trial          
%  				7  	pull_targ      
%  				8  	norm_peak_force
%  				9-20  	data       
%  OUTPUTS:	M2 	same structure, different order of rows 
%  CALLS:	
%  CALLED BY:	engin
%  INITIATIED:	6/21/96 by patton from noptmset.m
%  SYNTAX:	M2=sortpull(M1);
%  SEE:   	\jim\lee\energy\non_opt\devel or the OLD subdirectory
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function M2=sortpull(M1);
fprintf('\n ~ sortpull.m ~ \n');

%_____________ SORT ____________
[Y,I] = sort(M1);  Mf=M1(I(:,8),:);			% SORT BY FORCE
[Y,I] = sort(Mf);  Md=Mf(I(:,4),:);			% SORT BY day
[Y,I] = sort(Md);  M2=Md(I(:,1),:);			% SORT BY subject

fprintf('\n ~ END sortpull.m ~ \n');

