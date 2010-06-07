
% ~~~~~~~~~~~~~~~~~~~~~~~ M-FILE SCRIPT (PATTON): ~~~~~~~~~~~~~~~~~~~~~~~~
% Limits metafile rendering to a lowest common denominator mode for word, powerpoint
%     Why does importing metafiles into MS Word or PowerPoint result in a graph
%     with a black box over it?
%
% This problem is due to the fact that many graphics packages, to which  MATLAB generated %metafiles may be exported, do not provide the  extensive support of MS-Windows graphics %that is needed to accurately  display MATLAB graphics.  Hence, when importing graphics %into Word,  PowerPoint or other Windows applications, the MATLAB graph can lose  its %color information (i.e. you get a black box over the graph).  As a  workaround, MATLAB %provides a function that limits metafile rendering  to a lowest common denominator mode.
%
% Issue the command:
%
%		 system_dependent(14,'on')
%
% after you have displayed the plot and before copying it to the  metafile.
%
% Please see page 85 of the MATLAB Release Notes for more information.
% INITIATED 4/1/97 Patton
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

system_dependent(14,'on');
fprintf('Figure %d set for pasting! \n', gcf)
