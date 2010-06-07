% ************** MATLAB "M" function  (jim Patton) *************
% analyze the COP data for the pilot.
%  SYNTAX:	DATA=cop_anal(ID,Nblocks,Ntrials,fp2heel,lf,a,mass,height)
%  INPUTS:	ID  		rootfilename (subject ID)
%		Nblocks 	number of blocks
%		Ntrials 	number of trials per block
%		fp2heel 	heel to back of FP
%		lf		length of foot(m)
%		a		horiz ankle to heel dist (m)
%		mass		body mass (kg)
%		height		body height(m)
%  OUTPUTS:	plot		learning curve (wings and central tendencies)
%		DATA		matrix of summary results:
%				coluns of data each row a trial, each colum is:
%				1  block number
%          	    	    	2  trial number
%				3  wingset 1 center marker diameter (about 0-1)
%				4  wingset 1 central mark location 
%				5  wingset 1 high for wings
%				6   wingset 1 low  for wings 
%				7  (optional) wingset 2 center marker diameter 
%				   (about 0-1)
%				8  (optional) wingset 2 central mark location 
%				9  (optional) wingset 2 high for wings
%				10 (optional) wingset 2 low  for wings 
%  CALLS:	lrn_wing.m 
%		cop_calc.m
%		textract.m
%  NOTES: 	if subject is JG: 
%		lf=.241; a=.043; fp2heel=0.2685+.05-a; 
%		mass=130/2.2; height=64.5*.0254; 
%		if subject is MX: 
%		lf=.23; a=.047; fp2heel=0.284+.05-a; 
%		mass=120/2.2; height=65*.0254; 
%  INITIATIED:	2/28/97 	jim patton from lrn_crv3
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function DATA=cop_anal(ID,Nblocks,Ntrials,fp2heel,lf,a,mass,height)
fprintf(' ~ cop_anal.m (patton) for %s ~ ',ID); pause(.05);	% display info

% _____SETUP & GET INFO_____
global DEBUGIT;						%
figure(2); clg; title('processing, so just wait!..'); 	%
figure(1); clg; title('processing, so just wait!..'); 	%
drawnow;
count=0;							% INIT OVERAL RECORD
fp_origin	=[ 0.0005  -0.0014   0.0365];			% FP CALIB. VECTOR
fp_center	=0.254;						% AP EDGE TO CNTR(M)
fplate		=[ .232  -.232  -.232   .232  .232;	...	% in AMTI coords:
		   .254   .254  -.254  -.254  .254]';			
board_weight 	=31.4;						% BOARD WEIGHT (N)
pfile		=['protocol.' ID]				% PROTOCOL FILE NAME
rfile		=['read_me.' ID]				% READ ME FILE NAME
wide_base	=[NaN  -.05 1.05];				% [CENTER HI LOW] 
narrow_base	=[NaN NaN NaN];		 		% [CENTER HI LOW]
if ~(exist(pfile)-2)						% IF PROTOCOL EXISTS
  fprintf('\n getting data from %s (protocol file)',pfile);	% MESSAGE
  base_vect=textract(pfile,'wide');				% GET VECT()
  fall_mtx=textract(pfile,['?fall trial 1 '; ...		% EXTRACT FALL MTRX
                           '?fall trial 2 '; ...		% ... 
                           '?fall trial 3 '; ...		% ... 
                           '?fall trial 4 '; ...		% ... 
                           '?fall trial 5 '; ...		% ... 
                           '?fall trial 6 '; ...		% ... 
                           '?fall trial 7 '; ...		% ... 
                           '?fall trial 8 '; ...		% ... 
                           '?fall trial 9 '; ...		% ... 
                           '?fall trial 10']);		% ...
end 								% 
if ~(exist(rfile)-2)						% IF READ_ME EXISTS
  fprintf('\n getting data from %s (readme file)',rfile);	% MESSAGE
  ank2fp      =textract(rfile,'horiz dist ankle to back');	% HEEL TO BACK OF FP
  lf          =textract(rfile,'foot length');		% LENGTH OF FOOT(M)
  a           =textract(rfile,'horiz dist ankle to heel');	% HORIZ ANKLE2HEEL
  mass        =textract(rfile,'mass');			% BODY MASS (KG)
  height      =textract(rfile,'height');			% BODY HEIGHT (M)
  htSurf      =textract(rfile,'BOS surface height'); 	%
  htAxle      =textract(rfile,'BOS axle height');		%
  BOSa        =textract(rfile,'BOS anterior axle');		%
  BOSp        =textract(rfile,'BOS posterior axle');		%
  narrow_base =[NaN BOSp BOSa];				% [CENTER HI LOW]
  narrow_base =narrow_base/lf;				% NORMALIZE
  fp_origin(3)=fp_origin(3)+htAxle;				% FP CALIB. VECTOR
else error([' ?!? Cannot find file. Aborting. ' rfile])	%
end 								% 

% __LOOP TO LOAD, CAL, AND ASSEMBLE MATRIX OF RESULTS__
for block=1:Nblocks						% LOOP FOR BLOCKS
  filename=[ID num2str(block) '.ddd'];			% GENERATE FILENAME
  if ~(exist(filename)-2) & base_vect(block)~=-9999,		% IF FILE IS GOOD    
    fprintf('\nOPEN %s (Block %d) ', filename, block);	% MESSAGE
    [info,inopen_trials,freq,time]= inopen3(filename);	% OPEN AND GET INFO
    if inopen_trials~=Ntrials, 				% IF #TRIALS~=
      fprintf(' \7WARNING:%d trials in this file! ',...	% DISPLAY MESSAGE 
       inopen_trials);
      %return; 						% QUIT
    end %if							% ENDIFS

    % ___ DETERMINE BASE SIZE FROM PROTOCOL FILE  ___
    if base_vect(block), 		base=wide_base;	%
    else				base=narrow_base;	% 
    end								% END IF BASE_VECT
    % _____ LOOP FOR TRIALS _____
    fprintf('  Trial '); 					% MESSAGE 
    for trial=1:inopen_trials					% LOOP FOR TRIALS
      fprintf(' %d ',trial);	 				% MESSAGE 
      count=count+1;						% ADVANCE COUNTER
      [fp,header]=readdio(info,trial);			% READ DATA
      fp=fp(2:length(fp(:,1))-15,:);				% CLIP OFF DATA
      %fp(:,6)=fp(:,6)-board_weight;				% SUBTRACT WEIGHT 

      % ____ CALCULATIONS: ____
      Fpmax		= max(abs(fp(:,7)))/mass/height/8;	% FRAC OF MAXPULL 
      rawCOP		= cop_calc(fp,fp_origin); 		% CTR OF PRESSURE
      COP 		= rawCOP(:,2)+lf-a-fp_center+ank2fp;	% COPy & SHIFT IT 
								% see notes 7/25/97
      medianCOP	= median(COP)/lf;      		% MEDIAN COP
      maxCOPheel	= max(COP)/lf;        			% MIN DIS TO HEEL
      minCOPheel	= 1-maxCOPheel;        		% MIN DIS TO HEEL
      minCOPtoe	= min(COP)/lf;          		% MIN FP2HEEL TO TOE
      COP_SM		= min([minCOPheel minCOPtoe]);	% MIN 
      rangeCOP		= max(COP)/lf-  ...     		% WIDTH COP SPANS
	  	  	  min(COP)/lf;          		% ...
      DATA(count,:)	=[block trial			...	% COMPILE MATRIX
			1   base(1) base(2)  base(3)	... 	% ...
			Fpmax medianCOP maxCOPheel	... 	% ...
			minCOPtoe COP_SM rangeCOP];		% ...
      if (fall_mtx(block,trial)-1)>0,				% IF SUBJ FELL
        DATA(count, 7:10)=[NaN NaN NaN NaN]; 		% ERASE WINGS 
      end; 							% END IF FALL_MTX
    end %for trial						% END FOR TRIAL
    fclose(info(1));						% CLOSE FILE (BLOCK)
  else 								% IF "BAD ADATA" 
    for trial=1:Ntrials					% LOOP FOR TRIALS
      count=count+1;						% ADVANCE COUNTER
      DATA(count, 7:10)=[ block trial			...	% MAKE DUMMY MATRIX
			NaN NaN NaN NaN NaN NaN NaN NaN]; 	% PAD DUMMIES 
    end %for trial						% END FOR TRIAL
  end								% END IF FILE EXISTS
end % for block
		
% _____PLOT LEARNING CURVE_____
fprintf('\nPlotting..'); pause(.01)				% DISPLAY
subplot(2,1,1); 						% FIGURE
lrn_wing(ID,10,DATA(:,1:10));					% MAKE PTS & WINGS
Xticks=[0 5 NaN 0 5 NaN 0 5 NaN			...	% X TICKS
        0 5 NaN 0 5 NaN 0 5 NaN];				% ...
Yticks=[0 0 NaN .2 .2 NaN .4 .4 NaN			...	% Y TICKS
       .6 .6 NaN .8 .8 NaN 1 1 NaN]; 				% ...
axis([0 count -.2 1.2]);					% FRAME AXES
text(0,-.01,'      trials','fontsize',7);			% XLABEL @BOTTOM CTR 
plot([0 0],[0 1],'k'); 					% SHOW REF AXES
plot(	Xticks,	Yticks,'k');					% SHOW REF TICKS
plot([0 count],[lf-a lf-a]/lf,'r:');				% SHOW ANKLE
axis off;							% NO auto axis
text(0,1.01,'      COP medians and ranges: ',	... 	% LABEL
 'fontsize',7);						% LABEL
text(0,1,' heel  ', 'fontsize',7,			...	% LABEL
  'HorizontalAlignment','right'); 				% ...
text(0,0,' toe  ',  'fontsize',7,			...	% LABEL
  'HorizontalAlignment','right'); 				% ...
title(['COP wings for ' ID]); 						% Plot title

% _____PLOT LEARNING CURVE_____
subplot(2,1,2); 						% FIGURE
plot( (DATA(:,1)-1)*10+DATA(:,2),	...			% PLOT HEEL SM'S
       1-DATA(:,9),  'ro', 		...			%
      (DATA(:,1)-1)*10+DATA(:,2),	...			% PLOT TOE SM'S
       DATA(:,10), 'bo', 		...			%
       'markersize',3,'linewidth',3);					%	
axis([0 count 0 1]);						% FRAME AXES
legend('heel SM','toe SM' )

% _____PLOT WOBBLE_____
figure(2); clg; 
for block=1:Nblocks						% LOOP FOR BLOCKS
  filename=[ID num2str(block) '.ddd'];			% GENERATE FILENAME
  [H,D,Nt,Nr]=dio2mat(filename);				%
  t=0:H(9,1)/1000:length(D(:,1))*H(9,1)/1000-.001;
  for trial=1:10, 
    subplot(10,Nblocks,block+Nblocks*(trial-1)); 
    i=(trial-1)*10+(9:10); 
    plot(t,D(:,i)); set(gca,'fontsize',4);  
    axis([0 4.25 -5 0])
    drawnow;
  end; 
  legend('front','back');
end; %for block
suptitle(['wobble for ' ID]);

fprintf(' ~ END cop_anal.m  ~ \n\n');
return;


