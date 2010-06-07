% ************** MATLAB "M" function  (jim Patton) *************
% Plot 1 or 2 wingsets and central marks as a learning curve of data. 
% The variables will specify the center and wings of each trial.
% plots wigset 1 followed by wingset 2.
%  SYNTAX:	lrn_wing(name,tpb,MTX);
%  INPUTS:	name  		name of analysis (for title)
%		tpb		# trials per block
%              MTX 		coluns of data each row a trial, each colum is:
%				1  block number
%          	    	    	2  trial number
%				3  wingset 1 center marker diameter (about 0-1)
%				4  wingset 1 central mark location 
%				5  wingset 1 high for wings
%				6   wingset 1 low  for wings 
%				7  (optional) wingset 2 center marker diameter (about 0-1)
%				8  (optional) wingset 2 central mark location 
%				9  (optional) wingset 2 high for wings
%				10 (optional) wingset 2 low  for wings 
%  OUTPUTS:	plot
%  CALLS:	
%  NOTE: 			
%  INITIATIED:	2/28/97 	jim patton from lrn_crv3
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function lrn_wing(name,tpb,MTX);

% _____SETUPS_____
len=length(MTX(:,1));							% NUMBER OF RECORDS
fprintf(' ~ lrn_wing.m: Plot learn curves (%d records) ~ \n',len);	% DISPLAY

% _____LOOP FOR EACH TRIAL_____
for q=1:len,
  Xpos= (MTX(q,1)-1)*tpb+ MTX(q,2);					% LOCATE PLOT XPOINT
  plot([Xpos Xpos],[MTX(q,5) MTX(q,6)], 'color','y',	... 		% PLOT WINGS 1
	'linewidth',4);						% ...
  hold on								% hold plot
  plot(Xpos, MTX(q,4),'b.','color',[0 1 0],	          	...	% PLOT CENTER 1
     'markersize',(.3+MTX(q,3))*25);					% ...
  if length(MTX(1,:))>7,
    fprintf('.');							% DISPLAY
    plot([Xpos Xpos],[MTX(q,9) MTX(q,10)],'b');			% PLOT WINGS 2
    plot(Xpos, MTX(q,8),'b.','color',[0 0 1],          	...	% PLOT CENTER 2
     'markersize',(.3+MTX(q,7))*25);					% ...
  end %if size(MTX(1,:)>7,
  title(name,'fontsize',7); 						% TITLE
  if q/20==round(q/20) drawnow; end %if q==				% UPDATE PERIODICALLY
end %for q								%

fprintf('\n ~ END lrn_wing.m  ~ \n\n');

