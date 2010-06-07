%***************** MATLAB M function  -  patton *********************
% Extract a set of values from an acii file with headers
% this programs assumes there will be an ASCII file with a header in 
% which the last line is a list of labels, followed by the data 
% associated with the labels.   The lables must be separated by a tab 
% character, and the data must be readable by hdrload.m. See hdrload.m 
% for the rules for making an ascii file.  This program is not case 
% sensitive - all strings are convered to lowerase before matching.
% SYNTAX:      X= textract(filename,labelist);
% INPUTS       filename   filename 
%              labelist   contians the list of labels you want to 
%                         fetch data for.  The label list does not 
%                         have to have the full label, just enough 
%                         to make sure it is unique from the rest 
%                         of the labels in the file.  If it is not 
%                         unique, textract will return the data 
%                         from the first label it finds.
% OUTPUTS        X        Contains values associated with labelist.  
%                         If a value could not be found for a 
%                         given label, that a value of -8888 will 
%                         be returned.
% CALLS:       hdrload.m  load ASCII file that contians header text
%              parse.m    separate out a list of labels separated by tabs
%
% SEE ALSO    textract_hd
% 
% REVISIONS:   6/5/97 by Patton. Initiated from batch1.m
%              4/8/99 patton: put 'break' to stop looking when it finds a match
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function X=TEXTRACT(filename,labelist);

%_____ SETUP VARS _____
global DEBUGIT                                       % nonzero for verbose
if DEBUGIT, fprintf('\n ~ TEXTRACT.M ~ '); end; %if  % message
ascii_tab=9;                                         % ASCII code for tab char
noresult=-8888;                                      % code for not found

%_____ LOAD _____ 
if DEBUGIT, fprintf('hdrload -ing:\n'); end;         % message
[H,filedata]=hdrload(filename);                      % load header and data
if DEBUGIT, fprintf(' DONE. '); end;                 % message

%_____ PREPARE STRINGS _____ 
S=H(length(H(:,1)),:);                               % S=last line of header
filelist=parse(S,ascii_tab);                         % transpose (find list)
filelist=lower(filelist);                            % convert to lowercase
labelist=lower(labelist);                            % convert to lowercase
ND=length(filedata(:,1));                            % # ROWS OF DATAPOINTS
NF=length(filelist(:,1));                            % # of output values 
NL=length(labelist(:,1));                            % # labels (output values)
X=-8888*ones(ND,NL);                                 % init w/code for not found

%_____ EXTRACT VALUES BY FINDING MATCHES_____ 
for LL=1:NL,                                         % LOOP for ea output value
  list_label=deblank(labelist(LL,:));                % remove trialing blanks
  for FL=1:NF,                                       % LOOP for ea label in file
    file_label=filelist(FL,1:length(list_label));    % trim to same length 
    if DEBUGIT, fprintf('\nlabel=%s',file_label);end %
    if strcmp(list_label,file_label),                % compare, if they match:
      X(:,LL)=filedata(:,FL);                        % copy to output value
      if DEBUGIT, fprintf('\nmatch. %f',X); end      %
      break;                                         % stop looking 
    end                                              % end if strcmp
  end;                                               % end for FL  
end;                                                 % end for LL    

if DEBUGIT, fprintf(' ~ END TEXTRACT.M ~ \n '); end;  % END OF FUNCTION
