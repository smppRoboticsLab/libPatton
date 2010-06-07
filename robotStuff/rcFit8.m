% ************** MATLAB "M" function (jim Patton) *************
% convert a fit of a copycat (cc) model to a robot control (rc) model 
% Uses the "numerical recipes in C" nomenclature and approach: construct an 
% A matrix and b vector, and a alpha matrix and beta vector from these.
% SYNTAX:    
% INPUTS:    
% OUTPUTS:   
% VERSIONS: 9/14/99     INITIATED by Patton from inverse_dynamics.m
%           9/20/99     changed name to rcFit from cc2rcFit, removed 
%                       History2 and put in trials loaded from files
%           9/23/99     changed name to rcFit2 from rcFit, added var "St"
%           9/23/99     changed name to rcFit2 from rcFit, added var "St"
%           9/24/99     changed name to rcFit3 from rcFit2, added var trialList
%           10/5/99     changed name to rcFit4, fit so that the subject learns a field 
%                       who's torque time history along s_hat(t) is the torque 
%                       necessary to swing it to t s_D(t) in after-effects.
%           10/15/99    changed name to rcFit5, add plotIt input args, 
%                       removed RCB (it is global).
%           3/10/00     change name to rcFit6, allow multiple directions 
%           5/10/00     merge rc into struct RCB, change name to rcFit8, which skips
%                       over rcFit7 because that was developed in parallel to do
%                       something else.
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [RCB,r,aveErr,fracErr]=rcFit8(CCB,maxTime,startPt,Dirs,Mag,deflection,verbose,plotIt)

%_________ SETUP ________
clf; pause(.01)
fcnName='rcFit8.m';
global DEBUGIT g RCB                                    % g=accel due to gravity
if ~exist('verbose'), verbose=1; end                    % if not passed
if ~exist('plotIt'), plotIt=1; end                      % if not passed
nDirs=length(Dirs);                                      % number of Dirs
x=1;y=2;                                                % for indexing
A=[]; b=[];                                             % Init
cutoff=10;                                              % filter cutoff freq 
Hz=100;                                                 % sampling freq
speedThresh=.06;
len=maxTime*Hz;                                         % amount of time to analyze
FI=NaN;                                                 % initialize to "not used yet"
L=CCB(length(CCB)).L;                                   % best guess at lengths
colors='rgbkmyc';
deg=180/pi;

%__ MESSAGES __
if verbose,                                             %
  fprintf('\n ~ %s ~ \n',fcnName);                      %
  fprintf('Fitting %d CCBASES w/ %d rcBASES ',      ... %
       length(CCB),length(RCB));                        %  
 fprintf(', %.2f sec. ',maxTime);                       %
end                                                     %

if plotIt,
  subplot(2,1,1)
  for i=1:length(RCB), 
    plot(RCB(i).C(1),RCB(i).C(2),'*');
    hold on
  end  
end

%____ loop for each trajectory____
for Dir=1:nDirs

  %__ GET "INTENDED" SUBJ MVMT (from baseline) __
  fName=['baseline' num2str(Dirs(Dir)) '.dat'];
  if verbose, 
    fprintf('\n  Dir. #%d(%.0fdeg): ',Dir,Dirs(Dir)); 
    fprintf('\n    Load "Intended" (%s)...',fName); 
  end
  [rhoI,forceI,Hz]=loadRobotData(fName,cutoff,0);       % load & transform to subj c.s. 
  qI=inverse_kinematics3(rhoI,1,L);                     % desired segment ang 
  if verbose, fprintf('Done. '); end

  %__ GET "DESIRED" MVMT OF EXPERIMENTER __
  fName=['sin-morphed.txd'];
  if verbose, 
    fprintf('\n    Load "Desired" (%s)...',fName); 
  end
  [rhoD,qD]=getIdealTrajectory(fName,L              ... %
    ,startPt,Dirs(Dir)*pi/180-pi,Mag,deflection     ... %
    ,speedThresh,0);
    rhoD(:,1)=[];    qD(:,1)=[];                        % clip off time column
  if verbose, fprintf('Done. '); end
  
  % __ plot trajectories___
  if plotIt,
    subplot(2,1,1)
    h=plot(rhoI(:,1),rhoI(:,2),[colors(Dir) 's'],   ... %
           rhoD(:,1),rhoD(:,2),[colors(Dir) '>'],   ... %
           'markersize',3);
    hold on
    title('Positions'); xlabel('x (m)'); ylabel('y (m)')% axis lables
    if Dir==1, legend(h,'i','d','45 deg'); end
    axis equal; axis tight
    subplot(2,1,2)
    plot(qI(:,1)*deg,qI(:,2)*deg,[colors(Dir) 's'], ... %
         qD(:,1)*deg,qD(:,2)*deg,[colors(Dir) '>'], ... %
         'markersize',3);
    hold on
    title('Angles (q)');
    xlabel('shoulder (deg)');ylabel('elbow (deg)')% axis lables
    axis equal; axis tight      
  end
  
  %_________ eval CC along desired traject  ________
  if verbose, fprintf('\n    Evaluate Copycat:'); end
  FD=0; 
  for i=1:length(CCB)                                   % loop each basis function 
    if verbose,fprintf('%d',i); end                     % 
    if CCB(i).cc,                                           % if nonzero 
      if verbose,fprintf('.'); end                      % 
      [F,StD,StI,len]=ccEval4(rhoD,rhoI,CCB(i),len,g,0);% eval if intended is used
      if isnan(F), error(' F has NaN (s)! '); end;      %   
      FD=FD+CCB(i).cc*F;                                    %
    else
     if verbose,fprintf(' '); end                       % 
    end  
  end                                                   % END for i
  if verbose, fprintf('Done. '); end 
  
  %__ convert minus CC force along rhoD to torque __
  if verbose, fprintf('\n    Transform forces...'); end
  j=0;
  for i=StD:StD+len
    j=j+1;
    J=jacobian([qD(i,1); qD(i,2)-qD(i,1)], L);          % find jacobian (best guess of L)
    TtoLearn(j,:)=((J')*FD(j,:)')';                     % J' to convert to torque
  end

  %__ convert back to force, but along rhoI __
  j=0;
  for i=StI:StI+len
    j=j+1;
    J=jacobian([qI(i,1); qI(i,2)-qI(i,1)], L);          % find jacobian (best guess of L)
    FtoLearnI(j,:,Dir)=(inv(J')*TtoLearn(j,:)')';       % inv(J') to convert to force
  end
  stackedFtoLearnI=[FtoLearnI(:,x,Dir);             ... % stack x&y on top of 
                    FtoLearnI(:,y,Dir)];                % each other for least squares
  if verbose, fprintf('Done. '); end  
  
  % -rcb setup used to be here-
  
  %__ evaluate RC model BASES ("A" MATRIX) __
  if verbose,fprintf('\n   Evaluate RCB: '); end        %
  for i=1:length(RCB)                                   % LOOP FOR EACH rcBASIS
    if verbose,fprintf('%d ',i); end                    %
    Frc=rcEval3(rhoI,RCB(i),0);                         % rc force evaluations 
    Frc=Frc(StI:StI+len,:);                             % clip to these times only
    stackedFrcI(:,i)=[Frc(:,x); Frc(:,y)];              % stack x&y on topa ea other
  end                                                   % END for i
  if verbose, fprintf('Done. '); end   

  A=[A; stackedFrcI];                                   % trials on top of ea other
  b=[b; stackedFtoLearnI];                 
  
  % plotting programs used to be here but were removed
  
end                                                     % END for Dir

%_________ LEAST SQUARES SOLUTION ________
if verbose,   
  fprintf('\nLeast square (A<%d,%d>, b<%d,%d>)'     ... %
    ,size(A),size(b));                                  %
end   
alpha=A'*A; beta=A'*b;                                  % construct alpha and beta
%fprintf('QR decomposition'); RCB(:).rc=alpha\beta;          
fprintf('NonNeg LS sln:'); rc=nnls(alpha,beta,1);       % find nonnegative linear sln
%fprintf('(pseudoinverse)..'); rc=pinv(alpha)*beta;     %
if verbose,  fprintf('Done.'); end
for i=1:length(RCB), RCB(i).rc=rc(i); end

%_________ model fit measures ________
corMTX=corrcoef(A*rc,b);  r=corMTX(1,2);
aveErr=sqrt(sum((A*rc-b).^2))/length(A(:,1));
fracErr=sum(  (abs(A*rc-b))./b  )/size(A,1);

%_________ DISPLAY ________
if verbose, 
  for i=1:length(rc),
    fprintf('\nrc(%d)=%.6f',i,rc(i)); 
  end;
  fprintf('\n MODEL FIT: (rc to cc)');
  fprintf('\n   rsquared=%.4f',r^2);  
  fprintf('\n   aveErr=%.4f N',aveErr);  
  fprintf('\n   fracErr=%.4f',fracErr);  
  fprintf('\n ~ END %s ~ \n',fcnName); 
end       

%_________ PLOT ________
if plotIt,
  %fprintf('\n\n hit a key ...');pause
  print -dpsc2 RCBfit.ps
  if verbose,fprintf('\n   PLOT.. '); end        %
  %clf
  for Dir=1:nDirs
    clf
    
    %__ GET "INTENDED" SUBJ MVMT (from baseline) __
    fName=['baseline' num2str(Dirs(Dir)) '.dat'];
    if verbose, 
      fprintf('\n  Dir. #%d(%.0fdeg): ',Dir,Dirs(Dir)); 
      fprintf('    Load "Intended" (%s)...',fName); 
    end
    [rhoI,forceI,Hz]=loadRobotData(fName,cutoff,0);     % load & transform to subj c.s. 
    qI=inverse_kinematics3(rhoI,1,L);                   % desired segment ang 
    if verbose, fprintf('Done. '); end

    %__ plot each rcb contribution as a thin line__
    sumFrc=zeros(size(rhoI,1),2);                         % init
    for i=1:length(RCB)                                   % LOOP plot EACH rcBASIS 
      Frc=rcEval3(rhoI,RCB(i),0);                         % calc this RCB force contrib 
      Frc=RCB(i).rc*Frc;                                      % multiply by coeficient
      %subplot(2,1,1); 
      %plot((1:size(sumFrc,1))-StI,Frc(:,1),'r:'); hold on; % plot x
      %subplot(2,1,2); 
      %plot((1:size(sumFrc,1))-StI,Frc(:,2),'r:'); hold on; % plot y
      sumFrc=sumFrc+Frc;
    end                                                   % END for i 
    
    %__ plot RCB sum__
    %subplot(2,1,1);    
    plot((1:size(sumFrc,1))-StI,sumFrc(:,x),'b'); hold on
    %subplot(2,1,2);    
    plot((1:size(sumFrc,1))-StI,sumFrc(:,y),'g'); hold on
        
    %__ plot CCB and RCB on the fitting interval only __
    %subplot(2,1,1);    
    %title('Fx (N)'); 
    legend(plot(1:size(FtoLearnI,1),                  ...
                FtoLearnI(:,x,Dir),'b:',              ...
                1:len+1,                              ...
                sumFrc(StI:StI+len,x),'b',            ...
                'linewidth',2),'CCB','RCB');
    %subplot(2,1,2);    
    %title('Fy (N)'); 
    plot(1:size(FtoLearnI,1),                         ...
                FtoLearnI(:,y,Dir),'g:',              ...
                1:len+1,                              ...
                sumFrc(StI:StI+len,y),'g',            ...
                'linewidth',2);
    suptitle(['Fitting curves, ' num2str(Dirs(Dir)) ' direction']);
    
    print -dpsc2 -append RCBfit.ps    
  end                                                     % END for Dir
  if verbose, fprintf('Done. '); end   
end                                                       % END if plotIt


%__ remove unneeded (zero coef) bases __
fprintf('\n Pruning inneeded RCB:',i)
i=1;
while i<=length(RCB)                                   % LOOP plot EACH rcBASIS 
  if RCB(i).rc<eps*10, 
    fprintf(' %d',i)
    RCB(i)=[]; 
  else
    i=i+1;
  end
end

if verbose,fprintf('\n ~ END %s ~ ',fcnName); end         %
return