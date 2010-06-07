% LearnFit2.m  do an exponential nonlinear regression on a learning curve 
%************** MATLAB "M" function  *************
% This algorithm fits the following  function:
%         f(x)=p(1)+p(2)*exp(-1/P(3))
% by finding the best set of values of p.
% intergers (1, 2, 3, etc). This is excellent tool for fitting learning 
% curves. Future versions will be more fancy. 
% SYNTAX:     BestP=LearnFit(lrn,p0,skip,plotOrNot)
% INPUTS:     D         data values to fit (2 coumns of data)
%             p0        (optional) initial guess vector of three elements 
%             skip      (optional) distnace on x axis before assembilng 
%                         data into a block
%             plotOrNot (optional) nonzero for lotting
% REVISIONS:  5-23-2005  INITIATED  (patton) 
% EXAMPLE:    
%   D=(1:150)'; D(:,2)=20*exp(-D/20)+8*rand(size(D))  % artificial data set
%   BestP=LearnFit2(D,[],10,'yesplot')                % fit this data
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function BestP=LearnFit2(D,p0,skip,plotOrNot)

%% __SETUP_
progName='LearnFit.m';
fprintf('\n\n\n~ %s ~ \n',progName);                    % message
if ~exist('skip')                         ...           % if not passed 
   ||isempty(skip)                        ...           % or if empty
   ||skip<1,                              ...           % or if out o range
  skip=0;                                               %  set to no skip
end
if ~exist('plotOrNot')                    ...           % if not passed 
  plotOrNot=0;                                          %  set to no plot
end
if ~exist('p0')                           ...           % if not passed
   ||isempty(p0),                        ...           % or if empty
    p0=[10 40 35]; 
end
GREY=[.8 .8 .8];                                        % color def
fsz=10;                                                 % desired font size

if plotOrNot                                            % 
  plot(D(:,1),D(:,2),'.','markersize',8,'color',GREY);  % plot raw data
  hold on
end

%% __ RUNNING AVERAGE: blocks of trials for reducing data & averaging
if skip,                                                  % 
  i=1; j=1; BlockCounter=0;                               %
  while j<size(D,1),                                      % keep going until the end of the data
    BlockCounter=BlockCounter+1;                          %
    i=j;                                                  % start at same spot
    while 2                                               % loop until next block ends
      j=j+1;                                              % advance the leading index
      if D(j,1)>skip*BlockCounter, break; end             % if reached the block
      if j==size(D,1), break; end                         % if reached the end
    end                                                   % END while 2
    blockOtrials=i:j;                                     % define rows of D for blockOtrials
    Rx(BlockCounter)=(mean(D(blockOtrials,1)));           % blockOtrials mean x-position (mean trial#)
    Ry(BlockCounter)=(mean(D(blockOtrials,2)))';          % blockOtrials mean value
    RyC(BlockCounter)=(confidence(D(blockOtrials,2),.95))';% calc blockOtrials confidence interval
    if plotOrNot                                          % 
      plot(Rx(BlockCounter),Ry(BlockCounter),'k.' ...     % blockOtrials avg point       [C(subj) '.']
        ,'markersize',12);                                %
      plot([Rx(BlockCounter) Rx(BlockCounter)],   ...     % blockOtrials wing
        [Ry(BlockCounter)+RyC(BlockCounter)   ...         %
        Ry(BlockCounter)-RyC(BlockCounter)],'k');         %  C(subj)
    end                                                   %
  end                                                     % END while 1
else
  Rx=D(:,1);Ry=D(:,2);
end


%% ___ REGRESSION : ___
fprintf('\nRegression'); pause(.01)                       %

% initial guess
f=expDecay(p0,Rx);                                        % initial Eval of a function curve
bestNorm=norm(Ry-f); BestP=p0;                            % initial best conditions
if plotOrNot                                              % plot initial guess
  h_sln=plot(Rx,f,'k','linewidth',2);      hold on;       % plot curve fit
  h_try=plot(Rx,f,'b--','linewidth',1);   hold on;        % plot curve fit
  drawnow; pause(.3);                                     % make sure things are refreshed
  hold on;                                                % 
end

% optimization loop w/ repeated perturbations of int. cond.
% this uses a simulated annealing cooling schtick
p=p0; 
for i=1:50
  fprintf('.'); pause(.001)                               % '.' as progress mark
  p_pert=p+(1/i)*rand(1,3)*20-(1/i)*rand(1,3)*20;         % new guess depends on cooling
  f=expDecay(p_pert,Rx);                                  % Eval of a function curve

  if plotOrNot                                            % plot initial guess
    set(h_try,'ydata',f);                                 % plot new guess
    drawnow; pause(.003);                                 % refreshed
  end
    p=lsqcurvefit('expDecay',p_pert,Rx,Ry);               % OPTIMIZATION HERE     <==============

  f=expDecay(p,Rx);                                       % Eval of a function curve
  SSS=norm(Ry-f);
  if SSS<bestNorm
    fprintf('v');                                         % display 'v' as progress mark
    bestNorm=SSS; BestP=p;
    
    if plotOrNot                                          % plot initial guess
      set(h_sln,'ydata',f);                               % plot new sln
      drawnow; pause(.01);                                % make sure things are refreshed
    end
  else
    p=BestP;                                              % go back to the best if the solution did not imporve
  end
end

p=BestP;                                                  %
fprintf('Done.'); pause(.01)                              %

% final evaluation
f=expDecay(BestP,Rx);                                     % Eval curve fit based regression sln

% finlize plot
if plotOrNot                                              % plot initial guess
  set(h_sln,'ydata',f);                                   % plot new sln
  set(h_try,'ydata',[]);                                  % erase the most recent attempt
end




fprintf('\n\n\n~ END %s ~ \n',progName);                           % message

return



