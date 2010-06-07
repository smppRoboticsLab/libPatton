% objective function that takes the approriate params for opto
% USES NLIN LEAST SQUARES, SO THE OUTPUT IS A VECTOR OF ERRORS
function [forceErrorVect,stackFmdl]=CCobjective(CCparams,trialList,trialData,Dirs,I,P,stackFmeas,len,g,verbose)

% unwrap params into CCB struct
CCB.M(1,1)=CCparams(1); 
CCB.M(2,1)=CCparams(2); 
CCB.M(1,2)=CCparams(3); 
CCB.M(2,2)=CCparams(4);           
CCB.L(1)=CCparams(5); 
CCB.L(2)=CCparams(6);           
CCB.R(1)=CCparams(7); 
CCB.R(2)=CCparams(8);         
CCB.K(1,1)=CCparams(9); 
CCB.K(2,1)=CCparams(10); 
CCB.K(1,2)=CCparams(11); 
CCB.K(2,2)=CCparams(12);         
CCB.B(1,1)=CCparams(13); 
CCB.B(2,1)=CCparams(14); 
CCB.B(1,2)=CCparams(15); 
CCB.B(2,2)=CCparams(16); 
CCB.X=CCparams(17); 
CCB.Y=CCparams(18); 

x=1;y=2;                                                % for indexing
Ntrials=length(trialList);
nDir=length(Dirs);

% loop for trials
stackFmdl=[];
for pertTrial=1:Ntrials
  if verbose,
    fprintf('\nTrial %d,',trialList(pertTrial)); 
  end 
  Dir=trialData(trialList(pertTrial),7);                  % DIRECTION
  Mag=trialData(trialList(pertTrial),8);                  % MAGNITUDE
  for i=1:nDir,if(Dir==Dirs(i)),dirIndex=i;break;end;end  % find
  
  [Mforce,St,StI,len]=ccEval4(P(pertTrial).rho,       ... %
            I(dirIndex).rho,CCB,len,g,verbose);
  
  %__ measured perturbing force ("b" vect) __
  stackFmdl=[stackFmdl;                               ... %
             Mforce(:,x);                             ... % stack x&y on top of ea other
             Mforce(:,y)];                                %            
end                                                       % END for pertTrial
if verbose, fprintf('Mforce:<%d by %d>.',size(Mforce));end%

forceErrorVect=(stackFmdl-stackFmeas);

return