%************** MATLAB M function (Patton) **************
% Returns subset of records (columns) from a DIO datastructure. 
% This is an easy concept, but its tough to understand how to make work.
% For information about DATAIO (DIO) FORMAT, see 'Datio_format.doc'.
% This output subset is obtained based on criteria met by the DIO's  
% header "H". The variables "D" and "H" (see below) are obtained prior  
% dio_rec.m using dio2mat.m. dio_rec.m extracts the appropriate columns  
% to using of "H" and "D", based on criteria specified by "head_row" &  
% "head_value" such that 
%                  if (H(head_row(1),i)==head_value(1) 
%                   &  H(head_row(2),i)==head_value(2) 
%                   & ... 
%                   &  H(head_row(N),i)==head_value(N) )  
% then H(:,i) and D(:,i) will be placed in the output matricies.
%
% SYNTAX:     [d,h,col]=dio_rec(D,H,head_row,head_value,noverbose);
% INPUTS:     D           data matrix many records organized into columns 
%             H           corresponding 'header' matrix that provides 
%                         info about the matrix D (each column of H 
%                         corresponds to the same column of D)
%             head_row    Each element of head_row is a row number. This 
%                         row number is the row of the header (H) that 
%                         must match head_values
%             head_value  corresponding values that must be in the 
%                         header (H) for the record to be included 
%                         in the output
%             noverbose   (optional) nonzero supresses messages 
% OUTPUTS:    d           extracted data matrix of records of D that 
%                         met criteria defined in head_row & head_value
%             h           extracted header matrix of records of H that 
%                         met criteria defined in head_row & head_value 
%             col         list of the column numbers of H that 
%                         met criteria defined in head_row & head_value 
% EXAMPLES:  [D5,H5]=dio_rec(D,H,3,5);
%                         This extracts all of trial 5 data to D5 and H5
%                         (NOTE DIO header row 3 stores trial number. See 
%                         Datio_format.doc for more info on headers)
%            [D5_101,H5_101]=dio_rec(D,H,[3 2],[5 101]);
%                         This extracts the column(S) that are from trial 
%                         5 and have datatype code 101 to D5_101 and H5_101
%                         (NOTE DIO header row 2 stores datatype codes. See 
%                         Datio_format.doc for more info on headers)
% CALLS:	
% CALLED BY: 	
% REVISIONS:  4/13/98 initaiated from cop_calc.m
%             4/20/98 revised to retreive multiple records (if applicable)
%             8/12/98 enhanced header remarks for help
% NOTES:	     * For information on DATAIO (DIO) FORMAT, see Datio_format.doc
% SEE ALSO:   indiorec.m, dio2mat.m, mat2dio.m
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [d,h,col]=dio_rec(D,H,head_row,head_value,noverbose);
	
%____ SETUP ____
%global DEBUGIT                                        	% nonzero=debugging
if ~exist('noverbose'), noverbose=0;	end;            	% set var
Nmatch=length(head_row);                                 % #criteria to match
if ~noverbose,                                           % if messaging 'on'
  fprintf('\n ~ DIO_REC.M (%d. criteria) ~ ',Nmatch);    % message 
end;                                                     % end loop
d=[]; h=[]; col=[];                                      % initialize
[rows,cols]=size(D);                                     % dimensions of data

% __CONSTRUCT THE "CRITERIA" COMMAND__
cmd='if ';                                               % init "if" command
for match=1:Nmatch                                       % loop: ea criterion
  if match>1, cmd=[cmd '& '];	end                        % add logical AND
  cmd=[cmd 'H(head_row(' num2str(match) '),i)=='     ... % add logic criter.
          'head_value(' num2str(match) ')'];             % finish"if" command
end                                                      % END for match
cmd=[cmd ',d=[d D(:,i)];h=[h H(:,i)];col=[col i]; end;'];% end CRITERIA comand

% __ USE THE "CRITERIA" COMMAND TO FIND THE RECORD __ 
for i=1:cols, eval(cmd); end                             % check each column 

% __ FINAL MESSAGES__ 
if ~noverbose,                                           % nonzero=messages
  if isempty(d), fprintf(' \7 match not found. ');       % show message
  else,          fprintf(' Match found in column(s):');  % show message
                 fprintf(' %d ',col);                    % show message 
  end                                                    % end %if isempty..
  fprintf(' ~ END DIO_REC.M. ~ \n');                     % show message
end                                                      % END if ~noverbose

