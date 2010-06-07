% ********** sortstat.M MATLAB "M" function (Russo/Steege/Patton/Bedford) *********
% Sorts the appropriate submatrix based on input ranges, and output the statistic
%  SYNTAX:	statvalue=sortstat(mtx2sort,hilos,)
%  INPUTS:   	MTX 		matrix with all but the last colums indicators
%				of independent variables for sorting. The last column 
%				is the variable for performingthe final statisic
%		hilos		criterion matrix.  Each independent variable will 
%				have a row in this corresponding to the independent
%				variable in the MTX.  This row will have a high and 
%				low element that is the cutoff for sorting: if all 
%				the independent variables are in between the highs 
%				and the lows, then use this record.
%		action 		What to do with the sorted data vector(e.g., 'mean')
%  OUTPUTS:	output		output of the action on the sorted data
%  CALLS:	-
%  VERSIONS:	initiated 1/30/97 patton
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ Begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function output=sortstat(MTX,hilos,action)
fprintf(' ~ sortstat.m M-Function ~ '); pause(.01);  % pause updates display now

% _SETUP_
global DEBUGIT
output=[];	% initalize

if length(MTX(1,:))-1~=length(hilos(:,1))  |  length(hilos(1,:))~=2,
  fprintf('input arguements for sortstat are wrong;')
end %if length....

data=[];
for I=1:length(MTX(:,1))			% loop for each row (record)
  yes=1;					% initially assume that it meets criteria
  for J=1:length(MTX(1,:))-1			% loop for each independent variable	
    if MTX(I,J)<hilos(J,1) yes=0; end		% if less than min, reject
    if MTX(I,J)>hilos(J,2) yes=0; end		% if more than max, reject
  end
  if yes, data=[data MTX(I,1)]; end 	% if yes is still true, record this trial
  end %if
end %for

if length(data)==0, 	
  output=-9999; end; 	% if nothing, give -9999
  if DEBUGIT disp('N=0'); end;
else			
  cmdstr=['output=' action '(data);'];
  if DEBUGIT disp([cmdstr   '   N=' num2str(length(data))]); end;
  eval(cmdstr); 
end; %if length

if DEBUGIT, 
  data
end %if DEBUGIT

fprintf(' ~ sortstat.m DONE ~ ');

