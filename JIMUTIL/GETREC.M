% ************** MATLAB M function (Patton) **************
% returns a single record of a DIO datastructure
% returns a single record of a DIO datastructure, based on the criterion:
% H(head_row)==head_value, where H is the dio header matrix. The data 
% required as input for this function can be obtained using dio2mat.m 
% SYNTAX:	
% CALLS:	
% INPUTS:	D		data matrix many records organized into columns 
%		H		corresponding header matrix
%		head_row	
%		head_value
%		noverbose 	(optional) nonzero supresses messages 
% OUTPUTS:	COP		a matrix of x and z positions	in each		 
%				column and each row is an instant of time.
%				COP is from instrument center.
% CALLED BY: 	
% REVISIONS: 	4/13/98 initaiated from cop_calc.m
% NOTES:	* Code is best viewed in MS word, courier new 8pt font
%		* For information on DATAIO (DIO) FORMAT, see Datio_format.doc
% SEE ALSO:	indiorec.m, dio2mat.m, mat2dio.m
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [d,h,col]=DIOrec(D,H,head_row,head_value);
	
%____ SETUP ____
global DEBUGIT							% nonzero=debugging
if ~exist('noverbose'), noverbose=0;	end;			% set var
if ~noverbose, 						% if messaging 'on'
  fprintf('\n ~ SCD2COP.M ~  Processing "%s.." ',FileName);	% message 
end
h = origin(3);							% instrum. center ht

%____ LOAD INPUT FILE ____
[h,d,Ntrials,Nrecs]=dio2mat(FileName,noverbose);		% load/check block

for trial=1:Ntrials
  %____ EXTRACT VARS ____
  FFvert=
  Fnorth=
  Fwest= 
  Mnorth=
  Mwest=

  %____ CALC COP ____
  COP(:,1) = (h*fp(:,4) - fp(:,2))./fp(:,6);
  COP(:,2) = (h*fp(:,5) + fp(:,1))./fp(:,6);

end %for trial..

if ~noverbose, fprintf(' ~ END SCD2COP.M. ~ '); end;		% show message

