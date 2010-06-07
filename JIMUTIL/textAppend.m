% ************** MATLAB "M" function  *************
% text on a plot according to fractions of plot window.
% SYNTAX:	      status=textAppend(S,fname,verbose,noTimestamp)
% INPUTS:	       S              string of text or matrix of text
%               fname          filename to load data from 
%                             (if not given, it is "trouble.log")
%               verbose        (optional) nonzero for verbose play-by-play
%               noTimestamp      (optional) nonzero for line with a date & time stamp
% OUTPUTS:      status
% CALLS:	
% REVISONS:     Initiated 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=textAppend(S,fname,verbose,noTimestamp)

% ___ SETUP ___
global DEBUGIT                                       % nonzero=debugging
if ~exist('fname'), fname='trouble.log'; end;        % set default if no entry
if ~exist('verbose'), verbose=0; end;                % set default if no entry
if ~exist('noTimestamp'), noTimestamp=1; end;        % set default if no entry
prog_name='textAppend.m';                            % this program's name
if verbose, fprintf('\n~ %s ~ ', prog_name);  end    % message
if DEBUGIT, verbose=1; end

%____ OPEN FILE ____
fid=fopen(fname,'a');                                % open file for append
if fid==-1,                                          % status=1 if cant open
  status=-1; 
  fprintf('\n! Error in %s: Cannot write to %s\n',...%
    prog_name,fname);
  return
else 
  status=0; 
end 

%____ WRITE file ____
if verbose, fprintf(' writing to file..'); end       % message
if ~noTimestamp
  fprintf(fid,'\r\n____ %s: ____ ',whenis(clock));      % write header text
end

%____ WRITE S ____
for i=1:length(S(:,1))                               % each row of S
  fprintf(fid,'\r\n%s',deblank(S(i,:)));             % write header text
end %for i                                           %

fclose(fid);                                         % close output file

if verbose, 
  fprintf(' DONE. ');                                % message
  fprintf('\n~ EfND %s ~ \n\n', prog_name);           % 
end                                                  % message

return;

