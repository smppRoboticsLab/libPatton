function s1 = deblank(s)
%DEBLANK Remove trailing blanks.
%   DEBLANK(S) removes trailing blanks from string S.
%
%   DEBLANK(C), when C is a cell array of strings, removes the trailing
%   blanks from each element of C.

%   L. Shure, 6-17-92.
%   Copyright 1984-2000 The MathWorks, Inc.
%   $Revision: 5.19 $  $Date: 2000/02/25 17:06:09 $

% The cell array implementation is in @cell/deblank.m

if isempty(s)
   s1 = s([]);
else
   if ~isstr(s),
      warning('Input must be a string.')
   end
   
   % Remove trailing blanks
   [r,c] = find( (s~=0) & char(9) & ~isspace(s) );
   if isempty(c),
      s1 = s([]);
   else
      s1 = s(:,1:max(c));
   end
end
