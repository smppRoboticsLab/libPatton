%______*** MATLAB "M" function (jim Patton) ***_______
% make a picture of the pull based on segments geometriy files and angle data
% INPUTS:	shadow		=1	draw segments as shadows [default]
%				=0 	draw segments as outlines
% 		color 		RGB color or plot string for the drawing
%		segang 		segment angles in this order: foot, shank, thigh, 
%				pelvis, trunk, humerus, forearm, hand, head
%		seglen		segment lengths in this order: foot, shank, thigh, 
%				pelvis, trunk, humerus, forearm, hand, head
%		obesity		normalized segment width
%   -These ASCII datafiles MUST BE PRESENT OR IN THE SEARCH PATH:
%		FOOT.DAT
% 		SHANK.DAT
%		THIGH.DAT
%		PELVIS.DAT
%		TRUNK.DAT
%		HUMERUS.DAT
%		FOREARM.DAT
%		HAND.DAT
% 		HEAD.DAT					
% OUTPUTS: 	figure
% CALLS : 	
% CALLED BY:	?
% INITIATIED:	5/20/96 by patton from nothing
% SYNTAX:	draw_man(shadow,color,segang,seglen,obesity);
% SEE:		\jim\matlab (or the \jim\matlab\devel subdirectory)
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function h=draw_man(shadow,color,segang,seglen,obesity);
fprintf('\n~ draw_man.m  funtion (patton) ~');

%____________ SET VARIABLES ___________
oB		= 1;				% obesity scale factor
% the following defaults are from fr. winter,'90, and are in the following order
%          foot     shank    thigh     pelv     trunk   humerus   forearm   hand   head
if(nargin <5)
  H		= 1.78; 			% default body height
  fprintf('\nSettng default obesity. ');
  obesity=[.04*oB*H .04*oB*H .07*oB*H .11*oB*H .11*oB*H .05*oB*H .03*oB*H 		...
		.02*oB*H .12*oB*H];
end; %if(nargin == ... 
if(nargin<4)
  fprintf('\nSettng default seglen. ');
  seglen=[.039*H   .246*H   .245*H    .040*H   .340*H   .186*H   .146*H   .060*H  .069  ];
end; %if(nargin == ... 
if(nargin<3)
  fprintf('\nSettng default segang. ');
  segang=[  0        0       0          0        0       -3       -pi/2    -pi/2     0  ];
end; %if(nargin == ... 
if(nargin<2)
  fprintf('\n Drawing in default color (grey). ');
  color =[.5 .5 .5];
end; %if(nargin == ... 
if(nargin<1)
  fprintf('\n Drawing in default "shadow" style. ');
  shadow=1;
end; %if(nargin == ... 
if(nargin>5)
  fprintf('\n Too many input arguements\n. '); return;
end; %if(nargin >...
prox	=[0 -seglen(1)];  	% initialize loaction of the proximal end of previous seg
prox_tmp=[0 0]; 
jointpt	=[];
seg_name=str2mat(	'foot',			...	% 1
			'shank',		...	% 2
			'thigh',		...	% 3
			'pelvis',	 	...	% 4
			'trunk',		...	% 5
			'humerus',		...	% 6
			'forearm',		...	% 7
			'hand');		...	% 8
seg_name =str2mat(seg_name,			...	% continue...
			'head');		...	% 9

%____________ LOOP to Scale segments ___________
ax=axis; hold on;
for i=1:9,
  %fprintf('\n%s, ang=%f length=%f', deblank(seg_name(i,:)) , segang(i), seglen(i) )
  eval(['SEG=loadf(' setstr(39) deblank(seg_name(i,:)) '.dat' setstr(39) ');']); % load 
  if SEG==-1, 
    fprintf('\nCant load file %s\n',[deblank(seg_name(i,:)) '.dat']); return; 
  end %if 

  % __TRANSFORM SEGMENTS__
  rot=[	 cos(segang(i)) sin(segang(i)); 	... 			% set rot matrix
 	-sin(segang(i)) cos(segang(i))];				% set rot matrix
  SEG=[-obesity(i)*SEG(:,1) seglen(i)*SEG(:,2)];  			% scale&clip3rd column
  prox_tmp=[0 seglen(i)]; 						% proximal position
  if i==5, 								% special for trunk
    prox_hd=[0 1.2*seglen(i)];					% store neck position 
    prox_hd=(rot*prox_hd')'; 						% rotate neck pos
    prox_hd=prox_hd+prox; 						% translate neck pos 
  end %if								% end if	
  if i==9, 								% special for head
    prox=prox_hd;							% recall neck position 
  end %if								% end if 
  SEG=(rot*SEG')';  prox_tmp=(rot*prox_tmp')';			% rotate
  SEG(:,1)=SEG(:,1)+prox(1); SEG(:,2)=SEG(:,2)+prox(2);		% translate
  prox_tmp=prox_tmp+prox; 						% translate

  % __PLOT__
  if shadow,
    patch(SEG(:,1),SEG(:,2), color,'edgecolor','none');		% plot polygon
  else
    plot(SEG(:,1),SEG(:,2), color);
  end %if shadow

  %__set for nxt__
  prox=prox_tmp;							
  jointpt=[jointpt;prox];  						% collect joint pos
end %for I

for i=1:9,
  plot(jointpt(:,1), jointpt(:,2),'bo', 'markersize',3);		% plot joint points
end %for i

fprintf('\n~ END drawman.m ~\n');

