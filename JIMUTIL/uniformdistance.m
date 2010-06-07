%************** MATLAB "M" function (Patton) *************
% make a time record evenly spaced in space instead of time.
% SYNTAX:      OUT=uniformDistance(IN,spacing,verbose);
% INPUTS:      IN       tracetory is a nxm of [time xpos ypos...]
%              spacing  distance between output points
%              verbose  
% OUTPUTS:     OUT      tracetory is a nxm of [time xpos ypos ...]
% REVISIONS:	 2/7/2000  Initiated by patton
%              2/08/2006 revised to handle n-dimensional input
%~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~

function OUT=uniformDistance(IN,spacing,verbose);

if ~exist('spacing'), spacing=.005; end     % default is half a cm

INdim=size(IN,2); % find out the dimension of the input trajectory

% ___ generate a path (s) distance ___
D=diff(IN(:,2:INdim))+.000001;                         % .000001 is for ideal tra-
                                            % jectories that have no change
s(1)=0;
for i=1:size(IN,1)-1,
  s(i+1)=s(i)+sqrt(sum(D(i,:).^2));
end

% ____ interpolate ____ 
OUT=interp1(s,IN,0:spacing:max(s));

return