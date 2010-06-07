% ************** MATLAB "M" function (jim Patton) *************
%Set up all necessary variables and call the optimization routine.
% SYNTAX:    
% INPUTS:    CCB        INITIAL GUESS of params STRUCT. 
% OUTPUTS:   CCB        OPTIMIZED STRUCT
% VERSIONS:             6/8/00     initiated FROM ccFit8
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [CCB,r,aveErr,fracErr]=OptCC(CCB,CCwings,spreadScale,maxTime,trialList,fitOrNot,verbose,plotIt);

%_________ SETUP ________
global DEBUGIT L g                                      % g=accel due to gravity
fcnName='optCC.m';
if ~exist('verbose'), verbose=1; end                    % if not passed
if ~exist('plotIt'), plotIt=1; end                      % if not passed
x=1;y=2;                                                % for indexing
cutoff=10;                                              % cutoff freq for filtering
Ntrials=length(trialList);
if plotIt, figure(1); clf; drawnow; pause(.01); end     % set plot window
lastVAF=0;delta=88888;
[trialHeader,trialData]=hdrload('targ.txd');            % load list of movements 
options = optimset('Display','iter');                   % optimization params

%__ MESSAGES __
if verbose, fprintf('\n ~ %s ~ \n',fcnName); end        %
if verbose,  fprintf('  %d Trials',Ntrials); end        %      
if verbose,  fprintf('  %d Bases',length(CCB)); end     %      
if verbose,  fprintf(', %.2f sec. ',maxTime); end       %
if verbose,  fprintf(', Trial List: \n'); end           %
if verbose,  fprintf(' %d',trialList); end              %

%__load perturb data & assemble a list of directions__
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
    drawnow; pause(.01);                                %  
  end                                                   %
end                                                     %
fprintf('Done. \n');                                    %
P 
fprintf('\n'); 
Dirs=sort(Dirs), nDir=length(Dirs);                     % re-order ascending & count  
len=maxTime*Hz;                                         % frames to analyze

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
  if fitOrNot,                                          %__ plot print __
    title(str2mat('CCtrials for Fitting, ', cd)); 
  else
    title(str2mat('CCtrials for Validation, ', cd)); 
  end
  xlabel('m'); ylabel('m'); 
  print -dpsc2 -append ccFit; clf
end                                                     %

%_____ SET OPTIMIZATION INPUTS _____
CCparams_o=    [CCB.M(1,1);                       % initial guess
                CCB.M(2,1); 
                CCB.M(1,2); 
                CCB.M(2,2);           
                CCB.L(1); 
                CCB.L(2);           
                CCB.R(1); 
                CCB.R(2);         
                CCB.K(1,1); 
                CCB.K(2,1); 
                CCB.K(1,2); 
                CCB.K(2,2);         
                CCB.B(1,1); 
                CCB.B(2,1); 
                CCB.B(1,2); 
                CCB.B(2,2); 
                CCB.X; 
                CCB.Y; 
               ];
CCparams_lb=   [CCB.M(1,1)*(1-CCwings.massSpread*spreadScale); 
                CCB.M(2,1)*(1-CCwings.massSpread*spreadScale); 
                CCB.M(1,2)*(1-CCwings.massSpread*spreadScale); 
                CCB.M(2,2)*(1-CCwings.massSpread*spreadScale);           
                CCB.L(1)*(1-CCwings.geometrySpread*spreadScale); 
                CCB.L(2)*(1-CCwings.geometrySpread*spreadScale);           
                CCB.R(1)*(1-CCwings.geometrySpread/2*spreadScale); 
                CCB.R(2)*(1-CCwings.geometrySpread/2*spreadScale);         
                CCB.K(1,1)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.K(2,1)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.K(1,2)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.K(2,2)*(1-CCwings.impedanceSpread*spreadScale);        
                CCB.B(1,1)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.B(2,1)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.B(1,2)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.B(2,2)*(1-CCwings.impedanceSpread*spreadScale); 
                CCB.X-CCwings.shoulderSpread*spreadScale; 
                CCB.Y-CCwings.shoulderSpread*spreadScale; 
               ];

CCparams_ub=   [CCB.M(1,1)*(1+CCwings.massSpread*spreadScale); 
                CCB.M(2,1)*(1+CCwings.massSpread*spreadScale); 
                CCB.M(1,2)*(1+CCwings.massSpread*spreadScale); 
                CCB.M(2,2)*(1+CCwings.massSpread*spreadScale);           
                CCB.L(1)*(1+CCwings.geometrySpread*spreadScale); 
                CCB.L(2)*(1+CCwings.geometrySpread*spreadScale);           
                CCB.R(1)*(1+CCwings.geometrySpread/2*spreadScale); 
                CCB.R(2)*(1+CCwings.geometrySpread/2*spreadScale);         
                CCB.K(1,1)*(1+CCwings.impedanceSpread*spreadScale);                CCB.K(2,1)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.K(1,2)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.K(2,2)*(1+CCwings.impedanceSpread*spreadScale);         
                CCB.B(1,1)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.B(2,1)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.B(1,2)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.B(2,2)*(1+CCwings.impedanceSpread*spreadScale); 
                CCB.X+CCwings.shoulderSpread*spreadScale; 
                CCB.Y+CCwings.shoulderSpread*spreadScale; 
               ];
  
  %_________ CONSRUCT Stacked Measured force Vector ________
  A=[]; stackFmeas=[];  rho=-1;
  if verbose, fprintf('\nStacking meas F for Trial:'); end  
  for pertTrial=1:Ntrials
    if verbose, fprintf(' %d',trialList(pertTrial)); 
    end  
    Dir=trialData(trialList(pertTrial),7);              % DIRECTION
    Mag=trialData(trialList(pertTrial),8);              % MAGNITUDE
    for i=1:nDir,if(Dir==Dirs(i)),dirIndex=i;break;end;end  % find
    [St,len]=startAndLength(P(pertTrial).rho(:,3:4),len);

    %__ measured perturbing force ("b" vect) __
    stackFmeas=[stackFmeas;                           ... %
               P(pertTrial).force(St:St+len,x);     ... % stack x&y on top of ea other
               P(pertTrial).force(St:St+len,y)];        %            
  end                                                   % END for pertTrial
  fprintf('\nstackFmeas:<%d by %d>.',size(stackFmeas));     %
  
  %_________ NONLINEAR OPTIMIZATION SOLUTION ________
  if fitOrNot,
    if verbose,fprintf('\nNonlin Least Squares: '); end %
    [forceErrorVect_o,stackFmdl_o]=                 ... % eval of initial guess
      CCobjective(CCparams_o,trialList,trialData,   ... % 
      Dirs,I,P,stackFmeas,len,g,~verbose);              %
    figure(4);clf;plot(forceErrorVect_o,'r:');hold on;figure(1);
    [CCparams,resnorm]=lsqnonlin('CCobjective',      ... % call optimization!
      CCparams_o,CCparams_lb,CCparams_ub,options,   ... %  opto params
      trialList,trialData,Dirs,I,P,stackFmeas,len,  ... %  fcn params
      g,~verbose);                                      % 
    cc=1; CCB.cc=1;
  end
  [forceErrorVect,stackFmdl]=                       ... % eval of final result
    CCobjective(CCparams_o,trialList,trialData,     ... % 
    Dirs,I,P,stackFmeas,len,g,~verbose);                %
  figure(4); plot(forceErrorVect,'k'); figure(1);
  
  %_________ model fit measures ________
  corMTX=corrcoef(stackFmdl,stackFmeas);  r=corMTX(1,2);
  aveErr=sqrt(sum(forceErrorVect.^2))/ ...
    size(forceErrorVect,1)/max(stackFmeas);
  fracErr=sum((abs(forceErrorVect))) / ...
  sum(abs(stackFmeas)) ;
  delta=r^2-lastVAF;
  lastVAF=r^2;
  if verbose, 
    fprintf('\n\nMODEL FIT:');
    fprintf('\n rsquared=%.4f',r^2);  
    fprintf('\n aveErr=%.4f',aveErr);  
    fprintf('\n fracErr=%.4f',fracErr);  
  end       
  
%________ plot model predictions _______
fprintf('\n\n plot model fit:\n');
for pertTrial=1:Ntrials
    Dir=trialData(trialList(pertTrial),7);              % DIRECTION
    Mag=trialData(trialList(pertTrial),8);              % MAGNITUDE
    for i=1:nDir,if(Dir==Dirs(i)),dirIndex=i;break;end;end  % find
    
    %___ LOOP FOR EACH CCB FUNCTION ("A" MATRIX ) ___
    if verbose, fprintf('\nTrial %d, CCbasis#: ', ...
        trialList(pertTrial)); 
    end  
    modelForce=zeros(len+1,2);                          % Init 
    for base=1:length(CCB)                              % loop each CCB fcn
      if verbose, fprintf('%d ',base); end              %
      len=maxTime*Hz;                                   % frames to analyze
      [Fcc,St,StI,len]=ccEval4(P(pertTrial).rho     ... % EVALUATE CCB
         ,I(dirIndex).rho,CCB(base),len,g,0);  %
      modelForce=modelForce+CCB(base).cc*Fcc;
    end                                                 % END for CCB
    
    if plotIt & ~fitOrNot,                              % plot data if validating
      figure(1)
      plotCCBTrial(P(pertTrial).rho,                ... % local fcn to plot trial
                   P(pertTrial).force,              ... % 
                   I(dirIndex).rho,modelForce,      ... % 
                   Hz,St,StI,len);                      % 
      suptitle(['CC fit trial '                     ... % 
               num2str(trialList(pertTrial))])          % 
      %print -dpsc2 -append opto
    end                                                 % END if plotIt,                
end                                                     % END for pertTrial

return



% ************** MATLAB "M" function (jim Patton) *************
% plot data
% SYNTAX:    
% INPUTS:    
% OUTPUTS:   
% VERSIONS:  5/15/00    init
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function plotCCBTrial(rho,force,rhoI,modelForce,Hz,St,StI,len)

global L 

      time=(0:length(rho(:,1))-1)/Hz;
      time=time';
      clf; subplot(3,1,1) % position xy 
      %plot(sum(L)*cos(60/180*pi:.1:120/180*pi),    ... % plot workspace
      %  sum(L)*sin(60/180*pi:.1:120/180*pi),'g');      % ...
      %hold on
      legend(plot( rho(:,1),rho(:,2),'b.',          ... %
        rho(St:St+len,1),rho(St:St+len,2),'bo',     ... % 
        rhoI(:,1),rhoI(:,2),'g.',                   ... %
        rhoI(StI:StI+len,1),rhoI(StI:StI+len,2),'go'... %
        ,'markersize',2                             ... %
        ),'rho','','rhoI','');                          %
      hold on
      quiver([rho(:,1); rho(St:St+len,1); -.08],    ... % 
             [rho(:,2); rho(St:St+len,2); .48],     ... % 
             [force(:,1); modelForce(:,1); 10],     ... % 
             [force(:,2); modelForce(:,2); 0],'r')      %
      text(-.08,.47,'10 N','VerticalAlignment','bottom')%
      title('Positon and force (actual is red)');       %
      ylabel('m'); xlabel('m');                         %
      axis equal;  axis tight                           %
      
      subplot(3,1,2)                                    % velocity  
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
