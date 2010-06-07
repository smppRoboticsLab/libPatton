%********************** MATLAB M function (Patton) **********************
% scans lines of a textfile & finds OUT in the line that has "string2find OUT"
% SYNTAX:       OUT=findInTxt(filename,string2find,s,verbose);
% INPUTS:       s         nonzero for returning a string 
%               verbose   nonzero for messages              
% OUTPUTS:      OUT=[] if nothing found              
% REVISIONS:    7/99      Initiated by Patton
%               9/24/99   made output [] if nothing found
%               10/13/00  RENAMED findInTxt and allowed for text string as 
%                         well as numerical value, eliminating the need 
%                         for find1TXTvalue.m
% NOTE:         Spaces, not tabs when writing code make it most portable
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function OUT=findInTxt(filename,string2find,s,verbose);

prog_name='find1TXTvalue.m';                                % this program's name
if ~exist('verbose'), verbose=0; end
if ~exist('s'), s=0; end
if verbose, fprintf('~ %s ~ ',prog_name); end               % orient user
OUT=[];                                                   % init
len=length(string2find);                                    % size of string to find

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
  if strncmp(lower(line),lower(string2find),len),           % if string we want,
    if verbose, fprintf('FOUND:%s\n',line), end
    if s
      OUT=(line(len+1:length(line)));                       % find the OUT that follows
      return  
    else      
      OUT=str2num(line(len+1:length(line)));                % find the OUT that follows
      return
    end  
    fclose(fid); return                                     % CLOSE FILE & quit
  end  
end
fclose(fid);                                                % CLOSE FILE
return
