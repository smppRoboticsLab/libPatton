%************** MATLAB "M" function  *************
% Velocity error (chebychev)
% SYNTAX:     
% REVISIONS:  
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function [vErr]=velocityErr(v1,v2,plotIt)
  
  % setup
  if ~exist('plotIt'), plotIt=1; end          % if not passed
 
  % condition
  v1(size(v1,1),:)=[]; v1(1,:)=[];            % clip 1st and last
  v2(size(v2,1),:)=[]; v1(1,:)=[];
  
  rows1=size(v1,1);
  rows2=size(v2,1);  
  
  speed1=sqrt(v1(:,1).^2+v1(:,2).^2);         % calc speed
  speed2=sqrt(v2(:,1).^2+v2(:,2).^2);

  [maxSpeed1,maxSpeed1Fr]=max(speed1);        % find max, not ends
  [maxSpeed2,maxSpeed2Fr]=max(speed2);        % 

  vErr=sqrt((v1(maxSpeed1Fr,1)-            ... %
             v2(maxSpeed2Fr,1))^2+         ... %
            (v1(maxSpeed1Fr,2)-            ... %
             v2(maxSpeed2Fr,2))^2);        ... %

  % Plot this
  if plotIt,
    figNum=gcf; figure(3); clf
    subplot(2,1,1)
    plot((1:rows1)-maxSpeed1Fr,speed1,'r.', ... %
      (1:rows1)-maxSpeed1Fr,speed1,'r',  ... %
      (1:rows2)-maxSpeed2Fr,speed2,'b.', ... %
      (1:rows2)-maxSpeed2Fr,speed2,'b');     %
    title('speed')
    
    subplot(2,1,2)
    plot(v1(:,1),v1(:,2),'r.',              ... %
      v1(:,1),v1(:,2),'r',               ... %
      v2(:,1),v2(:,2),'b.',              ... %
      v2(:,1),v2(:,2),'b',               ... %
      [v1(maxSpeed1Fr,1)                 ... %
        v2(maxSpeed2Fr,1)]                ... %
      ,[v1(maxSpeed1Fr,2)                 ... %
        v2(maxSpeed2Fr,2)],'g');          ... %
      axis equal
    title('velocity vectors')
    drawnow;
    %disp(' hit key.. '); pause
  end
  
return