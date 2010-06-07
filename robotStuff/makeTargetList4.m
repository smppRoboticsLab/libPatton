%******************** MATLAB "M" fcn (Patton) *******************
% make trajectories for the robot
% VERSIONS:	  INITIATED 1-feb-2000 jim patton
%             16-Apr-2001 'makeTargetList4.m' allowed for input 
%                         of window (W) for random walk boundaries
%________________ BEGIN: ____________________

function te=makeTargetList4(fileName);

% ============ SETUP ============
prog_name='makeTargetList4.m';                              % this program's name
fprintf('\n\n\n\n~ %s ~  ',prog_name)                             % orient user
colors='rgbcmkyrgbcmkyrgbcmkyrgbcmkyrgbcmkyrgbcmky';
if ~exist('fileName'),
  fileName=uigetfile('*.txd','File to process')
end

%__setup figure__
for i=1:2
  figure(i);clf; orient tall
  put_fig(i,(i-1)*.4+.2,.2,.37,.75);                        % window
end

% ____load protocol____
fprintf('\nLoading stuff..')
protocolName=deTabBlank(findInTxt(fileName,'protocol name=','s'));
pattern=deTabBlank(findInTxt(fileName,'pattern=','s'));
C=(findInTxt(fileName,'center point='));                    % center robot coords
StPt=(findInTxt(fileName,'start point='));                  % start point,robotCoords
if isempty(StPt), StPt=C; end
Mag=(findInTxt(fileName,'movement distance='));             % distance each mvmt
outNum=(findInTxt(fileName,'output file number='));         % 
nDirs=(findInTxt(fileName,'number of directions='));        % directionsOmovement
phasesOinterest=(findInTxt(fileName,'phases of interest='));
fprintf('.')
phaseNum_i=(textract(fileName,'phaseNum'));
fprintf('.')
fieldType_i=(textract(fileName,'fieldType'));
fprintf('.')
trialsPerDir_i=(textract(fileName,'trialsPerDir'));
fprintf('.')
nFieldOnPerDir_i=(textract(fileName,'nFieldOnPerDir'));
fprintf('.')
startDir_i=(textract(fileName,'start direction'));
fprintf('.')
repeat=(textract(fileName,'repeat'));
Nphases=max(phaseNum_i);
for i=1:Nphases
  matchStr=['phase ' num2str(i) ' name='];
  trialsStruct(i).name=deTabBlank(findInTxt(fileName,matchStr,'s'));
end
for i=1:nDirs
 fprintf('.')
 offDirs_i(:,i)=(textract(fileName,                 ... %
  ['field-off direction ' num2str(i)])); 
 on_Dirs_i(:,i)=(textract(fileName,                  ... %
  ['field-on direction ' num2str(i)])); 
end
W.xLo=findInTxt(fileName,'Window.xLo=');                
W.xHi=findInTxt(fileName,'Window.xHi=');                
W.yLo=findInTxt(fileName,'Window.yLo=');                
W.yHi=findInTxt(fileName,'Window.yHi=');                
fprintf('DONE.')

% __ DISPLAY TASK __
fprintf('\n\nProtocol: %s',protocolName) 
fprintf('\nPattern: %s',pattern) 
strcmp(lower(deTabBlank(pattern)),'center out')
fprintf('\nNumber Directions: ');fprintf(' %d',nDirs) 
fprintf('\nMovement distance: %f',Mag) 
fprintf('\nCenter point: ');fprintf(' %f',C) 
fprintf('\nStart point: ');fprintf(' %f',StPt) 

% __expand repeats ('repeat' 2 stretch others) ___
fprintf('\nExpanding repeats..') 
phaseNum=[];                                            % init
fieldType=[];
trialsPerDir=[];
nFieldOnPerDir=[]; 
offDirs=[]; 
on_Dirs=[];
for i=1:length(phaseNum_i),
  for j=1:repeat(i)
    phaseNum=[phaseNum; phaseNum_i(i)];                 % stack on another
    fieldType=[fieldType; fieldType_i(i)];
    trialsPerDir=[trialsPerDir; trialsPerDir_i(i)];
    nFieldOnPerDir=[nFieldOnPerDir; nFieldOnPerDir_i(i)];
    offDirs=[offDirs; offDirs_i(i,:)];    
    on_Dirs=[on_Dirs; on_Dirs_i(i,:)];
  end
end
fprintf('DONE.')

%disp('   hit a key    '); pause;

%==========================================================
%================= Generate trial orders ==================
%==========================================================

fprintf('\n\n__Generate trial orders for %d sections:__', length(phaseNum)) 
TRG=[];
fprintf('\nSection: ') 
for exptSect=1:length(phaseNum),
  fprintf('%d ',exptSect) 
  if trialsPerDir(exptSect)<nFieldOnPerDir(exptSect),
    error('trialsPerDir cannot be less nFieldOnPerDir!')
  end
  nTrials=trialsPerDir(exptSect)*nDirs;
  if strcmp(lower(deTabBlank(pattern)),'random walk')      % if random walk
    %subplot(ceil(length(phaseNum)/2),2,exptSect)        %
    figure(1); clf
    TARGS=randomWalk(trialsPerDir(exptSect)         ... %
       ,nFieldOnPerDir(exptSect)                    ... %
       ,offDirs(exptSect,:),on_Dirs(exptSect,:)     ... % 
       ,Mag,C,StPt,fieldType(exptSect),W);                     %
    title(['Section ' num2str(exptSect) ' (Phase '  ... % title on plot
        num2str(phaseNum(exptSect)) ')'])           %
    print -dpsc2 -append patterns.ps
  elseif strcmp(lower(deTabBlank(pattern)),'center out')   % if center out
    TARGS=centerOut(trialsPerDir(exptSect)          ... %
       ,nFieldOnPerDir(exptSect)                    ... %
       ,offDirs(exptSect,:),on_Dirs(exptSect,:)     ... % 
       ,Mag,C,fieldType(exptSect));                     %
   else
     size(pattern)
    fprintf(['\nUnknown pattern "' deTabBlank(pattern) '" .']);%
    return
  end % END 
  phaseNum(exptSect)*ones(nTrials,1);
  %size(TRG),size(TARGS),size(phaseNum(exptSect)*ones(nTrials,1))
  TRG=[TRG;                                         ... % add targets&
   TARGS phaseNum(exptSect)*ones(nTrials,1)];           %  phase# to list  
end  
TRG=[(1:size(TRG,1))' TRG];                             % insert trial# as col 1
Ntrials=size(TRG,1);

% __ display info about trial times, etc __
te=Ntrials*4/60;                                        % estimated time
if strcmp(lower(deTabBlank(pattern)),'center out'),        % if center out
  te=te*2;                                              % time2return2center
end                                                     %
fprintf('\n\n%d trials. ',  Ntrials)                    %  
fprintf(' Est.time: %.1f min (%f hours).',te,te/60);    % estimate time 4 sec/trial 

% __ header___
h=str2mat('Trial Definitions (Patton)',             ... %
  sprintf('targets generated by %s using %s on %s.' ... % 
  ,prog_name,fileName,whenis(clock))                ... %
  ,['Protocol=' protocolName ]                      ... %
  ,['Pattern=' pattern  ]                           ... %
  ,['Number of total trials=' sprintf('%d',Ntrials)]... % 
  ,[sprintf(' Est.time: %.1fmin (%fhr).',te,te/60)] ... % 
  ,['Number of directions=' sprintf('%d',nDirs)]    ... % 
  ,['Number of phases=' sprintf('%d',Nphases)]      ... %
   );        %

for i=1:length(trialsStruct)                            % 
  h=str2mat(h,                                      ... %
   ['phase ' num2str(i) ' name=' trialsStruct(i).name]);
end  
h=str2mat(h,['phases of interest='                  ... %
     sprintf('%d ',phasesOinterest)]                ... %
  ,''                                               ... %   
  ,'(the data below viewed best in EXCEL)'          ... %
  ,''                                               ... %
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

trialsStruct=makeTrialsStruct(outName,trialsStruct,outNum); % make a list of trials for phases

%__ print graphic if any ___
fprintf('\nplotting..'); pause(.01);
if 0%strcmp(lower(deTabBlank(pattern)),'random walk')        % if random walk
  suptitle(str2mat(deTabBlank(protocolName),           ... %
    [deTabBlank(pattern) ', filename=' outName]));
  fprintf('printing:\n'); pause(.01);
  cmd=['print -depsc2 ' outName '.eps'];
  disp(cmd);   eval(cmd);
  figure(2)
end % END if
clf

if 0
  fprintf('\nplotting more..'); pause(.01);
  for i=1:size(TRG,1),
    plot([TRG(i,2) TRG(i,4)],...
          [TRG(i,3) TRG(i,5)],colors(TRG(i,9)))
     hold on; axis equal; axis off; 
     plot(C(1),C(2),'+')
     plot(StPt(1),StPt(2),'o')
  end
end

%playwav('done.wav');
fprintf('\n~ END %s ~ \n',prog_name)                    % 
return % ************ END of main fcn ***************




%**************** MATLAB "M" fcn (Patton) ***************
% centerOut(): make list of trajectories, all origniating from center
%_________________ BEGIN: ___________________

function d=centerOut(trialsPerDir,nFieldOnPerDir,offDirs,on_Dirs,Mag,C,fieldType)

% ============ SETUP ============
nDirs=length(on_Dirs);                        % number of Dirs
totalTrials=(trialsPerDir)*nDirs;             % calc total trials for this
junk=zeros(totalTrials,1);                    % initialize
ok=0;

% ============ RENDER ============ 
% __make a list of mvmts __
count=0;
for D=1:nDirs,
  for i=1:nFieldOnPerDir,                     % loop for field on
    count=count+1;      
    d(count,:)=[fieldType on_Dirs(D) Mag];
  end
  for i=1:(trialsPerDir-nFieldOnPerDir),      % loop for field off
    count=count+1;
    d(count,:)=[0 offDirs(D) Mag];
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

function d=randomWalk(trialsPerDir,nFieldOnPerDir,offDirs,on_Dirs,Mag,C,StPt,fieldType,W)

% ============ SETUP ============
nDirs=length(on_Dirs);                                  % number of Dirs
totalTrials=(trialsPerDir)*nDirs;                       % calc total trials for this
junk=zeros(totalTrials,1);                              % initialize
ok=0;
xL=.44;
yL=.4;
j=1;

% __make a list of mvmts __
count=0;
for D=1:nDirs,
  for i=1:nFieldOnPerDir,                               % loop for field on
    count=count+1;      
    d(count,:)=[fieldType on_Dirs(D) Mag];
  end
  for i=1:(trialsPerDir-nFieldOnPerDir),                % loop for field off
    count=count+1;
    d(count,:)=[0 offDirs(D) Mag];
  end
end                                                     % END for D

% __randomly mix the list__
%fprintf('\n Randomizing..')
[junk,I]=sort(rand(count,1));                           % obtain a random order
d=d(I,:);                                               %

if nFieldOnPerDir~=0&trialsPerDir~=nFieldOnPerDir,      % if catch trials, 
  d=notConsec(d,trialsPerDir,nFieldOnPerDir,fieldType,count); % disallow 2 consecutive
end                                                     % END if

% __initial plot __
plot([W.xLo W.xHi W.xHi W.xLo W.xLo],               ... % 
     [W.yLo W.yLo W.yHi W.yHi W.yLo],'g'); 
hold on; 
plot(C(1),C(2),'+','markersize',6)                      % 
[startEnd,cPt,notOK]=walk(C,StPt,d,Mag,W);                   % reevaluate it
h=plot([startEnd(1,1); startEnd(:,3)],              ... %
       [startEnd(1,2); startEnd(:,4)],'r');             %
hNi=text(W.xLo,W.yHi,'No adjustments necessary', ...
       'fontsize',7);
set(gca,'fontsize',7)
axis equal; drawnow; 
  
% ___ === ADJUST Random walk ==== ___
if notOK,
  %fprintf('Adjusting random walk to fit window..')
  %fprintf('Adjust..')
  fprintf('..')
end
iterationCount=0;
while(notOK)    
  iterationCount=iterationCount+1;                      %
  if round(iterationCount/60)==iterationCount/60,       % every 20
    %fprintf('`')                                        % progress mark
    fprintf('\n')                                        % progress mark
  end
  if cPt==1;                                            % if first is current "bad" point
    for j=count:-1:cPt+1,                               % SEARCH:  GOOD MVMT
      possible=StPt+                                ... %
        Mag*[cos(d(j,2)/180*pi) sin(d(j,2)/180*pi)];    %
      outOfWindow=outsideWindow(possible,W);            %
      if ~outOfWindow, bestPt=j; break; end             % find good movement        
    end                                                 %
    %fprintf('(1<->%d) ',bestPt); 
    fprintf('0');
    d=swapRows(d,bestPt,cPt);                           % swap in good for bad
    d=swapRows(d,bestPt,round(rand(1)*(count-1))+1);    % swap bad elsewhere
  else 
    switch round(rand*3)
    case 1                                              % PUT bad guy AT THE END
      if 1
        q=d(cPt,:); 
        d(cPt,:)=[]; 
        d=[d;q];                   
        fprintf('1');
      end
    case 2,   
      if round(rand*10)==1,
        d=swapRows(d,round(rand*(count-1))+1,cPt);          %
        fprintf('2');        
      end
      % __put early bad mvmt at end__
      if 0
        k=0;                                              % init
        for j=1:cPt-1,                                    % SEARCH FOR EARLY BAD MVMT
          switch notOK                                    % 
          case 1 % W.xLo                                  %
            if startEnd(j,3)<startEnd(j,1); k=j; break,end  % choose a bad guy
          case 2 % W.xHi   
            if startEnd(j,3)>startEnd(j,1); k=j; break,end  % choose a bad guy
          case 3 % W.yLo
            if startEnd(j,4)<startEnd(j,2); k=j; break,end  % choose a bad guy
          case 4 % W.yHi
            if startEnd(j,4)>startEnd(j,2); k=j; break,end  % choose a bad guy
          end % switch notOK
        end % for j
        if k~=0, q=d(k,:); d(k,:)=[]; d=[d;q]; end          % PUT bad guy AT END
        fprintf('2');
      end
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
        for j=cPt-2:-1:1,                                 % SEARCH: BEST early GOOD MVMT
          %startEnd(cPt-1,3:4)
          %Mag*[cos(d(j,2)/180*pi) sin(d(j,2)/180*pi)]
          possible=startEnd(cPt-1,3:4)+               ... %
            Mag*[cos(d(j,2)/180*pi) sin(d(j,2)/180*pi)];  %
          PosDist2ctr=sqrt( (possible(1)-C(1))^2 +    ... % possible dist
            (possible(2)-C(2))^2  );                      %
          if PosDist2ctr<bestDist2ctr,                    %              
            bestDist2ctr=PosDist2ctr; bestPt=j; 
          end % END if PosDist2ctr
        end % for j
        %bestPt,cPt
      end  % END if cPt<count-4,
      fprintf('3');
      d=swapRows(d,bestPt,cPt);
    end % ENS switch ..
  end % END if cPt==1
  
  if nFieldOnPerDir~=0&trialsPerDir~=nFieldOnPerDir,      % if catch trials, 
    %fprintf('Check')
    d=notConsec(d,trialsPerDir,nFieldOnPerDir,        ... % disallow 2 consecutive
      fieldType,count);                                   %
  end                                                     % END if 
 
  % reevaluate & plot
  [startEnd,cPt,notOK]=walk(C,StPt,d,Mag,W);              % evaluate start& endpoints
  set(h,'XData',[startEnd(1,1); startEnd(:,3)],       ... %
        'YData',[startEnd(1,2); startEnd(:,4)])           %
  set(hNi,'string',[num2str(iterationCount) 'iterations']);
  title([num2str(iterationCount) ...
      ' Iterations, notOK=' num2str(notOK) ...
      ' cPt=' num2str(cPt)])
  %zoom(.5); 
  axis equal; drawnow; 
  pause(.02)
  
end % while
%axis off;

%clf; 
load('train'); sound(y(1:300)); pause(1);
%comet([startEnd(1,1); startEnd(:,3)],     ...
%      [startEnd(1,2); startEnd(:,4)],.4)
pause(.01)
%iterationCount
%disp('pause..');pause
d=[startEnd d];

return                                                  % END function makeSubList


%***************** MATLAB "M" fcn (Patton) ****************
% Walk(): calc & eval random walk 
%_________________ BEGIN: ___________________

function [startEnd,cPt,notOK]=walk(C,StPt,d,Mag,W)
notOK=0;
count=size(d,1);
startEnd(1,:)=[StPt StPt+Mag*[cos(d(1,2)/180*pi)  ... % do row 1
                        sin(d(1,2)/180*pi)] ];  %

% calc walk points
for i=2:count,                                  % 
    startEnd(i,:)=[startEnd(i-1,3:4),       ... %
     startEnd(i-1,3:4)+                     ... %
     Mag*[cos(d(i,2)/180*pi) sin(d(i,2)/180*pi)]];%
end % for i 

% calc points and do 1 corrections
for i=1:count,     
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
      fprintf('c');
      ok=0;                                          % flag the problem
    end  % if
  end % for i 
  %d,  disp('...hit a key...'); pause
end % while
%disp('DONE! hit a key'); pause

return


%***************** MATLAB "M" fcn (Patton) ****************
% outsideWindow(q,W) determine if outside windowW
%_________________ BEGIN: ___________________

function notOK=outsideWindow(q,W)

notOK=0; % init

if(q(1)<W.xLo) notOK=1; end   % 1st boundary cross
if(q(1)>W.xHi) notOK=2; end   % 
if(q(2)<W.yLo) notOK=3; end   %
if(q(2)>W.yHi) notOK=4; end   % 

return




