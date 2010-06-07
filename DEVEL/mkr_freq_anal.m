%***************** MAIN FUNCTION *******************
function mkr_freq_anal(scdfilename,maxfreq)

%___ SETUP____
fprintf('\n ~ mkr_freq_anal  ~ ');
if ~exist('maxfreq'), maxfreq=60; end;  % (hz) for views
figure(1); clf; orient tall;
put_fig(1,.65,.1,.35,.85); drawnow;

%___ LOAD SCD FILE____
fprintf(' LOAD: %s..', scdfilename); 
 [h,d,nt,nr]=dio2mat(scdfilename,1);
fprintf(' DONE. ');

Mh=h(:,10:nr);
Md=d(:,10:nr);

%___ MAKE TIME VECTOR____
[rows,cols]=size(Md);
freq=h(12,1);
t=0:1/freq:rows/freq-.0001;

%=== DISPLACEMENT ====
fprintf(' Displacement.. '); pause(.01);
dofftandplots(Md,t,freq,maxfreq,1);

%=== VELOCITY ====
fprintf(' Velocity.. '); pause(.01);
Md_dot=vel(t,Md);
dofftandplots(Md_dot,t,freq,maxfreq,4);

%=== ACCELeRATION ====
fprintf(' Acceleration.. '); pause(.01);
Md_dotdot=vel(t,Md_dot);
dofftandplots(Md_dotdot,t,freq,maxfreq,7);

%___ PLOT LABELS____ 
subplot(3,3,1);  title('all markers vs time'); ylabel('position (m)');
subplot(3,3,2);  title('all markers FFT');
subplot(3,3,3);  title('SUM of all markers" FFTs');
subplot(3,3,4);  ylabel('velocity (m/s)');
subplot(3,3,7); xlabel('sec'); ylabel('acceleration (m/s/s)');
subplot(3,3,8); xlabel('Hz');
subplot(3,3,9); xlabel('Hz');
suptitle(['marker trajectory analysis on trial 1 of ' scdfilename])

fprintf('\n ~ END mkr_freq_anal  ~ \n');
return
%***************** END OF MAIN FUNCTION *******************




%***************** LOCAL FUNCTION *******************
function status=dofftandplots(X,t,FREQ,maxfreq,startplot);

%___ SETUP____
[rows,cols]=size(X);
colors=colorcube(48);

%___ DO FFT ____
for col=1:cols; 
  [FFT_F,FFT_M(:,col)]=fft_plot(X(:,col),...
    FREQ,maxfreq,'noplot',0); 
end 
for I_f=1:length(FFT_F), 
  if FFT_F(I_f)>maxfreq; break; end;        % find indicie
end;

%___ PLOT ____
subplot(3,3,startplot);                     % temporal domain
for i=1:cols, 
  plot(t,X(:,i),'color',colors(i,:)); 
  hold on;
end
drawnow;

subplot(3,3,startplot+1);                   % freq domain
for i=1:cols, 
  plot(FFT_F(1:I_f),FFT_M(1:I_f,i),     ...
       'color',colors(i,:)); 
  hold on;
end
drawnow;

subplot(3,3,startplot+2);                    % freq domain, sum
plot(FFT_F(1:I_f),sum(FFT_M(1:I_f,:)')', ...
       'linewidth',4); 
drawnow;

status=0;
return
%***************** END OF LOCAL FUNCTION *******************

