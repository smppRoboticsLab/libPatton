%% expRegressionViaLogXform: lssq regression of exponential decay using log
%%%************** MATLAB "M" function  *************
% Regression of an exponential function using a logarithm tranformation
% then find necessary constatns to best-fit the date to function :
%     f(x)=k1+k2*exp(-x/tau)
% 
% EXAMPLE:
%           x=(0:400)'; k1=12, k2=2, tau=60, Nz=2; 
%           y=k2+k1.*exp(-x./tau)+Nz*randn(size(x));  
%           [k1Fit,k2Fit,tauFit]=expRegressionViaLogXform(x,y,[],'plotIt')
%
% SEE ALSO: expRegression, expRegressionViaLogXform
%
% REVISIONS:  3/9/08 (patton) initiated.
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~


function  [k1,k2,tau]=expRegressionViaLogXform(x,y,nFinalPoionts,plotIt)

%% SETUP
len=size(x,1); 
if ~exist('plotIt','var'), plotIt=0; end 
if ~exist('nFinalPoionts','var')||isempty(nFinalPoionts)
  nFinalPoionts=round(len*.1); 
end

%% SHIFT so that it decays to zero at the final average
k2=mean(y(len-nFinalPoionts:len));            % find mean of final poitns
y2=y-k2+.01*k2;                               % shift to a new y for same x

%% FIT
[c]=fit(x,log(y2),'poly1');                   % regression fit
tau=-1/c.p1;                                  % extract tau
k1=exp(c.p2);                                 % extract k1
y3=k2+k1.*exp(-x./tau);                        % calulate a y based on fit

%% PLOT
if plotIt
  clf; 
  subplot(2,1,1)
  plot(x,y,'.',  x,y3,'r'); 
  hold on;
  title ('raw data')

  subplot(2,1,2)
  plot(x,log(y2),'.',  x,(c.p1*x+c.p2),'r');
  title ('Log-transdformed data')
    
  orient tall;
end

return
