%%% expRegression: Nonlinear Regression of an exponential function 
%************** MATLAB "M" function (PATTON)  *************
% Nonlinear Regression of an exponential function using a combination of
% Nonlinear optimization techniques and simulated annealing. This assures a
% robust and nearly-global fit to what is typically noisy and hence
% dificult data. This method is time consuming. 
% expRegression finds the necessary p's to best-fit the function:    
%   f(x)=p1+p2*exp(-x/p3)
%
% SEE ALSO:   expRegressionViaLogXform
%
% REVISIONS:  7/24/3 (patton) from code from the field design study.
%~~~~~~~~~~~~~~~~~~~~~ Begin: ~~~~~~~~~~~~~~~~~~~~~~~

function [p,cost]=expRegression(p0,x,y)

    fprintf('=========Optimizing..'); 
    pause(.01)                                      % 
    p=lsqcurvefit('stepTypeCurve3',p0,x,y);         % INITIAL OPTIMIZATION
    f=stepTypeCurve3(p,x);                          % Eval 
    cost=sum((y-f).^2);                             %
    bestP=p; bestCost=cost;                         % init as best
    options=optimset('TolFun',1e-13);
    
    q=1:1:100;                                      % setup parameter
    TempSchedule=stepTypeCurve3([0 100 15],q);      % for simulated anneal.
    %plot(q,TempSchedule,'.')
    
    for T=TempSchedule                              % simmulated annealing temperature
      fprintf('\n__New step__\n'); pause(.01) 
      p0New=p+T*rand(size(p));                      % simmulated annealing perturbation
      p=lsqcurvefit('stepTypeCurve3',       ...     % OPTIMIZATON
        p0New,x,y,[],[],options);                   % ...
      f=stepTypeCurve3(p,x);                        % Eval based on solved params
      cost=sum((y-f).^2);                           % cost evaluation
      if cost<bestCost,                             % Choose if improved
         bestP=p; bestCost=cost;                    % new init guess as best
      end
    end
    p=bestP; cost=bestCost;                         % take the best
    fprintf('======= done Optimizing..');           % 
    pause(.01)                                      % 

return

function y=stepTypeCurve3(x,p)
  y=p(1)+p(2)*exp(-x/p(3));
return
