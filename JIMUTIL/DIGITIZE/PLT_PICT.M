%______*** MATLAB "M" function (jim Patton) ***_______
% plot a picture (a string of xy points) 
% SYNTAX:	h=plt_pict(pic,type,COLOR,Lwidth)
% INPUTS:	pic	a 3 BY n matrix, each row is a data point,
%			and colums are x, y and drawto:
%				drawto=1 for drawing, 2 for no drawing
%		
%   	 	type	(optional). =1 for lines , =0(default) for shaded polygon
%		COLOR	(optional)  either string or rgb vect default=grey
%		Lwidth	(optional)  width of the the line
% CALLED BY:	and others 
% INITIATIED:	5/20/96 by patton from make_pic.m 
% 		made 'type' variable optional on 2/24/98 patton
% SEE ALSO:	make_pic.m	to digitize a picture
%		bmp_show.m	to load and display a picture in the plot window
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function h=plt_pict(pic,type,COLOR,Lwidth)
fprintf('~ plt_pict.m  funtion (patton) ~');

%____________ SETUP ___________
len=length(pic(:,1));
if ~exist('type'), type=0; end;
if exist('COLOR')~=1, 
  if type==1, COLOR='k'; 
  else       COLOR=[.5 .5 .5]; 
  end;
end
if ~exist('Lwidth'), Lwidth=2; end;

%____________ DRAW ___________
if type  % if draw segmental lines
  for i=2:len,
    if pic(i,3)==1,
      h=plot([pic(i-1,1) pic(i,1)],	...
             [pic(i-1,2) pic(i,2)],	...
             COLOR,'linewidth',Lwidth);
      hold on;
    end %if button...
  end %while(1)
else % if draw shaded polygon 
  h=patch(pic(:,1), pic(:,2),COLOR)
end % if type

fprintf('~ END plt_pic.m ~ ');

