% function [r g b]=spacecol(n, nmax, clow, chigh);
% makes an r g b vector for the nth element of nmax such that all elements end up equispatially arranged in rgb space
%
%     Spacecol.m assigns a colour to the 
% ith member of a set of size N, such that
% the colours assigned to all members of 
% the set are dispersed as much as possible
% throughout the available colour space. 
%     The size of the colour space can be
% restricted using the last two arguments.
% So that, for example, the colours assigned
% can be restricted to the darker region of
% colour space, suitable for plotting on 
% white paper or a white background figure.
%   
% EXAMPLE: spacecol(subj, no_of_subjs, 0, 0.3);
%
% INPUTS:  n     - what number in the set is this member
%          nmax  - how many in the set
%          clow  - what is the lowest level an rgb component should take
%          chigh - what is the highest level an rbg component should take
%
% OUTPUTS: r g b vector for the nth element of nmax such that all elements
%          end up equispatially arranged in rgb space
%
% spacecol.m                 Dhugal F. Bedford              March, 1997 


function [r, g, b]=spacecol(n, nmax, clow, chigh);

spin=0.3;


%~~~~~~~ begin ~~~~~~~~
clength=chigh-clow;       % lenght is upper limit minus lower limit
cincr=clength/(((nmax)^(1/3))); % cincr is the component increment

% intialise r g b values
r=clow-cincr+(spin*cincr);
g=clow+(spin*cincr);
b=clow+(spin*cincr);

% loop until r g b values are correct
for ispacecol=1:n
 r=r+cincr;
 if r>chigh
  	r=clow+(r-chigh);
  	g=g+cincr;
  	if g>chigh;
   		g=clow+(g-chigh);
   		b=b+cincr;
  	end % if g
  end % if r
end % for ispacecol


% trap any too large values
if r>chigh
 r=clow+(r-chigh);
end

if g>chigh
 g=clow+(g-chigh);
end

if b>chigh
 b=clow+(b-chigh);
end
return;

%~~~~~~~the end~~~~~~~~


