%% extract a chunk of data based on set of criteria in a columnwise file
% ************** MATLAB "M" function (jim Patton) *************
% This program finds a chunk of data based on what you are looking for in
% columns, and returns a matrix.
% SYNTAX:         
%  chunk=extractChunk(fileName,criteriaList,outputName)
% INPUTS:
%   filename      name of input datafile
%   criteriaList  arrayed structure- each array eleement has 
%                   .name   name of the column header you are looking under
%                   .value  value you are looking to satisfy in that column
%   outputName    (optional) specifies the column of data to return 
%                 if not given, the program will return the all the rows
%                 that satisfy the criteria 
% OUTPUTS:
% VERSIONS: 
% EXAMPLE:  
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function chunk=extractChunk(fileName,criteriaList,outputName)

%% setup
rowList=[];
 
%% load
[h,d]=hdrload(fileName);
for criteria=1:length(criteriaList)
  C(:,criteria)=textract(fileName,criteriaList(criteria).name);
  if C(1,criteria)==-8888, 
    warning('\n Cant find colum with label [%s]',criteriaList(criteria).name); 
  end
end

%% big loop for sifting
for row=1:size(d,1)
  for criteria=1:length(criteriaList)
    if C(row,criteria)~=criteriaList(criteria).value,
      keep=0;
      break; % does not pass so give up this row
    else
      keep=1;
    end
  end % end for criteria
  if keep, rowList=[rowList; row]; end
end

%% assembly of output based on rows that succeed
if exist('outputName'); 
  outData=textract(fileName,outputName); 
else
  outData=d;
end

chunk=outData(rowList,:);


  
return
