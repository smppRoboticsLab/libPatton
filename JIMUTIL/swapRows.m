%************** MATLAB "M" function (jim Patton) *************
% swap 2 rows of a matrix
% SYNTAX:       d=swapRows(d,i,j,verbose)
% REVISIONS:    10/2/00 INITIATED by patton
%~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

function d=swapRows(d,i,j,verbose)

%____ SETUP ____
if ~exist('verbose'), verbose=0; end
if verbose, fprintf('~ %s ~ ', prog_name); end 

q=d(j,:); 
d(j,:)=d(i,:); 
d(i,:)=q;

if verbose, fprintf('~ END %s ~ ', prog_name); end 




