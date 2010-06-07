% ********** SHOW_BUT.M MATLAB "M" file (Russo/Steege/Patton) *********
% Display fig mouse button props that cause probs with MOVEAXIS.M (for debugging).
%  SYNTAX:	show_but
%  INPUTS:   	-
%  OUTPUTS:	text to matlab command window
%  CALLS:	get
%  VERSIONS:	- patton 1/22/97.
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ Begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~


fprintf('\n  ~ show_but.m m file script ~  '); 
fprintf('  WindowButtonDownFcn=  \t%s', get(gcf,'WindowButtonDownFcn')); pause(.01); 
fprintf('\n                                ');
fprintf('  WindowButtonUpFcn=    \t%s', get(gcf,'WindowButtonUpFcn')); pause(.01); 	
fprintf('\n                                ');
fprintf('  WindowButtonMotionFcn=\t%s', get(gcf,'WindowButtonMotionFcn')); pause(.01); 

fprintf('          ~ END show_but.m  ~ \n'); 

