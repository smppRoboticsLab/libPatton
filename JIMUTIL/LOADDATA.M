% ************** MATLAB "M" file  (jim Patton) *************
% The following loads variables into data based on k, i and j indicies 
%
% 	INPUTS:		DATA, k, i, j 	in memory
% 	CALLED FROM:	doanova8.m	M file
%
% initiatied 7/28/95 jim patton from doanova8.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

%fprintf('\n *** loaddata.m MATLAB m-file (Patton) *** \n');

if DATA(i,4) == 1,				% if DAY 1
	k(j,1)=k(j,1)+1;
    	A_1(k(j,1),j) 	= DATA(i,9);
    	B_1(k(j,1),j) 	= DATA(i,10);
    	C_1(k(j,1),j) 	= DATA(i,11);
    	D_1(k(j,1),j) 	= DATA(i,12);
    	E_1(k(j,1),j) 	= DATA(i,13);
    	F_1(k(j,1),j) 	= DATA(i,14);
    	G_1(k(j,1),j) 	= DATA(i,15);
    	H_1(k(j,1),j) 	= DATA(i,16);
    	I_1(k(j,1),j) 	= DATA(i,17);
    	J_1(k(j,1),j) 	= DATA(i,18);
    	K_1(k(j,1),j) 	= DATA(i,19);
    	L_1(k(j,1),j) 	= DATA(i,20);
else						% if DAY 5
	k(j,2)=k(j,2)+1;
    	A_5(k(j,2),j) 	= DATA(i,9);
    	B_5(k(j,2),j) 	= DATA(i,10);
    	C_5(k(j,2),j) 	= DATA(i,11);
    	D_5(k(j,2),j) 	= DATA(i,12);
    	E_5(k(j,2),j) 	= DATA(i,13);
    	F_5(k(j,2),j) 	= DATA(i,14);
    	G_5(k(j,2),j) 	= DATA(i,15);
    	H_5(k(j,2),j) 	= DATA(i,16);
    	I_5(k(j,2),j) 	= DATA(i,17);
    	J_5(k(j,2),j) 	= DATA(i,18);
    	K_5(k(j,2),j) 	= DATA(i,19);
    	L_5(k(j,2),j) 	= DATA(i,20);
end % if DATA(i,4) == 1	

%disp('*** (END loaddata.m) ***');


