%******************** MATLAB "M" fcn (Patton) *******************
% make trajectories for the robot
% VERSIONS:	  INITIATED 1-feb-2000 jim patton
%________________ BEGIN: ____________________

function makeTargetList(protocolNum,patternNum,outNum,N,Dirs,Mag,fieldGain);

% ============ SETUP ============
figure(1);clf
figure(2);clf
prog_name='makeTargetList.m';                         % this program's name
fprintf('\n~ %s ~  ',prog_name)                       % orient user
protocols={                                       ... %
    'Baseline alone' ... 
   ,'Baseline & various curl perurb for system ID'... 
   ,'RCB (Regional Control Bases) training, after-effects, and washout'    ... 
   ,'IFD (Iterative Field design) Full experiment'... 
   ,'IFD (Iterative Field design) Baseline & machine learning ' ... 
   ,'IFD (Iterative Field design) Second Baseline & initial training' ...
   ,'IFD (Iterative Field design) Further training, after-effects & washout' ...
   ,'Curl field Baseline, & initial training' ...
   ,'Curl field Further training, After-effects & washout' ...
};
patterns={...
    'Random Walk'         ...
   ,'Center-out'          ...
   ,'Grid'                ...
   };
C=[0 .45];                                            % ctrpt in robot coords
Mag=.10;                                              % distance of each mvmt
colors='rgbcmkyrgbcmkyrgbcmkyrgbcmkyrgbcmkyrgbcmky';
%__setup figure__
for i=1:2
  figure(i);clf; orient tall
  put_fig(i,(i-1)*.4,.2,.37,.75);                     % window
end

% ____get protocol____
if ~exist('protocolNum')                              % 
  playwav('menu.wav');fprintf(' see menu..')          % 
  protocolNum=menu('Choose a protocol: ',         ... %
    protocols)                                        % 
else
  if(protocolNum>length(protocols)|protocolNum<1), 
    error(' Input "protocolNum" is out of range ')
  end
end

% ____get pattern____
if ~exist('patternNum')
  playwav('menu.wav');fprintf(' see the menu..')
  patternNum=menu('Choose pattern:',patterns);        % choose experiment
else
  if(patternNum>length(patterns)|patternNum<1), 
    error(' Input "patternNum" is out of range ')
  end
end

% ____get outNum ____ 
if ~exist('outNum')                                
  playwav('menu.wav');fprintf(' see the menu..')
  outNum=menu('Choose a output number: ',         ... % 
    '1','2','3','4','5','6','7','8','9')              %  
end

% ____get N ____ 
if ~exist('N')                                
  playwav('menu.wav');fprintf(' see the menu..')
  N=menu('Choose N (number of trials for stats): '... % 
    ,'1','2','3','4','5','6','7','8','9','10')        %  
end
V=ones(1,N);

% ____get Dirs ____ 
if ~exist('Dirs')                                
  playwav('menu.wav');fprintf(' see the menu..')
  dirChoice=menu('Choose Directions: '            ... % 
    ,'1 Direction:  [270]'                        ... %
    ,'2 Directions: [225 315]'                    ... %
    ,'3 Directions: [90 210 330]'                 ...
    ,'4 Directions: [45 135 225 315]'             ...
    ,'6 Directions: [30 90 150 210 270 330]'      ...    
    ,'8 Directions: [0 45 90 135 180 225 270 315]'...
    ,'Other')                                         %  
  switch dirChoice
   case 1
     Dirs=[270];
   case 2 
     Dirs=[225 315];
   case 3
     Dirs=[90 210 330];
   case 4
     Dirs=[45 135 225 315];
   case 5
     Dirs=[30 90 150 210 270 330];
   case 6
     Dirs=[0 45 90 135 180 225 270 315];
   case 7
     Dirs=input('Enter Directions (eg., [45 90 35]):  ');
  end % END switch dirChoice
end % END if ~exist('Dirs')                                
nDirs=length(Dirs);                           % number of Dirs

if ~exist('Mag')
  Mag=input('Enter magnitude of each movement: ');
end
  
if ~exist('fieldGain')&(protocolNum==8|protocolNum==9)
  fieldGain=input('Enter gain of curl field: ');
end 
  
% __ DISPLAY TASK __
fprintf('\nProtocol: %s',protocols{protocolNum}) 
fprintf('\nPattern: %s',patterns{patternNum}) 
fprintf('\nDirections: ');fprintf(' %d',Dirs) 

% ============ protocolNum: ============
switch protocolNum
 case 1 % baseline alone
  phaseNum      =[1 1 1 2 ];
  fieldType     =[0 0 0 0 ];
  trialsPerDir  =[1 5 1 N ]; 
  nFieldOnPerDir=[0 0 0 0 ]; 
  trialsStruct(1).name='Unperturbed familiarization';      
  trialsStruct(2).name='Unperturbed baseline';       
 case 2 % baseline & curl perurb (sys ID)
  phaseNum      =[1 1 1 2  3  3  3 ];
  fieldType     =[0 0 0 0 10 20 15 ];
  trialsPerDir  =[1 1 3 N  8  8  8 ]; 
  nFieldOnPerDir=[0 0 0 0  1  1  1 ]; 
  trialsStruct(1).name='Unperturbed familiarization';   
  trialsStruct(2).name='Unperturbed baseline';   
  trialsStruct(3).name='Perturbed';
 case 3 % RCB training, after-effects, and washout
  q=1000;
  phaseNum      =[1 1 2 3 4  5 6 6 6 7 8 9];
  fieldType     =[0 0 0 q q  q q q q 0 0 0];
  trialsPerDir  =[1 1 3 N 50 N 8 8 8 N N N]; 
  nFieldOnPerDir=[0 0 0 N 50 N 7 7 7 0 0 0]; 
  trialsStruct(1).name='Unperturbed familiarization';    
  trialsStruct(2).name='Unperturbed baseline';     
  trialsStruct(3).name='Early Learning'; 
  trialsStruct(4).name='Middle Learning'; 
  trialsStruct(5).name='Late Learning'; 
  trialsStruct(6).name='After-Effects'; 
  trialsStruct(7).name='Early Washout'; 
  trialsStruct(8).name='Middle Washout'; 
  trialsStruct(9).name='Final Washout'; 
 case 4 % Full Iterative Field design (IFD)
  q=2000;  p=2001;
  phaseNum      =[1 1 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 4 5 6  6  7 8 8 8 8 8 9 10  11];
  fieldType     =[0 0 0 0 q q q q q q q q q q q q q q q q q q q q q q q q 0 p p  p  p p p p p p 0 0   0 ];
  trialsPerDir  =[1 1 1 N 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 N N 25 25 N 5 5 5 5 5 N N*3 N ]; 
  nFieldOnPerDir=[0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 N 25 25 N 4 4 4 4 4 0 0   0 ]; 
  trialsStruct(1).name='Unperturbed familiarization';     
  trialsStruct(2).name='Unperturbed baseline';      
  trialsStruct(3).name='Machine Learning'; 
  trialsStruct(4).name='Second Unperturbed baseline';     
  trialsStruct(5).name='Early Learning'; 
  trialsStruct(6).name='Middle Learning'; 
  trialsStruct(7).name='Late Learning'; 
  trialsStruct(8).name='After-Effects'; 
  trialsStruct(9).name='Early Washout'; 
  trialsStruct(10).name='Middle Washout'; 
  trialsStruct(11).name='Final Washout'; 
 case 5  % Baseline & Machine learning for iterative field design (IFD)
  q=2000;  p=2001; 
  phaseNum      =[1 1 1 2   3*V   4*[V V V]   5*V ];
  fieldType     =[0 0 0 0   q*V   q*[V V V]   q*V ];
  trialsPerDir  =[1 7 1 N   4*V   4*[V V V]   4*V ]; 
  nFieldOnPerDir=[0 0 0 0   1*V   1*[V V V]   1*V ]; 
  trialsStruct(1).name='Unperturbed familiarization';
  trialsStruct(2).name='Unperturbed baseline';
  trialsStruct(3).name='Early Machine learning';
  trialsStruct(4).name='Mid Machine learning';
  trialsStruct(5).name='Late Machine learning';
 case 6  % Second Baseline & initial training for iterative field design (IFD) 
  q=2000;  p=2001;
  phaseNum      =[1 2 3 4  4  4  ];
  fieldType     =[0 0 p p  p  p  ];
  trialsPerDir  =[1 N N 25 25 25 ]; 
  nFieldOnPerDir=[0 0 N 25 25 25 ]; 
  trialsStruct(1).name='Unperturbed familiarization';     
  trialsStruct(2).name='Unperturbed baseline';      
  trialsStruct(3).name='Early Learning'; 
  trialsStruct(4).name='Middle Learning 1'; 
 case 7  % Further training, After-effects & washout for iterative field design (IFD) 
  q=2000;  p=2001;
  phaseNum      =[1  2  3*V  4 5   6 ];
  fieldType     =[p  p  p*V  0 0   0 ];
  trialsPerDir  =[25 N  8*V  N N*3 N ]; 
  nFieldOnPerDir=[25 N  7*V  0 0   0 ]; 
  trialsStruct(1).name='Middle Learning 2'; 
  trialsStruct(2).name='Late Learning'; 
  trialsStruct(3).name='After-Effects'; 
  trialsStruct(4).name='Early Washout'; 
  trialsStruct(5).name='Middle Washout'; 
  trialsStruct(6).name='Final Washout'; 
 case 8  % Baseline, & initial training for curl field 
  q=fieldGain; 
  phaseNum      =[1 1 1 2 3 4  4  ];
  fieldType     =[0 0 0 0 q q  q  ];
  trialsPerDir  =[1 8 1 N N 25 25 ]; 
  nFieldOnPerDir=[0 0 0 0 N 25 25 ]; 
  trialsStruct(1).name='Unperturbed familiarization';
  trialsStruct(2).name='Unperturbed baseline';
  trialsStruct(3).name='Early learning';
  trialsStruct(4).name='Middle learning 1';
 case 9  % Further training, After-effects & washout for curl field 
  q=fieldGain; 
  phaseNum      =[1  2  3*V  4 5   6 ];
  fieldType     =[q  q  q*V  0 0   0 ];
  trialsPerDir  =[25 N  8*V  N N*3 N ]; 
  nFieldOnPerDir=[25 N  7*V  0 0   0 ]; 
  trialsStruct(1).name='Middle Learning 2'; 
  trialsStruct(2).name='Late Learning'; 
  trialsStruct(3).name='After-Effects'; 
  trialsStruct(4).name='Early Washout'; 
  trialsStruct(5).name='Middle Washout'; 
  trialsStruct(6).name='Final Washout'; 
 otherwise
  error('Unknown protocol.')
end % END switch

%==========================================================
%================= Generate trial orders ==================
%==========================================================

fprintf('\n__Generate trial orders:__') 
TRG=[];
fprintf('\nSection:') 
for exptSect=1:length(phaseNum),
  fprintf(' %d',exptSect) 
  nTrials=trialsPerDir(exptSect)*nDirs;
  switch patternNum,
   case 1 % random walk 
    subplot(ceil(length(phaseNum)/2),2,exptSect)        %
    TARGS=randomWalk(trialsPerDir(exptSect)         ... %
       ,nFieldOnPerDir(exptSect),Dirs,              ... %
       Mag,C,fieldType(exptSect));                      %
     title(['Section ' num2str(exptSect) ' (Phase ' ...
            num2str(phaseNum(exptSect)) ')'])
   case 2 % center out 
    TARGS=centerOut(trialsPerDir(exptSect)          ... %
       ,nFieldOnPerDir(exptSect),Dirs,              ... %
       Mag,C,fieldType(exptSect));                      %
   otherwise
    error('Unknown patternNum.')
  end % END switch
  phaseNum(exptSect)*ones(nTrials,1);
  TRG=[TRG;                                         ... %
   TARGS phaseNum(exptSect)*ones(nTrials,1)];           % add targets&phase# to list 
end 
TRG=[(1:size(TRG,1))' TRG];                             % insert trial # as column 1

% __ header___
h=str2mat('Trial Definitions (Patton)',             ... %
  sprintf('targets generated by %s on %s.'          ... % 
  ,prog_name,whenis(clock))                         ... %
  ,['Protocol: ' protocols{protocolNum} ]           ... %
  ,['Pattern: ' patterns{patternNum} ' ('           ... %
    num2str(nDirs) ' directions)']                  ... %
  ,['Number of Directions=' num2str(nDirs)]         ... % 
  ,['Directions=' sprintf(' %d',Dirs)]              ... % 
  ,['Number of Phases=' num2str(length(trialsStruct))]);%

for i=1:length(trialsStruct)
  h=str2mat(h,                                      ... %
   ['Phase ' num2str(i) ' name=' trialsStruct(i).name]);
end
h=str2mat(h                                         ... %  
  ,'(the data belowviewed best in EXCEL)'           ... %
  ,'__ BEGIN:__');                                      %
h=str2mat(h,sprintf(                                ... %
  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t',           ... %
  'trialNumber','startX','startY','endX',           ... %
  'endY','fieldType','Dir(deg)',                    ... %
  'Magnitude','experimental_phase'));                   %

%__ STORE IN FILE ___
outName=['targ_p' num2str(outNum) '.txd'];
mat2txt(outName,h,TRG);
fprintf('\n TARGETS in: %s ',outName)                   % 

trialsStruct=makeTrialsStruct(outName,trialsStruct,outNum);

% __ display info about trials __
te=length(TRG(:,1))*4/60;                               % estimated time
if patternNum==2, eTime=eTime*2; end                    % allow for return to center
fprintf('\n\n%d trials. ',  size(TRG,1) )               %  
fprintf(' Est.time: %.1f min (%f hours).',te,te/60);    % estimate time 4 sec/trial 

%__ print graphic if any ___
switch patternNum
 case 1, % random walk
  suptitle(str2mat(protocols{protocolNum},          ... %
    [patterns{patternNum} ', filename=' outName],   ... %
    ['Directions=' sprintf(' %d',Dirs)] ) );
  cmd=['print -depsc2 ' outName '.eps'];
  disp(cmd);   eval(cmd);
  figure(2)
 otherwise
end % END switch patternNum
clf
for i=1:size(TRG,1),
   plot([TRG(i,2) TRG(i,4)],...
        [TRG(i,3) TRG(i,5)],colors(TRG(i,9)))
   hold on; axis equal; axis off; 
   plot(C(1),C(2),'o')
end

fprintf('\n~ END %s ~ \n',prog_name)                    % 
return


%**************** MATLAB "M" fcn (Patton) ***************
% centerOut(): make list of trajectories, all origniating from center
%_________________ BEGIN: ___________________

function d=centerOut(trialsPerDir,nFieldOnPerDir,Dirs,Mag,C,fieldType)

% ============ SETUP ============
nDirs=length(Dirs);                           % number of Dirs
totalTrials=(trialsPerDir)*nDirs;             % calc total trials for this
junk=zeros(totalTrials,1);                    % initialize
ok=0;

% ============ RENDER ============ 
% __make a list of mvmts __
count=0;
for D=1:nDirs,
  for i=1:nFieldOnPerDir,                     % loop for field on
    count=count+1;      
    d(count,:)=[fieldType Dirs(D) Mag];
  end
  for i=1:(trialsPerDir-nFieldOnPerDir),      % loop for field off
    count=count+1;
    d(count,:)=[0 Dirs(D) Mag];
  end  
end                                           % END for D

% __randomly mix the list__
[junk,I]=sort(rand(count,1));                 % obtain a random order
d=d(I,:);                                     %

% __assure no 2 consecutive catch trials __
if nFieldOnPerDir~=0&trialsPerDir~=0,         % if catch trials
  d=notConsec(d,trialsPerDir,nFieldOnPerDir...% perform a re-ordering
    ,fieldType,count);
end

for i=1:count
  vect=[Mag*cos(d(i,2)*pi/180),        ...%
        Mag*sin(d(i,2)*pi/180)];
  startEnd(i,:)=[C C+vect];              %
end
d=[startEnd d];
return

%***************** MATLAB "M" fcn (Patton) ****************
% randomWalk(): make list of trajectories as a random walk 
%_________________ BEGIN: ___________________

function d=randomWalk(trialsPerDir,nFieldOnPerDir,Dirs,Mag,C,fieldType)

% ============ SETUP ============
nDirs=length(Dirs);                           % number of Dirs
totalTrials=(trialsPerDir)*nDirs;             % calc total trials for this
junk=zeros(totalTrials,1);                    % initialize
ok=0;
xL=.44;
yL=.4;
W.xLo=C(1)-.19; % do not go higher than .222
W.xHi=C(1)+.19; 
W.yLo=C(2)-.14;  % do not go higher than .165
W.yHi=C(2)+.14;
j=1;

% __make a list of mvmts __
count=0;
for D=1:nDirs,
  for i=1:nFieldOnPerDir,                               % loop for field on
    count=count+1;      
    d(count,:)=[fieldType Dirs(D) Mag];
  end
  for i=1:(trialsPerDir-nFieldOnPerDir),                % loop for field off
    count=count+1;
    d(count,:)=[0 Dirs(D) Mag];
  end  
end                                                     % END for D

% __randomly mix the list__
fprintf('\n Randomizing..')
[junk,I]=sort(rand(count,1));                           % obtain a random order
d=d(I,:);                                               %

if nFieldOnPerDir~=0&trialsPerDir~=0,                   % if catch trials, 
  d=notConsec(d,trialsPerDir,nFieldOnPerDir,fieldType,count); % disallow 2 consecutive
end                                                     % END if

% __initial plot __
plot([W.xLo W.xHi W.xHi W.xLo W.xLo],               ... % 
     [W.yLo W.yLo W.yHi W.yHi W.yLo],'g'); 
hold on;   
plot(C(1),C(2),'o','markersize',2)                      % 
[startEnd,cPt,notOK]=walk(C,d,Mag,W);                   % reevaluate it
h=plot([startEnd(1,1); startEnd(:,3)],              ... %
       [startEnd(1,2); startEnd(:,4)],'r');             %
hNi=text(W.xLo,W.yHi,'No adjustments necessary', ...
       'fontsize',6);
set(gca,'fontsize',6)
axis equal; drawnow; 
  
% ___ === ADJUST Random walk ==== ___
if notOK,
  fprintf('Adjusting random walk to fit window..')
end
iterationCount=0;
while(notOK)                                            % 
  iterationCount=iterationCount+1;                      %
  switch round(rand*3)
   case 1 % PUT bad guy AT THE END                      %
    q=d(cPt,:); d(cPt,:)=[]; d=[d;q];                   
   case 2, % put early bad mvmt at end
    for j=1:cPt-1,                                      % SEARCH FOR EARLY BAD MVMT
      switch notOK                                      % 
       case 1 % W.xLo                                   %
        if startEnd(j,3)<startEnd(j,1); k=j; break,end  % choose a bad guy
       case 2 % W.xHi   
        if startEnd(j,3)>startEnd(j,1); k=j; break,end  % choose a bad guy
       case 3 % W.yLo
        if startEnd(j,4)<startEnd(j,2); k=j; break,end  % choose a bad guy
       case 4 % W.yHi
        if startEnd(j,4)>startEnd(j,2); k=j; break,end  % choose a bad guy
      end % switch notOK
    end % for j
    q=d(k,:); d(k,:)=[]; d=[d;q];                       % PUT bad guy AT END
   case 3,  % PUT best LATE GOOD MVMT BEFORE BAD
    if cPt<count-4,
      bestPt=cPt+1;                                     % initi with current bad point
      bestDist2ctr=sqrt( (startEnd(cPt+1,3)-C(1))^2 +...% init with current dist
        (startEnd(cPt+1,4)-C(2))^2  );
      for j=cPt+2:count,                                % SEARCH: BEST LATE GOOD MVMT
        possible=startEnd(cPt-1,3:4)+               ... %
          Mag*[cos(d(j,2)/180*pi) sin(d(j,2)/180*pi)];  %
        PosDist2ctr=sqrt( (possible(1)-C(1))^2 +    ... % possible dist
                        (possible(2)-C(2))^2  );        %
        if PosDist2ctr<bestDist2ctr,                    %
          bestDist2ctr=PosDist2ctr; bestPt=j;           %
        end
      end % for j
      %bestPt,cPt
    else
      bestPt=cPt-1;                                     % initi with current bad point
      bestDist2ctr=sqrt((startEnd(cPt+1,3)-C(1))^2 +... % init with current dist
                       (startEnd(cPt+1,4)-C(2))^2  );   %
      for j=cPt-2:1,                                    % SEARCH: BEST LATE GOOD MVMT
        possible=startEnd(cPt-1,3:4)+               ... %
          Mag*[cos(d(j,2)/180*pi) sin(d(j,2)/180*pi)];  %
        PosDist2ctr=sqrt( (possible(1)-C(1))^2 +    ... % possible dist
                        (possible(2)-C(2))^2  );        %
        if PosDist2ctr<bestDist2ctr,                    %              
          bestDist2ctr=PosDist2ctr; bestPt=j; 
        end
      end % for j
      %bestPt,cPt
    end  
    d=swapRows(d,bestPt,cPt);
  end % ENS switch ..
  
  if nFieldOnPerDir~=0&trialsPerDir~=0,                 % if catch trials, 
    d=notConsec(d,trialsPerDir,nFieldOnPerDir,      ... % disallow 2 consecutive
      fieldType,count);                                 %
  end                                                   % END if
 
  % reevaluate & plot
  [startEnd,cPt,notOK]=walk(C,d,Mag,W);                 % evaluate start& endpoints
  set(h,'XData',[startEnd(1,1); startEnd(:,3)],     ... %
        'YData',[startEnd(1,2); startEnd(:,4)])         %
  set(hNi,'string',[num2str(iterationCount) 'iterations']);
  title([num2str(iterationCount) ' Iterations'])
  %zoom(.5); 
  axis equal; drawnow; 
  pause(.02)
  
end % while

axis off;
%iterationCount
%disp('pause..');pause
d=[startEnd d];

return                                                  % END function makeSubList


%***************** MATLAB "M" fcn (Patton) ****************
% Walk(): calc & eval random walk 
%_________________ BEGIN: ___________________

function [startEnd,cPt,notOK]=walk(C,d,Mag,W)
notOK=0;
count=size(d,1);
startEnd(1,:)=[C C+Mag*[cos(d(1,2)/180*pi)  ... % do row 1
                        sin(d(1,2)/180*pi)] ];  %

% calc walk points
for i=2:count,                                  % 
    startEnd(i,:)=[startEnd(i-1,3:4),       ... %
     startEnd(i-1,3:4)+                     ... %
     Mag*[cos(d(i,2)/180*pi) sin(d(i,2)/180*pi)]];%
end % for i 

% calc points and do 1 corrections
for i=2:count,                                  %
  if(startEnd(i,3)<W.xLo) notOK=1; break, end   % 1st boundary cross
  if(startEnd(i,3)>W.xHi) notOK=2; break, end   % 
  if(startEnd(i,4)<W.yLo) notOK=3; break, end   %
  if(startEnd(i,4)>W.yHi) notOK=4; break, end   % 
end % for i 

cPt=i;

return

%***************** MATLAB "M" fcn (Patton) ****************
% notConsec(): adjust d so there are no 2 consecutive catch trials 
%_________________ BEGIN: ___________________ 

function d=notConsec(d,trialsPerDir,nFieldOnPerDir,fieldType,count) 

% __determine most common field type__
if nFieldOnPerDir>ceil(trialsPerDir/2),                   % if Aftereffect catch trials
      common=fieldType; notCommon=0; 
else  common=0;         notCommon=fieldType;
end
counter=0;

% always have 1st 2 be a non-catch 
for i=1:count
  if d(i,1)==common,q=d(i,:);d(i,:)=[];d=[q;d];break;end  % put it first and stop
end
for i=2:count
  if d(i,1)==common,q=d(i,:);d(i,:)=[];d=[q;d];break;end  % put it first and stop
end

% swap 1st of 2 consecutive catch trials with one above
ok=0; 
while(~ok&counter<100)
  counter=counter+1;
  %fprintf('.'); pause(.01); d
  ok=1;
  for i=3:count-1
    if (d(i,1)==notCommon&d(i+1,1)==notCommon),      % IF 2 IN A ROW
      q=d(i-1,:); d(i-1,:)=d(i,:); d(i,:)=q;         % swap with one above it
      ok=0;                                          % flag the problem
    end  % if
  end % for i 
  %d,  disp('...hit a key...'); pause
end % while
%disp('DONE! hit a key'); pause

return



