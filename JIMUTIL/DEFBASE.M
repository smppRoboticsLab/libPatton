%************** MATLAB M function (Patton) **************
% Defines baseline from time BE(1) s to time BE(2) s. plots, see help
% Plots pulling force, CMap, and CMv (contained in matrix M) and the 
% default baseline (from 0.2 s to 0.7 s). If the user approves the 
% default baseline, the default values are returned. If the user does 
% not approve, a baseline is selected by manual placement of the cursor.
% SYNTAX: 	[BEtime,BEframes]=DEFBASE(M,sfreq,time,tofilter)
% INPUTS:	M		[pulling force, CMap, and CMv] or any 3 time recs.
%		sfreq		sampling frequency	
%		time		time vector
%		tofilter	nonzero if you want to filter the signals first
% OUTPUTS:	BEtime 		times where the baseline began or ended
%		BEframes 	frames where the baseline began or ended
% REVISIONS:	5 November 1993 updated by A. Russo
% 		5/7/98 (patton) replaced clg w/clf, & switched menua to menu.
% 		5/11/98 (patton) revised header remarks & mouse selection button
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function BE=defbase(M,sfreq,time,tofilter)

%____ SETUP ____
global DEBUGIT                                       % nonzero=debugging
prog_name='dv.m';                                    % this program's name

%___ FILTER____
if tofilter, fprintf(' filtering ..\n');
	M(:,1)=butterx(M(:,1),sfreq,2,10);
end

%___ CONDITION & MEASURES ____
M=dtrend(M);
minall=min(min(M(:,2:3)));
maxall=max(max(M(:,2:3)));
yline=[minall maxall];

% ___DEFAULT CURSOR PLACEMENT (S)___
BE=[0.2 0.7]';
%begin after BE(1) s; end after BE(2) ms
bline=[BE(1) BE(1)];
eline=[BE(2) BE(2)];

% ___PLOT  FP, CMX, CMY WITH BASELINES MARKED___
polygonx =[bline fliplr(eline)]; polygony=[yline fliplr(yline)]; 
patch(polygonx,polygony,[.9 .9 .9]); hold on;
plot(time,M(:,1),'m-',time,M(:,2),'r--',time,M(:,3),'r:',bline,yline,'g:')
line(eline,yline,'erasemode','xor') %end baseline line
axis([0 4 minall maxall])
title('Baseline interval (gray)')
		
% ___VERIFY IF OK & CHANGE IF NOT___
k=menu('BASELINE','okay','place off cursor');
if k==1
	waiting=0;
elseif k==2
   title('BASELINE: click mouse: left sets baseline end, right to go on');
	waitingmouse=1;
	while waitingmouse
		[x y zmouse]=ginput(1);
		if zmouse==1
			line(eline,yline,'erasemode','xor')         % erase old line
			BE(2)=round(x*sfreq)/sfreq;                 % new position snapped to 
			eline=[BE(2) BE(2)];                        %
			line(eline,yline,'erasemode','xor')         %draw new line
		elseif zmouse==3 | zmouse==2                   % ctr or right mouse button
			waitingmouse=0;                             %
		end                                            %if zmouse=
	end                                               %while waitingmouse
end                                                  %if k

% ___DISPLAY OUTPUTS___
fprintf('\n ~ END %s ~ \n ', prog_name);             % message
fprintf('start baseline %6.2f s\n',BE(1))
fprintf('  end baseline %6.2f s\n',BE(2))
fprintf('\n')
