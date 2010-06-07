%************** MATLAB "M" file  (jim Patton) *************
% Delete all lines of data with NaN elements 
%  SYNTAX:	function MAT=cleannan(MAT,verbose);
%  INPUTS:	MAT 		input matrix	
%		verbose		(optional) nozero for messages
%				default=1;
%  OUTPUTS:	MAT 		repaired matrix with NaN lines removed 
%  CALLS:	
%  REVISIONS:	Initiatied 11/7/95 jim patton 
%		5/4/98 (patton) enhance to have verbose & remove sound.
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function MAT=cleannan(MAT,verbose);

%_________ SETUP ________
if ~exist('verbose'); verbose=1; end
if verbose fprintf('\n~ cleannan.m (patton) ~'); end
%load splat; y=y(1:600); 

%_________ DELETE ALL LINES OF DATA WITH NAN ELEMENTS ________
if sum(sum(isnan(MAT))),
  Q=MAT; MAT=[]; count=0; rows=length(Q(:,1)); cols=length(Q(1,:));
  if verbose fprintf('Deleting NaN rows (of %dX%d)...',rows,cols); end
  pause(.01);
  for i=1:length(Q(:,1))
    if ~sum(isnan(Q(i,:))), count=count+1; MAT(count,:)=Q(i,:); 
    elseif verbose fprintf('.\7'); end; 
  end % for i
  if verbose fprintf('\nDone. %d of %d rows deleted\n', i-count,i); end
elseif verbose fprintf(' <matrix is OK!> ');
end % if sum(..

if verbose fprintf('~END cleannan.m~'); end

