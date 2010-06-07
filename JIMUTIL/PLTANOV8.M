% ************** MATLAB "M" file  (jim Patton) *************
% The following plots results of doanova2.m
%
% 	INPUTS:		
% 	OUTPUTS:
%
% initiatied 29-march-1995 by jim patton 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function pltanova8(k,var1,var5,means,titletext,subj,num);


IDs  = ['AS';	'CK';	'EV';	'GH';	'HI';	'KM';	'MF';	'PM';	'RP';	'YW'];
fprintf('*pltanov8.m*');

eps = 2; % distance from 'center point for bin' for plot
bins = length(k);

subplot(3,4,num),
for bin = 1:length(k),
  plot(	 (-eps+bin*10)*ones(k(bin,1),1), 	var1(1:k(bin,1),bin),  	'r.'	...
	,(-eps+bin*10), 				means(bin),		'ko'	...
	,( eps+bin*10)*ones(k(bin,2),1), 	var5(1:k(bin,2),bin),  	'r.'	...
	,( eps+bin*10), 				means(bin+bins),	'kx'	...
	,[0 100],				[0 0],				'k'	...
	,[(-eps+bin*10) ( eps+bin*10)],  [means(bin) means(bin+bins)],	'k'	);
end  % for

ax=axis; axis([0 105 ax(3) ax(4)]);
title(titletext);

