% simpleArrow: draw an arrow in 2D
%************** MATLAB "M" function  *************
% SYNTAX:     lineSequence=simpleArrow(aStart,aEnd,aColor,aLinewidth)
% INPUTS:     aStart      1 by 2 startpoint
%             aEnd        1 by 2 endpoint
%             aColor      (optional) color spec for plot (enter zero for no plot)
%             aLinewidth  
% REVISIONS:  2/8/2000  (patton) INITIATED
%             9-1-0     RENAMED analysis4.m from fastLearnCurves.m (patton)
%             10/25/00  RENAMED doEnsembles.m
%             4-2-01    UPGRADED doEnsembles2.m
%             6-17-01   allowed what2do input that specifies which phases to plot
%             8-23-05   commenting, added dirs2plot, new input showForces
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function lineSequence=simpleArrow(aStart,aEnd,aColor,aLinewidth)
if ~exist('aColor')|isempty(aColor), aColor='r', end              % if not passed
if ~exist('aLinewidth')|isempty(aLinewidth), aLinewidth=1, end    % if not passed

q=.1;     % length of arrowhead as a fraction of arrow length
c=.08;    % width of arrowhead as a fraction of arrow length
  
v=aEnd-aStart;
if norm(v)==0, return; end
aLength=norm(v);
v1=v/aLength; % unit vect
p1=cross([v 0],[0 0 1]); % unit perpendicular (must make it 3d)
p1(3)=[]; % clip back to 2D
p1=p1/norm(p1);

% points:
aBreak=aStart+(1-q)*aLength*v1;
Lside=aBreak+.5*c*aLength*p1;
Rside=aBreak-.5*c*aLength*p1;

% assemble line Sequence
lineSequence=[aStart  ...
             ;aBreak  ...
             ;Lside   ...
             ;aEnd    ...
             ;Rside   ...
             ;aBreak  ...             
             ];
           
if aColor,             
  plot(lineSequence(:,1),lineSequence(:,2),'color',aColor,'Linewidth',aLinewidth);
end
