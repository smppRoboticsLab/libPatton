%************** MATLAB "M" function  *************
% reduce a matrix to only unique rows, count # of occrrences
% SYNTAX:     [X,repeat]=distill(x) s
% REVISIONS:  10-16-3 revised for matrixes from distil 
%             9-9-0 Initated (patton)
% SEE ALSO:   DISTILL
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function [X,repeat]=distill(x)

% ____ SETUP ____
X=x(1,:); 
repeat(1)=1;

% ____ SETUP ____
for i=2:size(x,1)
  for j=1:size(X,1)
    if ~sum(x(i,:)~=X(j,:)), % if a repeat
      repeat(j)=repeat(j)+1; 
      keep=0; 
      break; 
    else; 
      keep=1; 
    end
  end
  if keep, 
    X=[X; x(i,:)];
    repeat(size(X,1))=1;
  end
end


return