% editParameters_showElements: display list of paramters and thier values
%% ************** MATLAB "M" script  (jim Patton) *************
% This is called by editParameters.m only - see that function
%  SYNTAX:  
%  INPUTS:  
%  OUTPUTS:	
%  INITIATIED:	 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function editParameters_showElements()
global elements

for i=1:length(elements)
%   fprintf('\n%s=  %s',element(i).name, get(elements(i).hdl))
  fprintf('\n%s=  %s',elements(i).name,get(elements(i).hdl,'string'))
end
fprintf('\n\n')