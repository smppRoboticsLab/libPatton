%************** MATLAB "M" function  *************
% test & compare Figural error, velocity inner product, and 
% SYNTAX:      
%  -7777,trial,samplingRate(Hz),field_on(1=yes; 0=no),0,0
%  -7777,field_type(1=stiff,2=visc,3=inertial),Gain_xx,Gain_xy,Gain_yx,Gain_yy
% REVISIONS:    2/8/2000  (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function EM=FastLearnCurves()

% ____ SETUP ____
prog_name='FastLearnCurves.m';                % name of this program
fprintf('\n~ %s ~ ', prog_name); 
figure(2);clf;                            % setup figure window
put_fig(2,.15,.03,.8,.8); orient tall;    
figure(1);clf;                            % setup figure window
put_fig(1,.1,.05,.8,.8); orient tall;    
drawnow;
verbose=1; plotIt=1;                      % switches for display
fsz=8;                                    % font size
mkrsize=2;                                % marker size
mvmtDist=.2; mvmtDeflect=-0.05;
mag=[mvmtDist mvmtDeflect];
startPt=[0 .4];
rot=90/180*pi;
L=[8888 8888];                            % dummyvalues for limb length
names=[];
spacing=0.005;
cutoff=10;
trialsStruct=setPlotStruct;
colors='cgrybmcgrybm';

%__  parameters from the parameters file: __
% load values; if not there, use defaults.
fprintf ('Loading from "parameters.txt"..') %
body_mass=find1TXTvalue(                ... %
 'parameters.txt','body_mass=',0);          %
if isempty(body_mass)                       %
  fprintf(' param not found! Use default: ')%
  body_mass     = 77.2727 %=170/2.2;        % kg typical
end                                         %
body_height=find1TXTvalue(              ... %
 'parameters.txt','body_height=',0);        %
if isempty(body_height)                     %
  fprintf(' param not found! Use default: ')%
  body_height   = 1.78                      % m typical
end                                         %
uprArm_length=find1TXTvalue(            ... %
 'parameters.txt','uprArm_length=',0);      %
if isempty(uprArm_length)                   %
  fprintf(' param not found! Use default: ')%
  uprArm_length = 0.186*body_height         % Winter, 1990 page 52
end                                         %
forArm_len=find1TXTvalue(               ... %
 'parameters.txt','forArm_len=',0);         %
if isempty(forArm_len)                      %
  fprintf(' param not found! Use default: ')%
  forArm_len    = 0.146*body_height         % Winter, 1990 page 52
end                                         %
half_hand_len=find1TXTvalue(            ... %
 'parameters.txt','half_hand_len=',0);      %
if isempty(half_hand_len)                   %
  fprintf(' param not found! Use default: ')%
  half_hand_len =.108/2*body_height         % Winter, 1990 page 52
end                                         %
Xshoulder2nose=find1TXTvalue(           ... %
 'parameters.txt','Xshoulder2nose=',0);     %
if isempty(Xshoulder2nose)                  %
  fprintf(' param not found! Use default: ')%
  Xshoulder2nose=.129*body_height;          %
end                                         %
Yshoulder2motor=find1TXTvalue(          ... %
 'parameters.txt','Yshoulder2motor=',0);    %
if isempty(Yshoulder2motor)                 %
  fprintf(' param not found! Use default: ')%
  Yshoulder2motor=.85;                      %
end                                         %

startXr = -0.10;                                    % start points (robot coord)
startYr =  0.60;                          
targXr  = -0.10;                                    % end points (robot coord)
targYr  =  0.40;
startX  =-Xshoulder2nose-startXr; 
targX   =-Xshoulder2nose-targXr;                    % convert to subj coords
startY  = Yshoulder2motor-startYr;  
targY   = Yshoulder2motor-targYr;   
startPt=[startX startY];

measureNames=str2mat(                       ...
     'Resampled Figural error',            ...
     'Infinity Norm',                       ...
     'initial direction error'             ...
            );

% ____ IDEAL TRAJECTORY ____
d=getTrajectory('sin-morphed.txd'                   ... % nominal (ideal) traj
 ,L,rot,mag,startPt);

% ____ LOOP for TRIALS ____
fprintf('\n\nTrial:\n~~~~~~\n'); 
for trial=1:350
  fprintf(' %d',trial); 
  if trial/10==round(trial/10), fprintf('\n'); end
  
  % ____ load TRAJECTORY ____
  filename=['FD-' num2str(trial) '.dat'];
  %[D,v1,v2]=loadDataman(filename,verbose);   
  [D,F,Hz]=loadRobotData(filename,cutoff,~verbose);
  t=0:size(D,1)-1; t=t./Hz; t=t'; D=[t D]; % add time col
  
  % ____ MEASURES ____
  [EM(trial,1) EM(trial,2)]=figuralError(d(:,1:3),...
     D(:,1:3),spacing,~verbose,~plotIt); 
  EM(trial,3)=initial_direction_error(d(:,2:3),...
     D(:,2:3),.25,~verbose,~plotIt);
  
  % ___ LOOP thru each measure and plot ___
  Nmeas=size(EM,2);
  for meas=1:Nmeas,
    mkr='ks';  
    for i=1:length(trialsStruct)                          % loop for exp phase
      for j=1:length(trialsStruct(i).trials)              % loop for trials in phase list 
        if trial==trialsStruct(i).trials(j),  
          mkr=[colors(i) 'o']; 
          break
        end
      end % END for j
    end % END for i
    subplot(3,ceil(Nmeas/3),meas)
    plot(trial,EM(trial,meas),mkr,'markersize',mkrsize);
    if trial==1, 
      hold on; set(gca,'fontsize',fsz); 
      title(deblank(measureNames(meas,:)));
      xlabel('trial','fontsize',fsz);
    end
    
  end % END for meas
  drawnow; pause(.001);
  
end % END for trial
fprintf('\nDONE with trials. '); 

% ____ store file ____
fprintf('\nStoring data..'); 
save EM EM -ascii -double -tabs 
h=['Measures of performance (& error) for ' cd]; 
h=str2mat(h,... 
  ['Generated by ' prog_name ', ' whenis(clock)],... 
  '____data:____');
col_labels=deblank(measureNames(1,:)); 
for meas=2:Nmeas,  
  col_labels=[col_labels setstr(9) ... 
      deblank(measureNames(meas,:))]; 
end % END for meas 
h=str2mat(h,col_labels); 
mat2txt([prog_name '_results.txd'],h,EM); 

% ____ finalize plot ____
fprintf('\nFinalizing plot & printing to a file..'); 
subplot(3,ceil(Nmeas/3),1);
ax=axis; lgndX=.1*(ax(2)-ax(1));
for i=1:length(trialsStruct)                          % loop for exp phase
  mkr=[colors(i) 'o']; 
  lgndY=ax(3)+.98*(ax(4)-ax(3))-.03*i*(ax(4)-ax(3));
  plot(lgndX,lgndY,mkr,'markersize',mkrsize); hold on
  text(lgndX,lgndY,['  ' trialsStruct(i).name],'fontsize',fsz);
end % END for i
drawnow; pause(.001);
suptitle(['Learning curves for ' cd]);
print -depsc2 FastLearnCurves

% ____ GROUP the DATA for Barcharts ____
temp=[]; barMeans=[]; barStd=[];
for i=1:length(trialsStruct(3).trials)
  temp=[temp; EM(trialsStruct(3).trials(i),:)];
end
barMeans=[barMeans; mean(temp)];
barStd=[barStd; std(temp)];
bar95Width=[bar95Width; confidence(temp,.95)];

temp=[]; 
for i=1:length(trialsStruct(7).trials)
  temp=[temp; EM(trialsStruct(7).trials(i),:)];
end
barMeans=[barMeans; mean(temp)];
barStd=[barStd; std(temp)];
bar95Width=[bar95Width; confidence(temp,.95)];

temp=[]; 
for i=1:length(trialsStruct(8).trials) 
  temp=[temp; EM(trialsStruct(8).trials(i),:)];
end
barMeans=[barMeans; mean(temp)];
barStd=[barStd; std(temp)];
bar95Width=[bar95Width; confidence(temp,.95)];

% ____ make the Barcharts ____
figure(2); clf;
C=colorcube(8); C=C(4:8,:); 
for meas=1:Nmeas,
  meas
  subplot(3,ceil(Nmeas/3),meas)
  multbar3(barMeans(:,meas),1,C,str2mat(' '),...
           0.2,0.2,bar95Width(:,meas));
  title(measureNames(meas,:));
end % END for meas

suptitle(['Error measures for ' cd]);
orient landscape
print -dpsc2 barchart                     % print to a file

fprintf('\n~ END %s ~ ', prog_name); 
