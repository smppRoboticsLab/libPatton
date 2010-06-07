% ************** MATLAB "M" function (jim Patton) *************
% Fit a model of dynamics & control of reaching given a set of CCB fcns.
%
% Uses the "numerical recipes in C" nomenclature and approach: construct an 
% A matrix and b vector, and a alpha matrix and beta vector from these.
%           
% The structurte of the model is based on the following :
%
%     o==>"end kinetics:" force and torque at endpoint
%      \
%      (m2)
%        \  q2
%         o   -   -   -   -   -   -	
%        /                 M is mass vect, R is  segment lengths, 
%      (m1)                L is distal-to-segment mass ctr., 
%      /   q1              q is positive for countrclockwise rot from horizontal
%   __o___  -   -   -   -   -   -   
%   \\\\\\\
% This assumes the following form: 
%                     D+delta-C=0
% where D is the passive dyanmic response as a function of pos vel and acc,
%       delta is the the torques due to field forces
%       C is the sliing mode controller torques, the form of the controller is: 
%                     C=Cff=Cfb
%       where  Cff are torques supplied by the internal model of the plant (D)
%                  along the expected trajectory "qe(t)."
%              Cfb are the torques supplied by the feedback components K and B:
%                     Cfb=K(q-qe)
% SYNTAX:    [d,r,aveErr]=model_fit2(CCB,History2,verbose,plot_or_not);
% INPUTS:    CCB        Global struct of CCB function params. see set_params.m
% OUTPUTS:   CCB         coeficients
% VERSIONS:  5/6/99     INITIATED by Patton from inverse_dynamics.m
%            9/14/99    changed name to copycatFit from ?
%            9/17/99    changed name to ccFit from copycatFit 
%            9/20/99    Changed name to ccFit3 and interphased 
%                       with trials via files, not History2 cell array
%            9/24/99     changed name to ccFit4 from ccFit3, added var trialList
%            10/18/99   plotIt input arguement added            
%            3/6/00     multiple directions; baseline no longer 1st on trialList
%            5/10/00    merge coef "cc" into CCB struct, rename ccfit6
%            5/11/00    loop and lay own more, add fitOrNot, rename ccfit7
%            5/30/00    ccFit8: add input CCwings.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [CCB,r,aveErr,fracErr]=ccFit8(CCB,maxTime,trialList,fitOrNot,CCwings,verbose,plotIt);

%_________ SETUP ________
global DEBUGIT L g                                      % g=accel due to gravity
fcnName='ccFit8.m';
if ~exist('verbose'), verbose=1; end                    % if not passed
if ~exist('plotIt'), plotIt=1; end                      % if not passed
x=1;y=2;                                                % for indexing
cutoff=10;                                              % cutoff freq for filtering
Ntrials=length(trialList);
%if plotIt, figure(1); clf; drawnow; pause(.01); end     % set plot window
lastVAF=0;delta=88888;
[trialHeader,trialData]=hdrload('targ.txd');            % load list of movements 
CD=parse(cd,'\');dirName=deblank(CD(size(CD,1),:)); 
subj=dirName(length(dirName)-1:length(dirName))

%__ MESSAGES __
if verbose, fprintf('\n ~ %s ~ \n',fcnName); end        %
if verbose,  fprintf('  %d Trials',Ntrials); end        %      
if verbose,  fprintf('  %d Bases',length(CCB)); end     %      
if verbose,  fprintf(', %.2f sec. ',maxTime); end       %
if verbose,  fprintf('\n Trial List: '); end            %
if verbose,  fprintf(' %d',trialList); end              %

%__load perturbation data__
fprintf('\nLoad Perturbation trials: ');                % 
Dirs=trialData(trialList(1),7);                         % init with 1st DIRECTION
for pertTrial=1:Ntrials                                 % loop for each perturbation trial
  Dir=trialData(trialList(pertTrial),7);                % DIRECTION
  Mag=trialData(trialList(pertTrial),8);                % MAGNITUDE
  if(sum(Dir==Dirs)==0), Dirs=[Dirs Dir]; end           % add2list of directions
  fname=['FD-' num2str(trialList(pertTrial)) '.dat'];   % construct perturb filename
  if verbose,fprintf('%d ',trialList(pertTrial));end    % 
  [P(pertTrial).rho,P(pertTrial).force,Hz]=         ... % load & transform to subj  c.s.
    loadRobotData(fname,cutoff,~verbose);               %
  if plotIt,                                            %
    plot(P(pertTrial).rho(:,x),P(pertTrial).rho(:,y));  %
    hold on; axis equal                                 %
    drawnow; 
  end                                                   %
  pause(.01);                                %  
end                                                     %
fprintf('Done. \n');                                    %
P 
fprintf('\n'); Dirs=sort(Dirs), nDir=length(Dirs);      % re-order ascending & count  

%__ load "INTENDED" or 'baseline' data  __              %
fprintf('\nLoad "intended" trials for direction: ');    %  
for Dir=1:nDir                                          % loop for each direction
  fname=['baseline' num2str(Dirs(Dir)) '.dat'];         % construct filename
  if verbose, fprintf('%d ',Dirs(Dir)); end             % 
  I(Dir).rho=loadRobotData(fname,cutoff,0);             % load & transform to subj c.s. 
  if plotIt,                                            % if plots selected
    plot(I(Dir).rho(:,x),I(Dir).rho(:,y),'r.');         %
    drawnow; %disp('hit it.');
    pause(.01);                                         % 
  end                                                   %
end                                                     %
fprintf('Done. \n');                                    %
I

if plotIt,                                              %__ plot print __
  if fitOrNot,                                              %__ plot print __
    title(str2mat('CCtrials for Fitting, ', cd)); 
  else
    title(str2mat('CCtrials for Validation, ', cd)); 
  end
  xlabel('m'); ylabel('m'); 
  print -dpsc2 -append ccFit; clf
end                                                     %

% ==== BIG LOOP ====
Count=0;                                                % iteration Counter
while (delta>.005),
  Count=Count+1;
  if verbose&fitOrNot, 
    fprintf('\n\nCCB Iteration #%d for: \n %s\n',Count,cd); 
  end
  
  %_________ CONSRUCT "A" MATRIX & "b" vect ________
  A=[]; b=[];  rho=-1;
  for pertTrial=1:Ntrials
    Dir=trialData(trialList(pertTrial),7);              % DIRECTION
    Mag=trialData(trialList(pertTrial),8);              % MAGNITUDE
    for i=1:nDir,if(Dir==Dirs(i)),dirIndex=i;break;end;end  % find
    
    %___ LOOP FOR EACH CCB FUNCTION ("A" MATRIX ) ___
    if verbose, fprintf('\nTrial %d, CCbasis#: ', ...
        trialList(pertTrial)); 
    end  
    stackedFcc=[];                                      % Init 
    for base=1:length(CCB)                              % loop each CCB function
      if verbose, fprintf('%d ',base); end              %
      len=maxTime*Hz;                                   % init frames 2 analyze
      [Fcc,St,StI,len]=ccEval4(P(pertTrial).rho     ... % EVALUATE CCB
         ,I(dirIndex).rho,CCB(base),len,g,0);  %
      stackedFcc(:,base)=[Fcc(:,x); Fcc(:,y)];          % stack x&y on top of ea other
    end                                                 % END for CCB
    
    %__ measured perturbing force ("b" vect) __
    stackedF=[P(pertTrial).force(St:St+len,x);      ... % stack x&y on top of ea other
              P(pertTrial).force(St:St+len,y)];                
    
    %__ check for nonreal elements (means bad inv kin) __
    if isreal(stackedFcc),A=[A;stackedFcc];b=[b;stackedF];% stack trials on topa ea other
    else fprintf('\n\7!nonreal elements! -skipping.\n');
    end  
  end                                                   % END for pertTrial
  
  %_________ LEAST SQUARES SOLUTION ________
  if fitOrNot,
    if verbose,                                         %
      fprintf('\n Least Squares solution:')             %
      fprintf('\nA:<%d,%d>, b:<%d,%d>. ',          ...  %
        size(A),size(b));%
    end   
    alpha=A'*A; beta=A'*b;                              % construct alpha and beta 
    %fprintf('Pseudoinv...'); cc=pinv(alpha)*beta;      % pseudoinverse (SVD)
    fprintf('NonNegative...'); cc=nnls(alpha,beta);   % find nonnegative linear sln
    for i=1:length(CCB), CCB(i).cc=cc(i); end           % need vect form
  else  for i=1:length(CCB), cc(i,1)=CCB(i).cc; end     % load back into vect
  end
  
  %_________ model fit measures ________
  corMTX=corrcoef(A*cc,b);  r=corMTX(1,2);
  aveErr=sqrt(sum((A*cc-b).^2))/size(A,1)/max(b);
  fracErr=sum((abs(A*cc-b))) / sum(abs(b)) ;
  delta=r^2-lastVAF;
  lastVAF=r^2;
  if verbose, 
    for i=1:length(CCB),
      fprintf('\ncc(%d)=%.29g',i,CCB(i).cc); 
    end;
    fprintf('\n model fit: (cc to data)');
    fprintf('\n rsquared=%.4f',r^2);  
    fprintf('\n aveErr=%.4f',aveErr);  
    fprintf('\n fracErr=%.4f',fracErr);  
    if fitOrNot, fprintf('\n\n deltaVAF=%.4f',delta); end 
  end       
  
  %_________ PRUNE AND ADD BASES ________
  if fitOrNot,
    %__ remove unneeded (zero coef) bases __ 
    if verbose, fprintf('\n Pruning Bases:'); end
    i=2;
    while i<=length(CCB)                               % EACH basis 'cept 1st
      if CCB(i).cc<eps*10, 
        if verbose, fprintf(' %d',i); end
        CCB(i)=[]; 
      else i=i+1; 
      end 
    end 
    if verbose, fprintf(' DONE. \n',i); end
    CCB
  
    %__ add bases __ 
    if delta>.005 & length(CCB)>1,                      % if half pct improvement
      if verbose, fprintf('\n Adding Bases.'); end

      %__ by averaging __ 
      if length(CCB)<5,
        if verbose, fprintf('.averages.'); end
        CCB=CCBmean(CCB,1:length(CCB));                   % average all together
        for i=1:length(CCB)-1,  
          for j=i+1:length(CCB); 
            if verbose, fprintf('.'); end
            CCB=CCBmean(CCB,[i j]);                       % average individual pairs
          end; 
        end
        if verbose, fprintf('Done.\n'); CCB, end      
      end

      %__ by sprouting __ 
      if verbose, fprintf('\nSprouting..'); end
      best=1; 
      for i=2:length(CCB);                              % find max to sprout near
        if CCB(i).cc>CCB(best).cc, best=i; end;
      end
      CCB=setupCopycat3(CCB,CCB(best).M,CCB(best).L ... % add copycat bases
       ,CCB(best).R,CCB(best).K,CCB(best).B         ...
       ,CCB(best).X,CCB(best).Y,CCwings,1/(Count*10) )          
      if verbose, fprintf(' DONE ADDING. \n',i); end
    end % END if delta
  else delta=0;                                         % reset if not fitting
  end % if fitOrNot
  
end %END  while delta  <=============================

%__ final removal of unneeded (zero coef) bases __ 
if verbose, fprintf('\n Final Pruning of Bases:'); end
i=1;
while i<=length(CCB)                                    
  if CCB(i).cc<eps*10, 
    if verbose, fprintf(' %d',i); end
      CCB(i)=[]; 
    else i=i+1; 
    end 
  end 
if verbose, fprintf(' DONE. \n',i); end
CCB

%_________ DISPLAY ________
if verbose, 
  fprintf('\n\n FINAL CC RESULTS:');
  for i=1:length(CCB),
    fprintf('\ncc(%d)=%.29g',i,CCB(i).cc); 
  end;
  fprintf('\n model fit: (cc to data)');
  fprintf('\n rsquared=%.4f',r^2);  
  fprintf('\n aveErr=%.4f',aveErr);  
  fprintf('\n fracErr=%.4f',fracErr);  
  fprintf('\n ~ END %s ~ \n',fcnName); 
end

%________ plot model predictions _______
if plotIt %& ~fitOrNot,                             % plot data if validating
  fprintf('\n\n plot model fit:\n');
  for pertTrial=1:Ntrials
    Dir=trialData(trialList(pertTrial),7);              % DIRECTION
    Mag=trialData(trialList(pertTrial),8);              % MAGNITUDE
    for i=1:nDir,if(Dir==Dirs(i)),dirIndex=i;break;end;end  % find
    
    %___ LOOP FOR EACH CCB FUNCTION ("A" MATRIX ) ___
    if verbose, fprintf('\nTrial %d, CCbasis#: ', ...
        trialList(pertTrial)); 
    end  
    for base=1:length(CCB)                              % loop each CCB function
      if verbose, fprintf('%d ',base); end              %
      len=maxTime*Hz;                                   % amount of time to analyze
      [Fcc,St,StI,len]=ccEval4(P(pertTrial).rho     ... % EVALUATE CCB
        ,I(dirIndex).rho,CCB(base),len,g,0);  %
      if base==1,
        modelForce=zeros(len+1,2);                      % Init 
      end
      %size(modelForce), size(Fcc)
      modelForce=modelForce+CCB(base).cc*Fcc;
    end                                                 % END for CCB
    
    %__ check for nonreal elements (means bad inv kin) __
    if isreal(stackedFcc),A=[A;stackedFcc];b=[b;stackedF];% stack trials on topa ea other
    else fprintf('\n\7!nonreal elements! -skipping.\n');
    end  

    %for i=1:2;                                          % setup plot windows
    %  figure(i); clf;  
    %  put_fig(i,.1+i*.1,.1-i*.05,.4,.7); orient tall; 
    %end
    if pertTrial==1,
    plotCCBTrial(P(pertTrial).rho,                ... %local fcn to plot this trial
                   P(pertTrial).force,              ... % 
                   I(dirIndex).rho,modelForce,      ... %
                   Hz,St,StI,len,                   ... %
                   maxTime);
                   %trialData(trialList(pertTrial),2:5));%
      figure(1);                                        % 
      %suptitle(['Subject ' subj ', ' 'trial '       ... %
      %          num2str(trialList(pertTrial))       ... %
      %          ', ' num2str(maxTime) ' s'          ... %
      %          ])                                      %
      print -dpsc2 -append ccFit                        %
      figure(2);                                        %
      suptitle(['Subject ' subj ', ' 'trial '       ... %
                num2str(trialList(pertTrial))       ... %
                ', ' num2str(maxTime) ' s'          ... %
              ])                                      %
    end % END if pertTrial        
  end                                                   % END for pertTrial
end                                                     % END if plotIt,                

return



% ************** MATLAB "M" function (jim Patton) *************
% create a CCB from an average of others (specified by "list")
% SYNTAX:    
% INPUTS:    
% OUTPUTS:   
% VERSIONS:  5/15/00    init
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function CCB=CCBmean(CCB,list)

    Msum=zeros(2,2); Lsum=zeros(2,1); Rsum=zeros(2,1);     % init
    Ksum=zeros(2,2); Bsum=zeros(2,2); Xsum=0; Ysum=0;      % init
    len=length(list);    CClen=length(CCB);
    for i=1:len                                            % LOOP 
      Msum=Msum+CCB(list(i)).M;
      Lsum=Lsum+CCB(list(i)).L;
      Rsum=Rsum+CCB(list(i)).R;
      Ksum=Ksum+CCB(list(i)).K;
      Bsum=Bsum+CCB(list(i)).B;
      Xsum=Xsum+CCB(list(i)).X;
      Ysum=Ysum+CCB(list(i)).Y;
    end
    CCB(CClen+1).M=Msum/len;
    CCB(CClen+1).L=Lsum/len;
    CCB(CClen+1).R=Rsum/len;
    CCB(CClen+1).K=Ksum/len;
    CCB(CClen+1).B=Bsum/len;
    CCB(CClen+1).X=Xsum/len;
    CCB(CClen+1).Y=Ysum/len;
    CCB(CClen+1).cc=0;
    
return


% ************** MATLAB "M" function (jim Patton) *************
% plot data
% SYNTAX:    
% INPUTS:    
% OUTPUTS:   
% VERSIONS:  5/15/00    init
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function plotCCBTrial(rho,force,rhoI,modelForce,Hz,St,StI,len,maxTime)

global L 
      forceScale=.002;
      time=(0:length(rho(:,1))-1)/Hz;
      time=time';
      
      % ____ Actual xy-position & force _____
      %plot(sum(L)*cos(60/180*pi:.1:120/180*pi),    ... % plot workspace
      %  sum(L)*sin(60/180*pi:.1:120/180*pi),'g');      % ...
      %hold on
      %figure(1); clf; %orient landscape;
      %subplot(2,1,1);
    if maxTime==.1,
      subplot(2,3,1);
      plot(rho(:,1),rho(:,2),'b.');                                %
      hold on
      plotbox(.025,.53,.2,'w')
      F_x=[]; F_y=[];
      for i=St:size(force,1),                           % assemble quiver points
        F_x=[F_x
          NaN
          rho(i,1)
          rho(i,1)+forceScale*force(i,1)];
        F_y=[F_y
          NaN
          rho(i,2)
          rho(i,2)+forceScale*force(i,2)];
      end  
        F_x=[F_x                                        % add force scale for legend
          NaN
          .02
          .02+forceScale*10];
        F_y=[F_y;
          NaN
          .42
          .42];
        F_x=[F_x                                        % add position scale for legend
          NaN
          .02
          .02+.01];
        F_y=[F_y;
          NaN
          .45
          .45];
        plot(F_x,F_y,'r');                              % plot all forces
      text(.02,.42,'10 N','VerticalAlignment','bottom') %
      text(.02,.45,'1 cm','VerticalAlignment','bottom') %
      %plotbox(targs(1),targs(2),.005);
      %plotbox(targs(3),targs(4),.005);
      title('Measured Forces');                          %
      ylabel('m'); xlabel('m');                         %
      axis equal;  
      axis tight;
      ax=axis;
      plot([ax(1) ax(2) ax(2) ax(1) ax(1)], ...
           [ax(3) ax(3) ax(4) ax(4) ax(3)],'k')
      axis off; 
    end % END if maxTime==.1,
      
      % ____ Model xy-position & force _____
      %subplot(2,1,2); 
      disp('round'); round(maxTime*10+1)
      figure(1); subplot(2,3,round(maxTime*10+1));
      plot(rho(:,1),rho(:,2),'b.'); hold on;            %
      plotbox(.025,.53,.2,'w')
      plot(rho(St:St+len,1),rho(St:St+len,2),'go'   ... %
        ,'markersize',2);                               %
      
      F_x=[]; F_y=[];
      for i=St:St+len,                            % assemble quiver points
        F_x=[F_x
          NaN
          rho(i,1)
          rho(i,1)+forceScale*modelForce(i-St+1,1)];
        F_y=[F_y;
          NaN
          rho(i,2)
          rho(i,2)+forceScale*modelForce(i-St+1,2)];
      end
      if 0
        F_x=[F_x
          NaN
          .02
          .02+forceScale*10];
        F_y=[F_y;
          NaN
          .42
          .42];
        F_x=[F_x                                        % add position scale for legend
          NaN
          .02
          .02+.01];
        F_y=[F_y;
          NaN
          .45
          .45];
        text(.02,.42,'10 N','VerticalAlignment','bottom') %
        text(.02,.45,'1 cm','VerticalAlignment','bottom') %
      end
      plot(F_x,F_y,'r');
      title(['Model-predicted forces, ' num2str(maxTime),' seconds']);%
      ylabel('m'); xlabel('m');                         %
      %fprintf('\n\7Pause...'); pause
      axis equal;  
      axis tight; 
      axis off; 
     
      % ____ VELOCITY VS TIME _____
      figure(2); subplot(3,1,2)                         % velocity  
      legend(plot(time, rho(:,3),'r.',              ...
                  time, rho(:,4),'b.',              ...
            time(St:St+len), rho(St:St+len,3),'ro', ...
            time(St:St+len), rho(St:St+len,4),'bo'  ...
            ,'markersize',2 ...
            ),'x','','y',''); 
      title('velocity'); ylabel('m/s');
  
      subplot(3,1,3) % force
      plot( time, force(:,1),'r.',                    ...
            time, force(:,2),'b.',                    ...
            time(St:St+len), force(St:St+len,1),'ro',  ...
            time(St:St+len), force(St:St+len,2),'bo',  ...
            time(St:St+len), modelForce(:,1),'r*',    ... %
            time(St:St+len), modelForce(:,2),'b*'     ...   %
            ,'markersize',2 ...
            ); 
      title('force');  ylabel('N'); xlabel('sec');
      drawnow;  pause(.01)
  
return 
