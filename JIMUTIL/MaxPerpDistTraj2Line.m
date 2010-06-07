% MaxPerpDistTraj2Line - calc max perpendic distance, trajectory to a line
% ************** MATLAB "M" function (jim Patton) *************
% estableished by 2 points. The system finds this using a 
% SYNTAX:   [PDvect,Xi]==MaxPerpDistTraj2Line(x,START,END,stopPct,plotIt)
% INPUTS:    x        input trajectory
%            START    startpoint of the line
%            END      endpoint of the line
%            stopPct  (optional) if given, analysis will only consider
%                     points up to a distance equal to this percentage 
%                     of the distance of the start and end points. If this
%                     aguement is not passed (or empty or zero),
%                     analysis will NOT halt and continue to the end If this
%                     aguement is not passed (or empty or zero), no plots.
%            plotIt   (optional) create a graphic plot of the situation. 
% OUTPUTS:   PD       maximum perpendicular distance
%            PDvect   vector representing the distance and direction 
%            Xi       locaion on the line where the maximum occurred
% VERSIONS:  8-11-2004 initiated by patton as PD3D.m 
%            Patton 5-13-5 renamed and revised outputs by refining PD3D.m 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [PD,PDvect,Xi]=MaxPerpDistTraj2Line(x,START,END,stopPct,plotIt);

% SETUP 
prog_name='PD3D.m';                                     % this program's name
% fprintf('\n~ %s ~  ',prog_name)                         % orient user
if ~exist('plotIt')|isempty(plotIt), plotIt=0; end      % if not passed
if ~exist('stopPct')|isempty(stopPct), stopPct=0; end   % if not passed
PD=0;
S=0;
skipSize=3;                                             % SKIP SAMPLES 

SE=END-START;                                           % target diretion se
se=SE/norm(SE);                                         % unit direction

for i=2:skipSize:size(x,1);                                    % B vect of simulaneous eqns A*xi=B
  S=S+norm(x(i,:)-x(i-1,:));                            % path distance
  if stopPct&(S>stopPct*norm(END-START)), break; end;   % halt if gone too far
  Xa=x(i,:);                                            % extract current actual data
  SX=Xa-START;                                          % vect from start 2 actual x
  TDC=dot(SX,se);                                       % target direction component
  xi=START+TDC*se;                                      % intersection along the se vect
  pdVect=Xa-xi;                                         % COMPLEMENT=perpendicular dist
  pDist=norm(pdVect);                                   % Perpendicular distance 
  if pDist>PD,                                          % new winner?
    PD=pDist; 
    PDvect=pdVect;
    Xi=xi;
  end
  
  if plotIt
    fprintf('.')                                        
    plot3([START(1) END(1)],...                         % plot actual datapoints
          [START(2) END(2)],...
          [START(3) END(3)],'r');  
    hold on; axis equal; grid on;
    plot3(START(1),START(2),START(3),'r+');
    plot3(END(1),  END(2),  END(3),  'ro');
    plot3(Xa(1),Xa(2),Xa(3),'kx')
    plot3(xi(1),xi(2),xi(3),'m*')
    plot3([xi(1) xi(1)+pdVect(1)],...
          [xi(2) xi(2)+pdVect(2)],...   
          [xi(3) xi(3)+pdVect(3)],'m')
  end % END if plotIt

end

if plotIt
  plot3([Xi(1) Xi(1)+PDvect(1)],...                           % plot winner 
        [Xi(2) Xi(2)+PDvect(2)],...
        [Xi(3) Xi(3)+PDvect(3)],'m','linewidth',4)
end % END if plotIt



% fprintf('\n~ END %s ~  \n',prog_name)                         % orient use