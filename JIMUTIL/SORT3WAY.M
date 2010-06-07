% ************** MATLAB "M" file  (jim Patton) *************
% The following reads a datafile containing results,
% sorts the data into subject categories and by day and force
% level.  it calls a plotting program & dispays all trials data.
% INPUTS:	MAT	 	N by 20 matrix cols 9-20 are data. The 
% (must be			columns of MAT are:
% in memory)			1) 	subject #
%				2) 	mass		(m)
%				3) 	height 		(H)
%				4) 	Day		
%				5) 	Block		
%				6) 	trial
%				7) 	target force 
%				8) 	norm peak force (Fpeak/H/m)
%				9-20)  data to be sorted 
%		header 		12 by N string matrix of header titles
%		name		short string describing the project (<7 char)
% OUTPUTS:	nameav.dat 	means file (where name = variable string)
%		name.ps		post script plot file 
%		nameav.bdp	ascii file for bmdp: 20 40 80 avgs
%		figures 1&2	plots
% CALLS TO:	pltanov8.m	M-function for plotting 12 plots on a page
% CALLED FROM:	non_opt#.m	M file
%				AND OTHERS
% SYNTAX:	sort3way
% SEE:   	c:\jim\matlab 
% INITIATIED: 	10/26/95 jim patton from doanova8.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

fprintf('\n~sort3way.m MATLAB m-file (Patton) {formerly doanova8.m}~\n');
load splat; y=y(1:4:2000); y=([y;flipud(y)]); Fs=Fs/3; sound(y,Fs);

%__________________________ SETUP VARIABLES ________________________
plotfile = name;	figure(1); clg; 	figure(2); orient landscape; clg; 
%%IDs  	= ['AS';'CK';'EV';'GH';'HI';'KM';'MF';'PM';'RP';'YW'];
binmarks= [.15 .25 .35 .45 .55 .65 .75 .85 .95]; marks=length(binmarks);
rows=length(MAT(:,1)); cols=length(MAT(1,:));
MEAN = 999*ones(1, 12*2*(marks+1)+1);	% setup for 12 var
A_1 = zeros(1,marks+1);	A_5 = zeros(1,marks+1);
B_1 = zeros(1,marks+1);	B_5 = zeros(1,marks+1);
C_1 = zeros(1,marks+1);	C_5 = zeros(1,marks+1);
D_1 = zeros(1,marks+1);	D_5 = zeros(1,marks+1);
E_1 = zeros(1,marks+1);	E_5 = zeros(1,marks+1);
F_1 = zeros(1,marks+1);	F_5 = zeros(1,marks+1);
G_1 = zeros(1,marks+1);	G_5 = zeros(1,marks+1);
H_1 = zeros(1,marks+1);	H_5 = zeros(1,marks+1);
I_1 = zeros(1,marks+1);	I_5 = zeros(1,marks+1);
J_1 = zeros(1,marks+1);	J_5 = zeros(1,marks+1);
K_1 = zeros(1,marks+1);	K_5 = zeros(1,marks+1);
L_1 = zeros(1,marks+1);	L_5 = zeros(1,marks+1); 
A_mean = zeros(1,2*marks+1);
B_mean = zeros(1,2*marks+1);
C_mean = zeros(1,2*marks+1);
D_mean = zeros(1,2*marks+1);
E_mean = zeros(1,2*marks+1);
F_mean = zeros(1,2*marks+1);
G_mean = zeros(1,2*marks+1);
H_mean = zeros(1,2*marks+1);
I_mean = zeros(1,2*marks+1);
J_mean = zeros(1,2*marks+1);
K_mean = zeros(1,2*marks+1);
L_mean = zeros(1,2*marks+1);
q=1; 
daynames = str2mat('D1','D5');
forcenames = str2mat('10%','20%','30%','40%','50%','60%','70%','80%','90%','100%');
if ~exist('plot_or_not'),
  if menu2('Plot?','no','yes')-1, 
    plot_or_not='y'; 
  else
    plot_or_not='n'; 
  end  %if menu2...
end  %if ~exist ....
if ~exist('print_or_not'),
  if menu2('Print?','no','yes')-1, 
    print_or_not='y'; 
  else
    print_or_not='n'; 
  end  %if menu2...
end  %if ~exist ....
load splat; y=y(1:1000); 

MAT=cleannan(MAT); 		% DELETE ALL LINES OF DATA WITH NAN ELEMENTS 

%_________________________ SORT DATA % CALC MEANS & STDEV _________________________
for subj=1:length(IDs(:,1)),
  id=IDs(subj,:);
  fprintf('Sorting data Subject... %d (%s). ', subj,id); drawnow; 
  k=zeros(marks+1,2);	% counters of each sorted bin forcmarks by days	
  Q=0; DATA=[]; 

  %___________ find out the max force for this subject ____________
  if day==0, 							% info for VISION
    TXTname=['G:\DHUGAL\EXPERIME\VISION\' id '\' fileid3(lower(id),3,'dv.txt')];	
  else,  							% info for LEARN_2
    TXTname=['c:\jim\lee\learn_2\' id num2str(day) '\' fileid(id,1,3,'dv.txt')];	
  end; %if day==0
  fprintf('\nTo find max force, loading: %s...', TXTname);
  FMCmarks=loadf(TXTname); fprintf('DONE.'); FpMAX=FMCmarks(1,10)
  fprintf('Estimated FpMAX=%fN', FpMAX);

  %___________ sort out 1 subject's data ( => DATA ) ____________
  q=1;
  while q<length(MAT(:,1)), 
    if MAT(q,1)==subj, Q=Q+1; DATA(Q,:)=MAT(q,:); end;
    q=q+1; 
  end; % while q<length(MAT(:,1))

  %___________ sort out day and force for this subject: ____________
  for i = 1:length(DATA),
    pull_pct=DATA(i,8)*DATA(i,3)*DATA(i,2)/FpMAX; % find perct max for this trial		
    if pull_pct<binmarks(1), j=1; loaddata;				% low 
    elseif pull_pct>binmarks(marks), j=marks+1; loaddata;		% hi 
    else 								% mid:		
      for j=2:marks 								 
        if pull_pct<binmarks(j) & pull_pct>binmarks(j-1), loaddata; end;	 
      end % for j								 
    end %if pull_pct<binmarks....					 
  end %for i 

  %__________________________  % calc means & stdev: ________________________
  fprintf('Calc means for this Subject...\n');
  for j = 1:marks+1
	A_mean(j) = mean(A_1(1:k(j,1),j)); 	A_mean(marks+1+j) = mean(A_5(1:k(j,2),j));
	B_mean(j) = mean(B_1(1:k(j,1),j)); 	B_mean(marks+1+j) = mean(B_5(1:k(j,2),j));
	C_mean(j) = mean(C_1(1:k(j,1),j)); 	C_mean(marks+1+j) = mean(C_5(1:k(j,2),j));
	D_mean(j) = mean(D_1(1:k(j,1),j)); 	D_mean(marks+1+j) = mean(D_5(1:k(j,2),j));
	E_mean(j) = mean(E_1(1:k(j,1),j)); 	E_mean(marks+1+j) = mean(E_5(1:k(j,2),j));
	F_mean(j) = mean(F_1(1:k(j,1),j)); 	F_mean(marks+1+j) = mean(F_5(1:k(j,2),j));
	G_mean(j) = mean(G_1(1:k(j,1),j)); 	G_mean(marks+1+j) = mean(G_5(1:k(j,2),j));
	H_mean(j) = mean(H_1(1:k(j,1),j)); 	H_mean(marks+1+j) = mean(H_5(1:k(j,2),j));
	I_mean(j) = mean(I_1(1:k(j,1),j)); 	I_mean(marks+1+j) = mean(I_5(1:k(j,2),j));
	J_mean(j) = mean(J_1(1:k(j,1),j)); 	J_mean(marks+1+j) = mean(J_5(1:k(j,2),j));
	K_mean(j) = mean(K_1(1:k(j,1),j)); 	K_mean(marks+1+j) = mean(K_5(1:k(j,2),j));
	L_mean(j) = mean(L_1(1:k(j,1),j)); 	L_mean(marks+1+j) = mean(L_5(1:k(j,2),j));
  end	 % for j
  MEAN(subj,:) = [	subj,			...
			A_mean,			...
			B_mean,			...
			C_mean,			...
			D_mean,			...
			E_mean,			...
			F_mean,			...
			G_mean,			...
			H_mean,			...
			I_mean,			...
			J_mean,			...
			K_mean,			...
			L_mean			 ];

  fprintf('Calc stdev for this Subject...\n');
  for j = 1:marks+1
	A_stdv(j) = std(A_1(1:k(j,1),j)); 	A_stdv(marks+1+j) = std(A_5(1:k(j,2),j));
	B_stdv(j) = std(B_1(1:k(j,1),j)); 	B_stdv(marks+1+j) = std(B_5(1:k(j,2),j));
	C_stdv(j) = std(C_1(1:k(j,1),j)); 	C_stdv(marks+1+j) = std(C_5(1:k(j,2),j));
	D_stdv(j) = std(D_1(1:k(j,1),j)); 	D_stdv(marks+1+j) = std(D_5(1:k(j,2),j));
	E_stdv(j) = std(E_1(1:k(j,1),j)); 	E_stdv(marks+1+j) = std(E_5(1:k(j,2),j));
	F_stdv(j) = std(F_1(1:k(j,1),j)); 	F_stdv(marks+1+j) = std(F_5(1:k(j,2),j));
	G_stdv(j) = std(G_1(1:k(j,1),j)); 	G_stdv(marks+1+j) = std(G_5(1:k(j,2),j));
	H_stdv(j) = std(H_1(1:k(j,1),j)); 	H_stdv(marks+1+j) = std(H_5(1:k(j,2),j));
	I_stdv(j) = std(I_1(1:k(j,1),j)); 	I_stdv(marks+1+j) = std(I_5(1:k(j,2),j));
	J_stdv(j) = std(J_1(1:k(j,1),j)); 	J_stdv(marks+1+j) = std(J_5(1:k(j,2),j));
	K_stdv(j) = std(K_1(1:k(j,1),j)); 	K_stdv(marks+1+j) = std(K_5(1:k(j,2),j));
	L_stdv(j) = std(L_1(1:k(j,1),j)); 	L_stdv(marks+1+j) = std(L_5(1:k(j,2),j));
  end	 % for j
  STDV(subj,:) = [	subj,			...
			A_stdv,			...
			B_stdv,			...
			C_stdv,			...
			D_stdv,			...
			E_stdv,			...
			F_stdv,			...
			G_stdv,			...
			H_stdv,			...
			I_stdv,			...
			J_stdv,			...
			K_stdv,			...
			L_stdv			 ];
  
  fprintf('Calc 95% confidence intervals for this Subject...\n');
  TOTk= [k(:,1)' k(:,2)']; tinv_95=tinv(.975, TOTk);
  CI95(subj,:) = [	subj,					...
			tinv_95.*A_stdv./ sqrt(TOTk),		...
			tinv_95.*B_stdv./ sqrt(TOTk),		...
			tinv_95.*C_stdv./ sqrt(TOTk),		...
			tinv_95.*D_stdv./ sqrt(TOTk),		...
			tinv_95.*E_stdv./ sqrt(TOTk),		...
			tinv_95.*F_stdv./ sqrt(TOTk),		...
			tinv_95.*G_stdv./ sqrt(TOTk),		...
			tinv_95.*H_stdv./ sqrt(TOTk),		...
			tinv_95.*I_stdv./ sqrt(TOTk),		...
			tinv_95.*J_stdv./ sqrt(TOTk),		...
			tinv_95.*K_stdv./ sqrt(TOTk),		...
			tinv_95.*L_stdv./ sqrt(TOTk)		];
 
  % _______________________________ plot stuff _____________________________
  if plot_or_not=='y',
    fprintf('Plotting...'); fprintf('Subject %2.0f \n',subj); figure(2); clg; 
    clg; for num = 1:12,  subplot(3,4,num); hold;	end % for
    pltanov8(k,A_1,A_5,A_mean,header(9,:), subj,1);
    pltanov8(k,B_1,B_5,B_mean,header(10,:),subj,2);
    pltanov8(k,C_1,C_5,C_mean,header(11,:),subj,3);
    pltanov8(k,D_1,D_5,D_mean,header(12,:),subj,4);
    pltanov8(k,E_1,E_5,E_mean,header(13,:),subj,5);
    pltanov8(k,F_1,F_5,F_mean,header(14,:),subj,6);
    pltanov8(k,G_1,G_5,G_mean,header(15,:),subj,7);
    pltanov8(k,H_1,H_5,H_mean,header(16,:),subj,8);
    pltanov8(k,I_1,I_5,I_mean,header(17,:),subj,9);
    pltanov8(k,J_1,J_5,J_mean,header(18,:),subj,10);
    pltanov8(k,K_1,K_5,K_mean,header(19,:),subj,11);
    pltanov8(k,L_1,L_5,L_mean,header(20,:),subj,12);
    subplot(3,4,1);
     ax=axis; yrange=ax(4)-ax(3); text(ax(2),ax(4)+.2*yrange,[name ' Subj ' IDs(subj,:)]);
    subplot(3,4,11);
     xlabel('(% of estimated maximum force) for day1(o) and day5(X)');
    drawnow; 
  end %if plot_or_not 

  %_______________________ Histogram __________________________
figure(1); subplot(5,2,subj), bar([.05 binmarks].*100+4.7,k(:,1)); hold; 
    bar([.05 binmarks].*100+5.3,k(:,2),'b'); ax=axis; axis([0 110 ax(3) ax(4)]);
    title(['Force histogram: ' IDs(subj,:)]);
  end %if plot_or_not 

  %disp('pause..'); 	pause;
end % for subj ========================================================================
fprintf('DONE SORTING AND CALCULATING.\n');

% _______________________________ save for excel _____________________________
eval(['save ' name 'av.dat MEAN -ascii -double -tabs']); 
disp(['save ' name 'av.dat MEAN -ascii -double -tabs'])
eval(['save ' name 'st.dat STDV -ascii -double -tabs']); 
disp(['save ' name 'st.dat STDV -ascii -double -tabs'])
eval(['save ' name 'ci.dat CI95 -ascii -double -tabs']); 
disp(['save ' name 'ci.dat CI95 -ascii -double -tabs'])

% ________________________________ write header ___________________________
fid=fopen([name 'hd.dat'],'w'); 
fprintf(fid,'%s header:\n',name); fprintf('\n%s header\n',name); 	
for q = 9:20, 
	fprintf(fid,'%s',header(q,:)); fprintf('\n  %s ',header(q,:)); 	
	fprintf(fid,'\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t');
end	% if
fprintf(fid,'\n');	fprintf('\n');		fclose(fid);	

%_______________________ plot 3way (overall) figure_________________
if plot_or_not=='y',
  fprintf('PLOTTING..\n');
  for meas=1:12, 
    figure(2); axis on; clg;
    index = 2+(meas-1)*20
    plt3way(	MEAN(:,index:index+19),			...
		CI95(:,index:index+19),			...
		10,2,10,5,-5,'',daynames,forcenames,[name ' ' header(meas+8,:)]);
    if 0 %menu2('add tick marks for .2, .4 , .8  and dashed line at 1.0?','no','yes')-1, 
      plot([.01 0],[.2 .2], 'b'); 	handle=text(-.005,.2,'.2');
      set(handle,'HorizontalAlignment','Right');
      plot([.01 0],[.4 .4], 'b'); 	handle=text(-.005,.4,'.4');
      set(handle,'HorizontalAlignment','Right');
      plot([.01 0],[.6 .6], 'b'); 	handle=text(-.005,.6,'.6');
      set(handle,'HorizontalAlignment','Right');
      plot([.01 0],[.8 .8], 'b'); 	handle=text(-.005,.8,'.8');
      set(handle,'HorizontalAlignment','Right');
      plot([0 1],[1 1],'k:'); 		handle=text(-.005,1, '1');
      set(handle,'HorizontalAlignment','Right');
    end;  %if menu2('add tick marks for .2, .4 , .8 & dashed line at 1.0?','no','yes')-1, 
    if print_or_not=='y', fprintf('printing! '); pause(10); print -dwin; end;  
  end % for meas
end %if plot_or_not 

% ########################### Package for bmdp progs ###########################
%__________ Original 2-way plus repeated measures anova 20 40 80 _________
av=MEAN; i=1;
bmdp_av	=[av(:,1) av(:,i+2) av(:,i+4) av(:,i+8) av(:,i+12) av(:,i+14) av(:,i+18)];
for i=21:20:12*20-1
  bmdp_av =[bmdp_av av(:,i+2) av(:,i+4) av(:,i+8) av(:,i+12) av(:,i+14) av(:,i+18)];
end % for i
% replace each NaN with -9999 for BMDP code to signify a missing value:
for i=1:length(bmdp_av(:,1)),
  for j=1: length(bmdp_av(1,:)),
    if isnan(bmdp_av(i,j)), bmdp_av(i,j)=-9999; end %if
  end;
end; 
CMDstr=['save ' name 'av.bdp bmdp_av -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 
disp('(Original 2-way plus repeated measures anova 20 40 80)');

%__________ special 1-way plus repeated measures anova 20 40 80 _________
i=1;
bmdp_av	=[av(:,1) av(:,i+12)-av(:,i+2) av(:,i+14)-av(:,i+4) av(:,i+18)-av(:,i+8)];
for i=21:20:12*20-1
  bmdp_av =[bmdp_av av(:,i+12)-av(:,i+2) av(:,i+14)-av(:,i+4) av(:,i+18)-av(:,i+8)];
end % for i
% replace each NaN with -9999 for BMDP code to signify a missing value:
for i=1:length(bmdp_av(:,1)),
  for j=1: length(bmdp_av(1,:)),
    if isnan(bmdp_av(i,j)), bmdp_av(i,j)=-9999; end %if
  end;
end; 
CMDstr=['save ' name '1w.bdp bmdp_av -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 
disp('(special 1-way plus repeated measures anova 20 40 80)');

%__________ special 2-way plus repeated measures anova 20 30 40 50 60 70 80 _________
%__________ NOTE: these are saved as individual files for each measure!     _________
bmdp_av=[av(:,1)]; 		% reset this to have a column of subject numbers
for v=1:12,		% loop for each variable (v) == (measure)
  % loops for each forcebin & day (fd) == (20 total)  
  for fd=2:8,   i=(v-1)*20+fd+1; bmdp_av=[bmdp_av av(:,i)]; end %for fd
  for fd=12:18, i=(v-1)*20+fd+1; bmdp_av=[bmdp_av av(:,i)]; end %for fd
  for i=1:length(bmdp_av(:,1)), % replace NaN with -9999 for BMDP (missing value)
    for j=1: length(bmdp_av(1,:)),
      if isnan(bmdp_av(i,j)), bmdp_av(i,j)=-9999; end %if
    end; %for j
  end; %for i
end %for v
CMDstr=['save ' name '2w.bdp bmdp_av -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 

%__________ matrix of correlation coefficients for all 20 columns (see header) _________
corMAT = corrcoef(MAT);
CMDstr=['save ' name 'cor.dat corMAT -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 

%___ Separate day1 & day5 data ___
countday1=0;
countday5=0;
for i=1:length(MAT),
  if MAT(i,4)==1,
    countday1=countday1+1;
    MAT1(countday1,:)=MAT(i,:);
  else
    countday5=countday5+1;
    MAT5(countday5,:)=MAT(i,:);
  end %if
end; %if

%_____ DAY1 only matrix of correlation coefficients for all 20 columns (see header) ___
corMAT1=corrcoef(MAT1); corMAT5=corrcoef(MAT5);
CMDstr=['save ' name 'cr1.dat corMAT1 -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 
CMDstr=['save ' name 'cr5.dat corMAT5 -ascii -double -tabs']; eval(CMDstr); disp(CMDstr); 

%[y,Fs]=wavread('c:\sndscape\sounds\clinton.wav'); sound(y,Fs);
load splat; y=y(1:4:2000); sound([y flipud(y) y y flipud(y) y],Fs);
disp('*** (END sort3way.m) ***');

