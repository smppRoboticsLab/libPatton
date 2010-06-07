%************** MATLAB "M" function (jim Patton) *************
% load an ASCII datafile in the M.I.T. "dataman" format:
% _____ Here is the format: _____
% ManagedData
% 301 RECORDS
% {
%  . . dataMatrix  . . .
%  .
%  .
%  .
%  -7777,trial,samplingRate(Hz),field_on(1=yes; 0=no),0,0
%  -7777,field_type(1=stiff,2=visc,3=inertial),Gain_xx,Gain_xy,Gain_yx,Gain_yy
% }
% 
%  (the -7777 is optional, but helps to indicate that it information is to follow)
%
% SYNTAX      [DATA,v1,v2]=loadDataman(filename,verbose);
% INPUTS:     filename 
%             verbose     nonzero for display of messages
% OUTPUTS:    DATA        data matrix (Usually 4 or 6 columns)
%             v1          paramters stored in the 2nd to last row
%             v2          paramters stored in the last row
% REVISIONS:  1/21/99     initiated jim patton
%             9/20/99     allowed return variables v1 & v2, cleaned up comments
% SEE ALSO:   saveDataman	
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [DATA,v1,v2]=loadDataman(filename,verbose);

%____ SETUP:_____
if ~exist('verbose'), verbose=1; end
if verbose, fprintf('~ loadDataman.m ~ Load: %s.. ',filename); end 

% ___ LOAD & PARSE: ___ 
fid=fopen(filename,'rt');
if (fid==-1), 
  if verbose, fprintf(' (!Can"t open it!) '); end
  DATA=-1; v1=NaN; v2=NaN;
  return
end
for i=1:3, textLine=fgetl(fid); end                 % read 1st 3 textLines

i=0;
while (textLine(1)~= '}' )
  i=i+1;
  textLine=fgetl(fid);                             % read textLine of text
  if ~isstr(textLine), fprintf(' EOF!'); end
%   rowvect=str2num(parse(textLine,abs(' ')'))'     % convert to row vect
  rowvect=str2num(parse(textLine,abs(' ')'));
  if size(rowvect,1)>size(rowvect,2); rowvect=rowvect'; end % transpose if not a row
  if length(rowvect)<1, break; end;
  DATA(i,:)=rowvect;
end % while textLine
fclose(fid);  % close FILE 

% __ extract & remove last 2 textLines (these are params)__
v1=DATA(i-2,:);                                 % 
v2=DATA(i-1,:);                                 % 
DATA(i-1,:)=[];                                 % snip off row
DATA(i-2,:)=[];                                 % snip off row

DATA=cleanNaN(DATA,0);

if verbose, fprintf(' DONE. ~ END loadDataman.m ~'); end
return; 
