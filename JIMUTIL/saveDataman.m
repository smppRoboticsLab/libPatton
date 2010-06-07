%************** MATLAB "M" function (jim Patton) *************
% save an ASCII datafile in the M.I.T. "dataman" format.
% SYNTAX:       DATA=loadDataman(filename,verbose);
% This format is bracketed data matrix with the last 2 lines of data are parameters.
% the paramters vary, but below is a typical example
% _____ Here is template format: _____
% ManagedData
% N RECORDS
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
% INPUTS:       filename    name of file with extnsion
%               dataMatrix  data including the last 2 lines of extra paramters.
%               verbose     nonzero for display of messages
% REVISIONS:    9/20/99     initiated jim patton
% SEE ALSO:     loadDataman
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function status=saveDataman(filename,dataMatrix,verbose);

%____ SETUP:_____
if ~exist('verbose'), verbose=1; end                  % if not passed
fcnName='saveDataman.m';
if verbose,fprintf('\n~ %s ~ saving..',fcnName);end
delimiter=abs(' ');                                   % ascii code for whitespace

h=str2mat('ManagedData',                          ...
   [num2str(length(dataMatrix(:,1))) ' RECORDS'], ...
   '{');
  
status=mat2txt(filename,h,dataMatrix,0,0,delimiter);  % save ths in ascii format
status=status+textAppend('}',filename);               % add closing bracket to end

if verbose, fprintf(' ~ END %s ~ \n',fcnName); end
return; 
