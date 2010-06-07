% ************** MATLAB "M" file  (jim Patton) *************
% this file reads the data,   separates it, & does FFT
% Assumes each trial is a 2 second,  1000hz collection.
% OUTPUTS: 		name.DAT (where name is the rootname of the datafiles)
% INITIATIED: 		4/1/96 by jim patton from fp_test2.m 
% NEW CHANGES MADE:	average results of trials for a concise 3-page report
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

disp('~ fp_test3.m (for lab force plate tests)~');

% ___ SETUP ___
disp('____ SETUP SETUP SETUP SETUP SETUP SETUP: ____');
clear; 
figure(1); clg; orient landscape; 
figure(2); clg; orient landscape; 
figure(3); clg; orient landscape; 
max_freq=100;							% max frequency for plots
fp_origins = [	 0.0005 	-0.0014		0.0365;	...	% FP calibration vector
		-0.0009		 0.0001		0.0384	];  	% FP calibration vector
origin=fp_origins(menu2(	 'Choose a forceplate:' 			...
  				,'SN3120 in room 1130 (formally called "SOUTH")'	...
				,'SN3172 in room 1115 (formally called "NORTH")'	...
										),:);
FFTMAT=[];
MAG=[];

name=input('Enter root of filename (i.e., if file is FPLATE.DDD, enter FPLATE)','s');
if menu2('print time hist. & COP?','no','yes')-1, print_th='y'; else print_th='n'; end;
if menu2('print plots?','no','yes')-1, print_or_not='y'; else print_or_not='n'; end;
channels=str2mat('Moment_x','Moment_y','Moment_z','Force_x',			...
			'Force_y','Force_z','Load Cell');

% ___ STATIC AVERAGES AND COP CALCULATIONS. PASTE OUTPUT IN EXCEL FILE ___
disp('____ STATIC AVERAGES AND COP CALCULATIONS: ____');
figure(1); clg; subplot(3,5,2); hold; title(['Time histories for ' name]); hold; 
figure(2); clg; hold; axis([-.4 .4 -.4 .4]); title(['COPs for ' name]);
for trial = 1:10, 
  % __ load: __
  fprintf('Loading: %s.ddd, trial %2.0f\n',name, trial); 
  [info,Ntrials,freq,time]=inopen([name '.ddd']); [fp,header]=readdio(info,trial);
  fclose(info(1)); 

  % __ COP: __
  COP=cop_calc(fp,origin); 		% find center of pressure (in  C:\JIM\MATLAB)
  fp=[fp COP];				% add COP to RHS of fp matrix

  % __ make average array of the static measurements: __
  avg_fp(trial,:) = mean(fp);		  std_fp(trial,:) = std(fp);
  result(trial,:) = [	avg_fp(trial,1) std_fp(trial,1) avg_fp(trial,2) std_fp(trial,2) ...
			avg_fp(trial,3) std_fp(trial,3) avg_fp(trial,4) std_fp(trial,4) ...
			avg_fp(trial,5) std_fp(trial,5) avg_fp(trial,6) std_fp(trial,6) ...
			avg_fp(trial,7) std_fp(trial,7) avg_fp(trial,8) std_fp(trial,8)];
  % ___plot ___
  figure(1); subplot(3,5,trial); plot(fp(:,6)); 
  ax=axis; text(0,ax(4),[' trial' num2str(trial)]); 
  figure(2); plot([.25 -.25 -.25 .25 .25],[.25 .25 -.25 -.25 .25], fp(:,7),fp(:,8),'b');
end %for trial
for trial = 11:13,  	%__ load last 3 trials for plotting ___
  fprintf('Loading: %s.ddd, trial %2.0f\n',name, trial); 
  [info,Ntrials,freq,time]=inopen([name '.ddd']); [fp,header]=readdio(info,trial);
  fclose(info(1)); 
  figure(1); subplot(3,5,trial); plot(fp(:,6)); pause(.01);
end %for trial

% ___print or pause___
if print_th=='y', orient landscape; print -dwin; else disp('pause..'); pause; end %if

% ___Combine the data to make averages of 2 trials at a time (each position) & save___
out = [	result(1,:);  result(2,:);  mean(result(1:2,:)); 	...
	result(3,:);  result(4,:);  mean(result(3:4,:)); 	...
	result(5,:);  result(6,:);  mean(result(5:6,:)); 	...
	result(7,:); result(8,:); mean(result(7:8,:)); 	...
	result(9,:); result(10,:); mean(result(9:10,:))	];
outname = [name '.dat'];
evalstr=['save ' outname ' out -ascii -double -tabs']; disp(evalstr); eval(evalstr);

% ___ STATIC TIME HISTORIES & FFT AVERAGES ___
disp('____ STATIC TIME HISTORIES & FFT: ____');
figure(1); clg;
for ch=1:6
  for trial=1:10
    x=loaddio2([name '.ddd'],trial); 
    clg; [freq,FFTMAT(:,trial)]=fft_plot(x(:,ch),1000,max_freq,'y'); xlabel('Hertz');
    title(['FP STATIC (' name ') ' channels(ch,:) ' FFTs, trial ' num2str(trial)]); 
    pause(.01);
  end %for trial
  MAG(:,ch)=mean(FFTMAT')';
end %for ch
clg;
for ch=1:6
  subplot(3,2,ch); plot(freq,MAG(:,ch)); ylabel(channels(ch,:));
  ax=axis; axis([0 max_freq 0 800]); grid on; 
end %for ch
subplot(3,2,1); 	title(['FP STATIC (' name ') FFT averaged for 10 trials']);
subplot(3,2,5); 	xlabel('Hertz'); 
subplot(3,2,6); 	xlabel('Hertz');
if print_or_not=='y',  orient landscape; print -dwin; end %if

% ___ PING (DYNAMIC) TIME HISTORIES & FFT ___
disp('____ PING TIME HISTORIES & FFT: ____');
figure(2);
for ch=1:6
  clg;
  x=loaddio2([name '.ddd'],11); 
  subplot(3,2,1); plot(x(:,ch)); 		
  ylabel('trial 1');  title(['FP PING (' name ') ' channels(ch,:) ' time histories']);
  subplot(3,2,2); fft_plot(x(:,ch),1000,max_freq,'y'); 	
  title(['FP PING (' name ') ' channels(ch,:) ' FFTs']);

  x=loaddio2([name '.ddd'],12); 
  subplot(3,2,3); plot(x(:,ch));  ylabel('trial 2');
  subplot(3,2,4); fft_plot(x(:,ch),1000,max_freq,'y');

  x=loaddio2([name '.ddd'],13); 
  subplot(3,2,5); plot(x(:,ch)); ylabel('trial 3'); xlabel('msec');
  subplot(3,2,6); fft_plot(x(:,ch),1000,max_freq,'y');
  xlabel('Hertz'); 

  %if print_or_not=='y',  orient landscape; print -dwin; end %if
end %for 

% ___ PING (DYNAMIC) FFT averages ___
disp('____ PING AVERAGE FFTs: ____');
figure(3);
for ch=1:6
  for trial=11:13
    x=loaddio2([name '.ddd'],trial); 
    clg; [freq,FFTMAT(:,trial)]=fft_plot(x(:,ch),1000,max_freq,'y'); xlabel('Hertz'); 
    title(['FP DYNAMIC (' name ') ' channels(ch,:) ' FFTs, trial ' num2str(trial)]); 
    pause(.01);
  end %for trial
  MAG(:,ch)=mean(FFTMAT')';
end %for ch
clg;
for ch=1:6
  subplot(3,2,ch); plot(freq,MAG(:,ch)); ylabel(channels(ch,:));
  ax=axis; axis([0 max_freq 0 1500]); grid on; 
end %for ch
subplot(3,2,1); 	title(['FP PING/DYNAMIC (' name ') FFT averaged for 3 trials ']);
subplot(3,2,5); 	xlabel('Hertz'); 
subplot(3,2,6); 	xlabel('Hertz');
if print_or_not=='y', orient landscape; print -dwin; end %if

disp('~ END fp_test3.m (for lab force plate tests)~');

