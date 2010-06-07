%********************** MATLAB M function (Patton) **********************
% scans lines of a textfile & finds value in the line that has "string2find value"
% SYNTAX:       value=find1TXTvalue(filename,string2find,verbose);
% INPUTS:       verbose=nonzero for messages              
% OUTPUTS:      value=[] if nothing found              
% REVISIONS:    7/99      Initiated by Patton
%               9/24/99   made output [] if nothing found
% NOTE:         THIS IS DEFUNCT AND NOT NEEDED. USE findInText.m INSTEAD. 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function value=find1TXTvalue(filename,string2find,verbose);

prog_name='find1TXTvalue.m';                                % this program's name
if ~exist('verbose'), verbose=1; end
if verbose, fprintf('~ %s ~ ',prog_name); end               % orient user
value=[];                                                   % init
len=length(string2find);                                    % size of string to find
warning(' find1TXTvalue.m IS REPLACED BY findInTxt.m ')

% __load file__
fid=fopen(filename,'rt');
if fid==-1,                                                 % file not found -- abort
  fprintf('(cant open "%s.") ',filename); 
  return ; 
end          
while 1
  line=fgetl(fid);                                          % read a line
  %if verbose, fprintf('\n %s',line); end                   % display line
  if ~isstr(line), break, end                               % if number, quit
  if strncmp(line,string2find,len),                         % if string we want,
    value=str2num(line(len+1:length(line)));                % find the value that follows
    fclose(fid); return                                     % CLOSE FILE & quit
  end  
end
fclose(fid);                                                % CLOSE FILE
return
