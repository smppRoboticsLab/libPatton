% ************** MATLAB "M" function  (jim Patton) *************
% plots data for repeated measures 2 way statistical designs.
% Input file is in the following format:
%	rows are subject
%	colums are sorted by:
%	 	subject number is 1st column
%		class1 columns (typiclly force)
%		class2 columns (typically day/vision/adaptation)
%		class3 columns (typically measures <usually 12>)
%  SYNTAX:	plt_bmdp(name,n1,n2,n3,names1,names2,names3, ...
%                       subjectlines,subj95wings,indivplot,plot_type,fsz)
%  INPUTS:	name 		string (<6chars) resident in memory
%		n1		# of conditions for class 1 (typically force)
%		n2		# of conditions for class 2 (typically day/vision)
%		n3		# of conditions for class 3 (typically measure)
%		names1		list of names(typically force)
%		names2    	list of names(typically day/vision)
%		names3		list of names (typically measures)
%		subjectlines	(optional) nonzero for individual subject lines
%				   DEFAULT=1
%		subj95wings	(optional) nonzero for subject average wings
%				   DEFAULT=1
%		indivplot	(optional) you want only this variable #'s results 
%				   DEFAULT=0
%		plot_type	(optional) indicates this type#, where #
%				   =1 for measure vs class 1 (typically force)
%				   =2 for measure vs class 1 class 2 (3d plot)
%				   =3 for measure vs class 2 (typically DAY)
%				   DEFAULT=1
%		fsz 		(optional) font size specification. 
%				  DEFAULT=6
%  OUTPUTS:	
%  CALLS:	spacecol.m
%  REVISIONS:	initiated 7/29/97 by patton.
%		10/2/97 revised load command for matlab 5
%  NOTES: 	[H,D]=hdrload(name);
%		names3=parse(H(length(H(:,1)),:));
%		names3(1:6,:)=[];
%		names2=str2mat('early','late');
%		names1=str2mat('10-30%','30-50%','65-95%');
% 			or
%		names1=str2mat('15-25%','25-35%','35-45%','45-55%',...
%		  '55-65%','65-75%','75-85%')
%		names2=str2mat('Day1','Day5');
% 			or
%		names1=str2mat('25-45%''55-75%')
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function plt_bmdp(name,n1,n2,n3,names1,names2,names3, ...
                  subjectlines,subj95wings,indivplot,plot_type,fsz)

fprintf(['\n ~ plt_bmdp.m function (patton) ~']); pause(.01);
%n1, n2, n3
%names1, names2, names3

% ___ SET ___
if ~exist('subjectlines'), subjectlines=1;  end;	% create if not input
if ~exist('subj95wings'),  subj95wings=1;   end;	% create if not input
if ~exist('indivplot'),    indivplot=0;     end;	% create if not input 
if ~exist('plot_type'),    plot_type=1;     end;	% create if not input 
if ~exist('fsz'),          fsz=6;           end;	% create if not input 
if plot_type>5, plot_type=1; end;			% reset if input wrong
s1=1;							% space btwn day levels
s2=s1*4;						% space btwn force levels
BLW=1.5;						% big line width
colors2='gbkrcmy';					% plot colors
if ~indivplot,						% if no single plot
  clg; put_fig(gcf,.55,.1,.4,.8); title('wait...')	% set plot window
  start_measure=1; end_measure=n3;			% set for loop for all
else							% if single plot
  start_measure=indivplot; end_measure=indivplot;	% set for single loop 
end %if indivplot 					% end if indivplot 


% ___ LOAD BMDP FILE___
fprintf('loading %s.bdp..',name); pause(.01);	% message
[junk,D]=hdrload([name '.bdp']);			% load
[rows,cols]=size(D);					% find size
for row=1:rows						% loop for ea subject (row)
  for col=1:cols					% loop for ea column
    if D(row,col)==-9999, D(row,col)=NaN; end	% replace -9999 w/NaN's
  end %for row 					% end for row 
end %for col 						% end for col 
fprintf(' DONE. '); pause(.01);			% message

% ___ PROCESS/READY THE DATA___
for i=1:rows,						% make color assignments
  [colors(i,1),colors(i,2),colors(i,3)]=	...	% set colors evenly spaced
    spacecol(i,rows,.2,.95); 				% in the color domain
end; %for i						% end for i

%__________________
%__________________
% ___ PLOTTING ____					% BEGIN PLOTTING
%__________________
%__________________
fprintf(' Plotting..'); pause(.01);

for i3=start_measure:end_measure 			% LOOP FOR MEASURE===	
  if ~indivplot, subplot(4,3,i3); end;		% if all plots make subplot
  measure_pointer=2+(i3-1)*n1*n2;			% point to 1st col for meas
  Q=D(:,measure_pointer:measure_pointer+n2*n1-1);	% submatrx for this meas
  Qmean=mean(Q);					%
  Qstderr=std(Q)/sqrt(rows);				%
  Qconf95=tinv(1-.05/2,10).*Qstderr;			% alpha=.05 (notes7/29/97)

  if plot_type==1 | plot_type==2 
    % ==== PLOT TYPE 1: ==========================	%==========================
    % ==== 2D MEASURES VS FORCE WITH DAY LINES ===	%==========================
    % ___ INDIVIDUAL SUBJRECT BINNED-AVERAGE LINES ___
    if subjectlines, 
      for row=1:rows %SUBJECT==			%
        for i1=1:n1  %FORCE===			%
          x=[]; y=[];					% init 
          for i2=1:n2  %DAY===			%
            x=[x i1*s2+(i2-1-(n2-1)/2)*s1];		% add an x position
            pointer=(i2-1)*n1+i1;			% point to location in Q
            y=[y Q(row,pointer)]; 			% add an y position 
          end  %for i2 (DAY===) 			% end  for i2 (DAY===)
          plot(x,y,'color',colors(row,:)); hold on;	%
        end; %for i1 (FORCE===)			%
      end %for row SUBJECT===				%
    end %if subjectlines				%

    % ___ BOLD OVERALL DAY LINES & WINGS ___
    for i2=1:n2	%DAY===				%
      x=[]; x1=[]; y=[]; yhi=[]; ylo=[]; y1=[];	% init
      for i1=1:n1 %FORCE===				%
        xx=i1*s2+(i2-1-(n2-1)/2)*s1;			% find horiz location in Q
        x=[x xx xx NaN]; 				% add to vect w/NaN spacer
        x1=[x1 xx];					% add to vect
        pointer=(i2-1)*n1+i1;				% point to location
        ymean=Qmean(pointer);				%	
        yplus  =ymean+Qconf95(pointer);		%
        yminus =ymean-Qconf95(pointer);		%
        y  =[y   ymean ymean  NaN]; 			% add to vect w/NaN spacer
        yhi=[yhi ymean yplus  NaN]; 			% add to vect w/NaN spacer
        ylo=[ylo ymean yminus NaN]; 			% add to vect w/NaN spacer
        y1 =[y1 ymean];
        plot(x,y,[colors2(i2) 'o'],		...	% MEANS as points
             'markersize',3,'linewidth',BLW);	%
        hold on;					%
          set(gca,'XTick',[]); set(gca,'box','off');	%
        plot(x1,y1,colors2(i2),		...	% MEANS as lines
             'markersize',3,'linewidth',BLW);	%
        if subj95wings 
          plot(x,yhi,colors2(i2),		...	% WINGS for high 
             'linewidth',BLW);			%
          plot(x,ylo,colors2(i2),		...	% WINGS for high 
             'linewidth',BLW);			%
        end %if subj95wings 				%
      end; %for i1 %FORCE===				%
    end %for i2 %DAY===				%
    axs(i3,:)=axis;

    % ___ LEGEND FOR BOLD OVERALL DAY LINES & WINGS ___
    set(gca,'fontsize',fsz);				% shrink fonts
    ax=axis; xrange=ax(2)-ax(1); yrange=ax(4)-ax(3);	% get axis characteristics
    for i2=1:n2	%DAY===				%
      x=ax(1)+.1*xrange;				% legend location
      y=ax(4)-i2*.05*yrange;				% legend location
      plot([x-.01*xrange x],[y y],		...	% sample line for legend 
        colors2(i2),'linewidth',BLW);			% ...
      text(x,y,[' ' names2(i2,:)],'fontsize',fsz);	% legend for wings
    end %for i2 %DAY===				%

    %___ X AXIS LABELS ___
    ax=axis; xrange=ax(2)-ax(1); yrange=ax(4)-ax(3);	% get axis characteristics
    for i1=1:n1 %FORCE===				%
      text(i1*s2,ax(3),			...	% x axis labels
             [names1(i1,:) ' '], 'fontsize',fsz,...	% ...
             'HorizontalAlignment','right',	...	% ...
             'rotation',90)				% ...
    end; %for i1 %FORCE===				%

    title(names3(i3,:),'fontsize',fsz)			% subplot title
    set(gca,'fontsize',fsz);				% shrink fonts
  end %if plot_type,
  
  if plot_type==2,
    % ==== PLOT TYPE 2: =================		%==========================
    % === 3D FIGURE OVERALL DAY LINES ===		%==========================
    % ___ points___
    for i2=1:n2	%DAY===				%
      for i1=1:n1 %FORCE===				%
        x=i2; y=i1;					%
        pointer=(i2-1)*n1+i1;				% point to location
        z=Qmean(pointer);				%	
        plot3(x,y,z,[colors2(i2) 'o'],	...	% MEANS as points
             'markersize',3,'linewidth',BLW);	%
        hold on;					%
      end; %for i1 %FORCE===				%
    end %for i2 %DAY===				%
    ax=axis;

    % ___ vert lines ___
    for i2=1:n2	%DAY===				%
      for i1=1:n1 %FORCE===				%
        x=i2; y=i1;					%
        pointer=(i2-1)*n1+i1;				% point to location
        z=Qmean(pointer);				%
        plot3([x x],[y y],[z axs(i3,3)],'k-',  ...	% MEANS as vert line
             'markersize',3,'linewidth',BLW);	%
      end; %for i1 %FORCE===				%
      newaxis=[.5 n2+.5 ax(3:4) axs(i3,3:4)];	%
      axis(newaxis);					%
      grid on;						%
    end %for i2 %DAY===				%

    ylabel('force','fontsize',fsz);			%
    xlabel('day','fontsize',fsz);			%	
    title(names3(i3,:),'fontsize',fsz)			% subplot title
    set(gca,'fontsize',fsz);				% shrink fonts
    view(20,40);

  elseif plot_type==3,
    disp('PLOT TYPE 3')
    % === PLOT TYPE 3: ==========================	%==========================
    % === 2D MEASURES VS DAY WITH FORCE LINES ===	%==========================
    for i1=1:n1 %FORCE===				% force loop
      x=[]; y=[];					% init
      for i2=1:n2,					% day loop
        pointer=(i2-1)*n1+i1;
        x=[x i2];	y=[y Qmean(pointer)];		% 
      end; % for i2					%
      greyshade=(n1-i1)/n1*ones(1,3)*.8;		% even distrib of shades
      plot(x,y,'linewidth',i1,'color',greyshade);	% MEANS as points
      hold on;						%
    end; %for i1 %FORCE===				%
    ax=axis; axis([.5 n2+.5 ax(3) ax(4)]);		%
    xlabel('day','fontsize',fsz);			%	
    title(names3(i3,:),'fontsize',fsz)			% subplot title
    set(gca,'XTick',[]); set(gca,'box','off');	%
    set(gca,'fontsize',fsz);				% shrink fonts


  elseif plot_type==4,
    % === PLOT TYPE 4: ==========================	%==========================
    % === BAR CHART OF CHANGES ==================	%==========================
    if n2>2, 						%
      fprintf(['\nNO changeplots - %d levels\n'],n2)	%
    else						%
      dQ=Q(:,n1+1:2*n1)-Q(:,1:n1); dQm=mean(dQ);	% find change 
      bar(dQm);					% plot a bar chart
      %ax=axis; axis([.5 n2+.5 ax(3) ax(4)]);	%
      %xlabel('force','fontsize',fsz);			%	
      title(names3(i3,:),'fontsize',fsz)		% subplot title
      set(gca,'XTick',[]); set(gca,'box','off');	%
      set(gca,'fontsize',fsz);				% shrink fonts
    end

    %___ X AXIS LABELS ___
    ax=axis; xrange=ax(2)-ax(1); yrange=ax(4)-ax(3);	% get axis characteristics
    for i1=1:n1 %FORCE===				%
      text(i1,ax(3),			...		% x axis labels
             [names1(i1,:) ' '], 'fontsize',fsz,...	% ...
             'HorizontalAlignment','right',	...	% ...
             'rotation',90)				% ...
    end; %for i1 %FORCE===				%

  elseif plot_type==5,
    % === PLOT TYPE 5: ==========================	%==========================
    % === BARCHART ==============================
    barMtx=[];
    for i2=1:n2 %DAY===				%
        pointer=(i2-1)*n1+1;				% point to day start
        barMtx=[barMtx;Qmean(pointer:pointer+n1-1)];	%	
    end %for i2 %DAY===				%
    multibar(barMtx,1,9,2,names1,[1 1 1;0 0 0]);	%
    %ax=axis; axis([.5 n2+.5 ax(3) ax(4)]);		%
    %xlabel('force','fontsize',fsz);			%	
    %title(names3(i3,:),'fontsize',fsz)			% subplot title
    %set(gca,'XTick',[]); set(gca,'box','off');	%
    %set(gca,'fontsize',fsz);				% shrink fonts
    disp(' pause..  '); pause
  end %if plot_type					% end if plot_type 

end; %for i3						% end for i3

if ~indivplot,						% if no single plot
  suptitle(['results from ' name]);			% overall page title
end % if ~indivplot,					% end if ~indivplot	

fprintf(' DONE. '); pause(.01);

%C=['print -dpsc2 ' name]; eval(C); fprintf('%s',C);	% color post script file

fprintf(['  ~ plt_bmdp.m  DONE. ~ \n']);

