%______*** MATLAB "M" function (jim Patton) ***_______
% counterclockwise rotation of an object (vector or matrix)
% SYNTAX:     Y=rot2d(X,q);
% INPUTS :    X       input object. if X is a vector, then a  
%                     vector rotation occurs. if X is a matrix,   
%                     then a matrix rotation occurs. 
%             q       amount to be rotated (counterclockwise)
% OUTPUTS:    Y       rotated object
% VERSIONS:   3/3/99  INITIATED  by jim patton
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function Y=rot2d(X,q);

[rows,cols]=size(X);               % get sizes

T=[cos(q) sin(q); -sin(q) cos(q)]; % transformation mtrix

if cols==rows,     Y=T'*X*T;
elseif rows>cols,  Y=T*X; 
else               Y=X*T;  
end

