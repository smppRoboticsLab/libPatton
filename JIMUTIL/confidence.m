%************** MATLAB "M" function  *************
% returns width of wings for a confidence interval for column(s) of data
% SYNTAX:       c=confidence(X,interval),     % where:
%               X          vector of values 
%               interval   confidence expressed as fraction. (for 95%, enter .95) 
% EXAMPLE: 
%       X=randn(12,1); wing=confidence(X,.95); 
%       clf; plot(X); hold on;  
%       plot([2 2],[mean(X)+wing mean(X)-wing],'r', 'linewidth',4); 
%       plot(2,mean(X),'ro');
% REVISIONS:    2/18/2000  (patton) INITIATED
%               5/31/2000  fixed
%               9/10/00    verbose added as input
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~

function width=confidence(X,interval,verbose)

% ____ SETUP ____
prog_name='confidence.m';                   % name of this program
if ~exist('verbose'), verbose=0; end                  % if not passed
if verbose, 
  fprintf('\n~ %s ~ ', prog_name); 
end
if interval>.999999|interval<.00000001,
  error('interval must be between 0 and 1')
end
[rows,cols]=size(X);                        % dimensions
if rows==1, X=X'; end                       % traanspose if row vect
[N,cols]=size(X);                           % dimensions

% ____ CALC ____
N=size(X,1);                                % # samples
r=1-((1-interval)/2);                       % adjust for the tails of distrib.
tinvValue=tinv(r,N);                        % inverse t statistic
stdX=std(X);                                % standard deviation
width=tinvValue.*(stdX)./sqrt(N);           % calculate confidence wing

return