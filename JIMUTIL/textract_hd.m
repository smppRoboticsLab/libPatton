%***************** MATLAB M function  -  patton *********************
% Extract a set of values from a header and data combination.
% this program assumes a teaxt header (H) in 
% which the last line is a list of column labels, followed by columnwise  
% data associated with the labels. The lables must be separated by a tab 
% character. This program is case insensitive - all strings are convered to 
% lowerase before matching.
% SYNTAX:      X= textract(filename,labelist);
% INPUTS       H
%              D
% OUTPUTS      X          Contains values associated with labelist.  
%                         If a value could not be found for a 
%                         given label, that a value of -8888 will 
%                         be returned.
% CALLS:       parse.m    separate out a list of labels separated by tabs
%
% SEE ALSO    textract  (does this from a file)
% 
% REVISIONS:   6/17/08  (patton) from textract.m
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function X=textract_hd(H,filedata,labelist)

%_____ SETUP VARS _____
global DEBUGIT                                       % nonzero for verbose
if DEBUGIT, fprintf('\n ~ TEXTRACT_HD.M ~ '); end;   % message
ascii_tab=9;                                         % ASCII code for tab char
noresult=-8888;                                      % code for not found

%_____ PREPARE STRINGS _____ 
S=H(length(H(:,1)),:);                               % S=last line of header
filelist=parse(S,ascii_tab);                         % transpose (find list)
filelist=lower(filelist);                            % convert to lowercase
labelist=lower(labelist);                            % convert to lowercase
ND=length(filedata(:,1));                            % # ROWS OF DATAPOINTS
NF=length(filelist(:,1));                            % # of output values 
NL=length(labelist(:,1));                            % # labels (output values)
X=noresult*ones(ND,NL);                              % init w/code for not found

%_____ EXTRACT VALUES BY FINDING MATCHES_____ 
for LL=1:NL,                                         % LOOP for ea output value
  list_label=deblank(labelist(LL,:));                % remove trialing blanks
  for FL=1:NF,                                       % LOOP for ea label in file
    file_label=filelist(FL,1:size(list_label,2));    % trim to same length 
    if DEBUGIT, fprintf('\nlabel=%s',file_label);end %
%     list_label,file_label, pauser
    if strcmp(list_label,file_label),                % compare, if they match:
      X(:,LL)=filedata(:,FL);                        % copy to output value
      if DEBUGIT, fprintf('\nmatch. %f',X); end      %
      break;                                         % stop looking 
    end                                              % end if strcmp
  end;                                               % end for FL  
end;                                                 % end for LL    

if DEBUGIT, fprintf(' ~ END TEXTRACT.M ~ \n '); end;  % END OF FUNCTION
