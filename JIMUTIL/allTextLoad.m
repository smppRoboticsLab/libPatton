%% allTextLoad: Load text from an ASCII into a character striing matrix .
%     [textArray]=allTextLoad(fileName) reads a data file
%     called 'filename.ext', which contains a text.  There
%     is no default extension; any extensions must be explicitly
%     supplied.
%
%     The  output is a text array.
%
%     See also LOAD, SAVE, SPCONVERT, FSCANF, FPRINTF, STR2MAT, HDRLOAD.
%     See also the IOFUN directory.
%
%     modified by patton to make it compatible with release 12 (v.6)
%

%% ___ begin:___
function [textArray]=allTextLoad(fileName)

% check number and type of arguments
if nargin < 1
  error('Function requires one input argument');
elseif ~ischar(fileName)
  error('Input argument must be a string representing a filename');
end

% Open the file.  If this returns a -1, we did not open the file 
% successfully.
fid = fopen(fileName);
if fid==-1
  error(['File "' fileName '" not found or permission denied']);
end

%% Initialize loop variables
% We store the number of lines in the header, and the maximum length
% of any one line in the header.  These are used later in assigning
% the 'header' output variable.
no_lines = 0;
max_line = 0;

%% Start processing.
line = fgetl(fid);
if ~ischar(line)
  disp('Warning: file empty')
end;
textArray=[];%'top';
while ischar(line)
  no_lines = no_lines+1;
  max_line = max([max_line, length(line)]);
  textArray=str2mat(textArray,line); % stack a new line of header text
  line = fgetl(fid);
end % while
textArray(1,:)=[]; % this is because there is always an extra line inserted

%% close and end
fclose(fid);
return

