%%% expRegression: Nonlinear Regression of an exponential function 
%************** MATLAB "M" function (PATTON)  *************
% Nonlinear Regression of an exponential function using a combination of
% Nonlinear optimization techniques and simulated annealing. This assures a
% robust and nearly-global fit to what is typically noisy and hence
% dificult data. This method is iterative and therefore time consuming. 
% expRegression finds the necessary p's to best-fit the function:    
%   y=p1+p2*exp(-x/p3)
% SYNTAX:     [p,cost,fcnExp]=expRegression(p0,x,y,plotIt)
% INPUTS:     p0      intial guess of p=[p1, p2, p3]
%             x       x axis data to be fit (in a column vector)
%             y       y axis data to be fit (in a column vector)
%             plotIt  (optional) nonzero for a a plot (no plot if not given)
% OUTPUTS:    p       best-fit p=[p1, p2, p3], for y=p1+p2*exp(-x/p3)
%             cost    sum of squares of error (residual)
%             fcnExp  matab string that can be used:  eval(fcnExp) 
% EXAMPLE:
%     x=(0:80)'; k1=30, k2=80, tau=20, Nz=25;
%     yIdeal=expDecay([k1,k2,tau],x);   % create ideal decaying exponential
%     y=yIdeal+Nz*randn(size(x));       % corrupt with noise
%     clf; subplot(2,1,1); plot(x,yIdeal,'linewidth',3); hold on; 
%     p=expRegression([1,1,1],x,y,'plotIt'); % find best fit
%
% SEE ALSO:   expRegressionViaLogXform, expDecay
%
% REVISIONS:  7/24/3 (patton) from code from the field design study.
%~~~~~~~~~~~~~~~~~~~~~ Begin: ~~~~~~~~~~~~~~~~~~~~~~~

function [p,cost,fcnExp]=expRegression(p0,x,y,plotIt)

%% SETUP
if ~exist('plotIt','var'), plotIt=0; end 
L=size(y,1);
q=1:5:100;                                      % setup parameter
yRange=max(y)-min(y);                           % range spanned by y values
TempSchedule=expDecay([0 5*yRange 15],q);       % for simulated anneal.
step=0;                                         % counter
if isempty(p0), p0=[y(L), y(1)-y(L), L]; end    % init.guess ifNot provided

%% INITIAL OPTIMIZATION
fprintf('=========Optimizing..');               % 
pause(.01)                                      % pause
p=lsqcurvefit('expDecay',p0,x,y);               % INITIAL OPTIMIZATION
f=expDecay(p,x);                                % Eval
cost=sum((y-f).^2);                             % evaluate the cost
bestP=p; bestCost=cost;                         % init as best
options=optimset('TolFun',1e-13);               % setup 
lastBestf=0.*x;
fcnExp=['f=' num2str(bestP(1)) '+'        ...   % text string showing sln
        num2str(bestP(2)) '*exp(-x/'      ...   % ...
        num2str(bestP(3)) ')'];                 % ...


%% PLOT INITIAL
if plotIt, 
  %clf; 
  subplot(2,1,1); 
  plot(x,y,'.'); hold on;                       % raw data
  plot(x,expDecay(p,x),'r');                    % 1st solution                    
  plot(x,expDecay(p0,x),'r:');                  % init guess
  subplot(2,1,2)                                % fig 4 sim anneal schedule
  plot(q,TempSchedule,'.')                      % plot schedule
  title ('Annealing Schedule');                 %
  xlabel('Optimization step'); ylabel('temp');  % 
  pause(.01);                                   %
  subplot(2,1,1); 
end

%% SIMULATED ANNEALING LOOP
for T=TempSchedule                              % loop: annealing temp
  step=step+1;
  fprintf('__Step%d(temp=%f)...',step,T); 
  pause(.01)
  p0New=p+T*rand(size(p));                      % simmulated annealing perturbation
  p=lsqcurvefit('expDecay',           ...       % OPTIMIZATON
    p0New,x,y,[],[],options);                   % ...
  f=expDecay(p,x);                              % Eval based on solved params
  cost=sum((y-f).^2);                           % cost evaluation 
  if cost<bestCost,                             % Choose if improved
    bestP=p; bestCost=cost;                     % new init guess as best
    fcnExp=['f=' num2str(bestP(1)) '+'    ...   % text string showing sln
            num2str(bestP(2)) '*exp(-x/'  ...   % ... 
             num2str(bestP(3)) ')'];            % ...
    if plotIt,                                  % plot update
      plot(x,lastBestf,'color',[.5 .5 .5]);     % grey out last
      plot(x,f,'r');                            % add new
      title(fcnExp);
      drawnow; pause(.01);
    end                                         %
    lastBestf=f;
  end
end

%% FINAL STUFF
p=bestP; cost=bestCost;  f=expDecay(p,x);       % take the best
fprintf('\n======= Optimizing Complete.\n');    %
pause(.01)
if plotIt, plot(x,f,'r','linewidth',3); end     % show in bold

return

