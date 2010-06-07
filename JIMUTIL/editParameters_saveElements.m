% editParameters_saveElements: save elements of the edit GUI
%% ************** MATLAB "M" script  (jim Patton) *************
% This is called by editParameters.m only - see that function
%  SYNTAX:  
%  INPUTS:  
%  OUTPUTS:	
%  INITIATIED:	 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function editParameters_saveElements()
global elements outName inExtraDataBlock

h=[]; hCounter=0;
for i=1:length(elements)
  hNew=sprintf('%s=%s',elements(i).name,get(elements(i).hdl,'string'));
  h=str2mat(h,hNew);
end
h

if menu('Are you sure you want to save? ','NO -- do not save', 'YES -- Save and close')-1
  mat2txt(outName,h,inExtraDataBlock);
  fprintf('\n..saved.\n')
  figure(1000); close;
end
