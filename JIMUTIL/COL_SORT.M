% ************** MATLAB "M" function  (jim Patton) *************
% Sorts a matrix (MAT) based on increasing order for column col.
% if col os a vector, then it will sort first by increasing order of col(1),
% then by col(2), etc.
% INPUTS:	MAT	 	N by M matrix 
%		col		vector of column sort order (pos intergers)
% OUTPUTS:	outMAT		new matrix
% CALLS TO:	
% CALLED FROM:	?
% SYNTAX:	outMAT=col_sort(MAT, col); 
% SEE:   	c:\jim\matlab 
% INITIATIED: 	11/25/96 jim patton from sort3way.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [MAT]=col_sort(MAT, col);

% __ prelim stuff____
fprintf('\n~ col_sort.m MATLAB m-function (Patton) ~ ');
load splat; y=y(1:.2*length(y)); y=([y;flipud(y)]); sound(y,Fs);

MAT=cleannan(MAT); 		% DELETE ALL LINES OF DATA WITH NAN ELEMENTS 
[M,N]=size(MAT);		% FIND SIZE
len=length(col);		% find number of sorts

% __ SORT  ___
fprintf('\n ___Sorting... '); drawnow;

for j=len:-1:1
  fprintf('sort per COL%d...',col(j)); drawnow; 
  [dummy_mat,I]=sort(MAT(:,col(j))); 
  MAT=MAT(I,:);
end %for j

clear dummy_mat;
fprintf(' DONE.   ~ END col_sort.m ~  '); drawnow;

return;

