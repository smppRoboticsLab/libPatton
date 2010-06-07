%************** MATLAB "M" function  *************
% reduce a vector to only unique members, count # of repeatsa
% SYNTAX:     [X,repeat]=distill(x) s
% REVISIONS:  9-9-0 Initated (patton)
% SEE ALSO:   DISTILL2
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function [X,repeat]=distill(x)

% ____ SETUP ____
X=x(1); 
repeat(1)=1;

% ____ SETUP ____
for i=2:length(x)
  for j=1:length(X)
    if x(i)==X(j), 
      repeat(j)=repeat(j)+1; 
      keep=0; 
      break; 
    else; 
      keep=1; 
    end
  end
  if keep, 
    X=[X x(i)]; 
    repeat(length(X))=1;
  end
end


return