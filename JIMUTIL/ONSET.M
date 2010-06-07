%************** MATLAB M function (Patton) **************
% Determines the onset of a signal (when it begins to change).
% assumes that the input x is at a baseline value for some time, 
% and then departs from it at "frame". It uses 2 criteria: 
%  (1) departure from confidence interval for more than twice the period
%	associated the presumed maximum frequency of the signal (maxfreq) 
%  (2) departure from confidence interval for more than twice the period
%	associated the presumed maximum frequency of the signal (maxfreq) 
% SYNTAX:	frame=onset(x,base,freq,maxfreq,alpha,verbose,plot_or_not);
% INPUTS:	x		time record
%		base		frame numbers defining the baseline for 
%				defining the 95% confidence interval that 
%				"x" departs at "frame", beginning at base(1)
%				& ending at base(2) 
%  		freq		sampling freq (Hz)
%  		maxfreq		maximum presumed freq content of signal (Hz)
%  		alpha		(optional) Statistical level for confidence
%				interval used to detect onset. default=.01. 
%		verbose		(optional) Nonzero for messages  default=0; 
%		plot_or_not 	(optional) ='y' for plots. default='n'
% OUTPUTS:	frame 		frame which initiates departure, determined via:
%				  1: confidence interval
%		 		  2: point of accel zero nearest to end
%  				  3: maximum curvature 
% EXAMPLE:	frame=onset(Fp,[10 30],200,15); 
%		This finds the onset of Fp, a 200 Hz signal, presming that 
%		the maximum freqency content of Fp is 15 hz. it uses data from 
%		frames 10 to 30 to establish a 95% baseline confidence interval.
% CALLS:	
% CALLED BY: 	
% REVISIONS: 	5/21/98 (Patton) initiated from dv.m
%              6/23/98 (Patton) fixed curvaTURE
% NOTES:	* Code is best viewed in MS word, courier new 8pt font
%		* For information on DATAIO (DIO) FORMAT, see Datio_format.doc
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~

function frame=onset(x,base,freq,maxfreq,alpha,verbose,plot_or_not);

%____ SETUP ____
global DEBUGIT                                       % nonzero=debugging
prog_name='onset.m';                                 % this program's name
if ~exist('alpha'), alpha=.99; end;                  % set default if no entry
if ~exist('verbose'), verbose=0; end;                % set default if no entry
if ~exist('plot_or_not'), plot_or_not='n'; end;      % set default if no entry
frame=[1 1 1];                                       % init
frames=length(x);                                    % length of data
t=0:1/freq:frames/freq-.0001; t=t';                  % MAKE TIME VECTOR 
if verbose,                                          % message
  fprintf('\n~ %s ~ ', prog_name);                   % message
  fprintf(' (%d frames of data = %f sec)',       ... % message 
   frames,t(length(t)));                             % message 
end;                                                 % message
order=5;                                             %
cutoff=10;                                           %
critframes=round(1/maxfreq*freq)*2;                  % critical # of consecutive
                                                     % frames beyond the 95%
                                                     % confidence interval for
                                                     % accepting a departure
                                                     % (onset)
if base(2)>frames-critframes,                        % prevent errors
  base(2)=frames-critframes-1; 
elseif base(1)<1, 
  base(1)=1; 
end;                                                 % END prevent errors

%___ CONDITON INPUT (filter & differentiate)___
xdot=vel(freq,x);                                    % DIFF
fxdot=butterx(xdot,freq,order,cutoff);               % filter velocity
xdotdot=vel(freq,xdot);                              % DIFF velocity
xdotfdot=vel(freq,fxdot);                            % DIFF filtered velocity
fxdotdot=butterx(xdotdot,freq,order,cutoff);         % filter accel
fxdotfdot=butterx(xdotfdot,freq,order,cutoff);       % filter the DIFF filt vel 
xdotfdotfdot=vel(freq,fxdotfdot);                    % DIFF filtered accel
%fxdotfdotfdot=butterx(xdotfdotfdot,freq,order,cutoff);% filt the DIFF filt vel 

%_________________________________
%_________ DETECT EVENTS _________
%_________________________________

%__CONFIDENCE INTERVAL ESTABLISHED from BASELINE__
u=xdot;                                              % assign var to scrutinize
basex=u(base(1):base(2));                            % make a baseline vect
N=length(basex);                                     % get its length
basemean=mean(basex);                                % find mean
baseconf=tinv(1-alpha/2,N-1)*std(basex)/sqrt(N);     % 1/2 Conf. interval width
for i=base(2):frames-critframes-1,                   % loop frames past baseline
  if u(i)>basemean+baseconf|u(i)<basemean-baseconf,  % if departed from 95% conf
    nextfew=(u(i:i+critframes)>basemean+baseconf|... % see if next are out too
             u(i:i+critframes)<basemean-baseconf);   % ...
    if all(nextfew), frame(1)=i; break; end          % if all frames also out
  end %END if x(i)
end

%____ MAX ACCEL ____
[max_accel,max_accel_frame]=max(fxdotfdot);          %

%____ MAX normalized curvature ____
nt=t/max(t);                                         % normalized time
nx=x/(max(x)-min(x));                                % normalixe x
nxdot=vel(nt,nx); nxdotdot=vel(nt,nxdot);            % differntiate
curv= (nxdotdot) .* ( (1+nxdot.^2).^(-3/2) );        % Gillett calc book p647
%rho=1./curv;                                        % radius of curvature
fcurv=butterx(curv,freq,order,cutoff);               % filter curvature
[max_curv,i]=max(fcurv(frame(1):frames));             % 
frame(3)=frame(1)+i-1;                               %

%____ ZERO ACCEL ____ 
[max_xdot,i_max_xdot]=max(fxdot);                    %
for i=i_max_xdot-2:-1:frame(1),                      % march back from max veloc
  %i, t(i),
  if fxdotfdot(i)<0, break; end;                     % if accel zero & jerk pos
end                                                  % END for 
if isempty(i),frame(2)=frame(1);else,frame(2)=i;end  % if not found, use other

%________________________________
%_____________ PLOT _____________
%________________________________
if plot_or_not=='y',                                 % if plots 
  bx=[t(base(1)) t(base(1)) t(base(2)) t(base(2))];
  clf

  %___ Plot input value ___
  subplot(4,1,1)                                     %
   plot(t,x);                                        %
   hold on; ax=axis; grid on;                        %
   by=[ax(3) ax(4) ax(4) ax(3)];                     %
   patch(bx,by,[.8 .8 .8]);                          %
   plot(t,x,'linewidth',2);                          %
   axis(ax);
   title('Value for ONSET.M','FontWeight','bold')    %

  %___ Plot 1st time derivative ___
  subplot(4,1,2)                                     %
   plot(t,fxdot)                                     %
   hold on; ax=axis; grid on;                        %
   by=[ax(3) ax(4) ax(4) ax(3)];                     %
   patch(bx,by,[.8 .8 .8]);                          %
   plot(t,xdot,'k.',t,fxdot,'b','linewidth',2)       %
   plot([ax(1) ax(2)],                           ... %
      [basemean-baseconf basemean-baseconf],'r', ... %
      [ax(1) ax(2)],                             ... %
      [basemean+baseconf basemean+baseconf],'r')     %
   axis(ax);
   title('1st time derivative','FontWeight','bold')  %

  %___ Plot 2nd time derivative___
  subplot(4,1,3)                                     %
   plot(t,xdotfdot,'r')                              %
   hold on; ax=axis; grid on;                        %
   by=[ax(3) ax(4) ax(4) ax(3)];                     %
   patch(bx,by,[.8 .8 .8]);                          %
   plot(t,xdotdot,'k.',                          ... %
        t,xdotfdot,'r',                          ... %
        t,fxdotdot,'b',                          ... %
        t,fxdotfdot,'k',                         ... %
        'linewidth',.1)                              %
   axis(ax);
   title('2nd time derivative','FontWeight','bold'); %

  %___ Plot curvature___
   subplot(4,1,4)                                    %
   plot(t,fcurv,'b')                                 %
   %plot(t,rho,'b')                                  %
   hold on; ax=axis; grid on;                        %
   by=[ax(3) ax(4) ax(4) ax(3)];                     %
   patch(bx,by,[.8 .8 .8]);                          %
   plot(t,curv,'k.',t,fcurv,'b','linewidth',2)       %
   %plot(t,rho,'k',t,curv,'b','linewidth',2)         %
   axis(ax);
   title('scaled curvature','FontWeight','bold');    %
        
   %___ mark events on each plot___
   for i=1:4,                                        % loop for each plot
      
    subplot(4,1,i); ax=axis; yr=ax(4)-ax(3);         % get axis
      
    plot([t(frame(1)) t(frame(1))],[ax(3) ax(4)],'b')% plot onset 1
    text(t(frame(1)),ax(3)+.8*yr                 ... %
        ,['1: confidence (' num2str(alpha) '%)'] ... %
        ,'Rotation',45-5*i,'HorizontalAlignment' ... %
        ,'left','VerticalAlignment','top'        ... %
        ,'FontWeight','bold'                     ... %
        ,'Color','b'                             ... %
        ); %
    plot([t(frame(2)) t(frame(2))],[ax(3) ax(4)],'m')% plot onset 2
    text(t(frame(2)),ax(3)+.4*yr                 ... %
        ,' 2: accel zero'                        ... 
        ,'Rotation',45-5*i,'HorizontalAlignment' ... %
        ,'left','VerticalAlignment','top'        ... %
        ,'FontWeight','bold'                     ... %
        ,'Color','m'                             ... %
        ); %

    plot([t(frame(3)) t(frame(3))],[ax(3) ax(4)],'r')% plot onset 2
    text(t(frame(3)),ax(3)+0*yr                  ... %
        ,' 3: max normalized curvature'          ... %
        ,'Rotation',45-5*i,'HorizontalAlignment' ... %
        ,'left','VerticalAlignment','top'        ... %
        ,'FontWeight','bold'                     ... %
        ,'Color','r'                             ... %
        ); %
      
  end                                                % END for i
  
  %___ final Plot things___
  subplot(4,1,1), 
  ax=axis; yr=ax(4)-ax(3); xr=ax(2)-ax(1);           %
  plot(ax(1),ax(4)+.1*yr);ax=axis; yr=ax(4)-ax(3);   %
  patch(ax(1)+xr*[.01 .5  .5 .01],               ... %
        ax(4)-yr*[.01 .01 .3 .3 ],[1 1 0],       ... %
        'EdgeColor','none');                         %
  text(ax(1)+.02*xr,ax(4)-.03*yr,                 ... %
    'LEGEND:','fontsize',7);
  text(ax(1)+.02*xr,ax(4)-.08*yr,                       ... %
    ' grey areas show baseline phase','fontsize',7);
  text(ax(1)+.02*xr,ax(4)-.13*yr,                       ... %
    [' RED horiz. lines show ' num2str(alpha)    ... %
     '% confidence interval'],                    ... %
     'fontsize',7);
  text(ax(1)+.02*xr,ax(4)-.18*yr,                       ... %
   ' Raw signals shown as black dots','fontsize',7);
  text(ax(1)+.02*xr,ax(4)-.23*yr,                       ... %
   ' Filtered signals shown as curves','fontsize',7);
   
  subplot(4,1,4), title('seconds')
  
  %suptitle('onset.m results')                       % big title
 
end                                                  % END if plots

%____ ALL DONE ____
if verbose, fprintf(' ~ END %s ~ \n', prog_name); end% message at end 
return;


if verbose,fprintf(' blah..');end                    % message 
if verbose, fprintf(' Done. '); pause(.01); end;     % message

