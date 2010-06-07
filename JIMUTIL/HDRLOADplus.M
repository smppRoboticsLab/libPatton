% HDRLOADplus Load data from ASCII file of text headers then data.
%     [header, data] = HDRLOADplus('filename.ext') reads a data file
%     called 'filename.ext', which contains a text header.  There
%     is no default extension; any extensions must be explicitly
%     supplied. 
%
%     The structure of hte file should be header text, then data in
%     columns, then an other header, then data in columns, etc. There are
%     no resrictions on size, nor is it required to have the data 
%     and header sizes be consistent. 
%
%     The first output, H, is the header information, returned
%     as a cell array of text matrices.
% 
%     The second output, D, is the data, returned
%     as a cell array of text matrices.  This data matrix
%     has the same dimensions as the data in the file, one row per
%     line of ASCII data in the file.  
%
%     output N is the number of records stored in D
% 
%     If the data is not regularly 
%     spaced (i.e., each line of ASCII data does not contain the
%     same number of points), the data is returned as a column
%     vector.
%
%     Limitations:  No line of the text headers can begin with
%     a number.
%
%     See also HDRLOAD, LOAD, SAVE, SPCONVERT, FSCANF, FPRINTF, STR2MAT.
%     See also the IOFUN directory.
%
%     modified by patton to make it compatible with release 12 (v.6)
%     4/23/04   modified by Jim Patton and renamed HDRLOADplus.M in 
%               order to allow for mutiple records separated by text:
%               D is now the output, which is a cell array of matricies
%     11-8-2005 modified to allow headers (H) to be read into a cell 
%               array of matricies as well. 
%     10-10-2007 (patton) added output argument N. 
%     11-06-2007 (patton) fixed N to read only one value
%
% ___ begin:___

function [H,D,N]=HDRLOADplus(file)

% check number and type of arguments
if nargin < 1
  error('Function requires one input argument');
elseif ~isstr(file)
  error('Input argument must be a string representing a filename');
end

% Open the file.  If this returns a -1, we did not open the file 
% successfully.
fid = fopen(file);
if fid==-1
  error('File not found or permission denied');
  end

% Initialize loop variables
% We store the number of lines in the header, and the maximum length
% of any one line in the header.  These are used later in assigning
% the 'header' output variable.
no_lines = 0;
max_line = 0;
firstTimeThru=1;
% We also store the number of columns in the data we read.  This way
% we can compute the size of the output based on the number of
% columns and the total number of data points.
ncols=0;
nDataSets=0;

% __Start processing__
line=fgetl(fid);
if ~isstr(line)
  disp('Warning: file contains no header and no data')
end;

% One slight problem, pointed out by Peter vanderWal: If the first
% character of the line is 'e', then this will scan as 0.00e+00.
% We can trap this case specifically by using the 'next index'
% output: in the case of a stripped 'e' the next index is one,
% indicating zero characters read.  See the help entry for 'sscanf'
% for more information on this output parameter.
% We loop through the file one line at a time until we find some
% data.  After that point we stop checking for header information.
% This part of the program takes most of the processing time, because
% fgetl is relatively slow (compared to fscanf, which we will use
% later).

while isstr(line)    
%   disp('.')
 header=[];   %initialize the header [] ;
 data=[];     % initialize the data to [].
  [data, ncols, errmsg, nxtindex] = sscanf(line, '%f');
  while isempty(data)|(nxtindex==1)
    no_lines = no_lines+1;
    max_line = max([max_line, length(line)]);
    % Create unique variable to hold this line of text information.
    % Store the last-read line in this variable.
%     if firstTimeThru,  s
      header=str2mat(header,line);% stack a new line of header text
%     end;
    line = fgetl(fid);
    if ~isstr(line)
%       disp('(no data)')
      break; break
    end;
    [data, ncols, errmsg, nxtindex] = sscanf(line, '%f'); % get features from 1 line of data
  end   % END WHILE ISEMPTY
  firstTimeThru=0;
  header(1,:)=[]; % clipthis is because there is always an extra line inserted

  % Now that we have read in the first line of data, we can skip the
  % processing that stores header information, and just read in the
  % rest of the data. 
  if isstr(line) % if not EOF
    
    data=[data; fscanf(fid, '%f')];           % <==== fast read of rest of data here!
    
    % Resize output data, based on the number of columns (as returned
    % from the sscanf of the first line of data) and the total number of
    % data elements. Since the data was read in row-wise, and MATLAB
    % stores data in columnwise format, we have to reverse the size
    % arguments and then transpose the data.  If we read in irregularly
    % spaced data, then the division we are about to do will not work.
    % Therefore, we will trap the error with an EVAL call; if the reshape
    % fails, we will just return the data as is.
    eval('data = reshape(data, ncols, length(data)/ncols)'';', ' failure. ');
    %   data = reshape(data, ncols, length(data)/ncols)'';
    nDataSets=nDataSets+1;
    
    % put sucessive data blocks in the larger cell arrays:
    H{nDataSets,1}=header;
    D{nDataSets,1}=data;
    line=fgetl(fid);
  else 
    break
  end
  
end  % END WHILE 
fclose(fid); 

N=size(D,1);

% And we're done!
