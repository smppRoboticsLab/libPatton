
% ******** MATLAB "M" functionn (jim Patton) **********
% statistics on the values in a 3D array along depth dimension, ignoring NaNs
% example:  trialMEANS=cubeStat(C,'mean')
% similar to:
%   trialMEANS=permute(nanmean(permute(dataCube,[3 1 2])),[2 3 1]);
%~~~~~~~~~~~~~~~~~ Begin: ~~~~~~~~~~~~~~~~~~~~~~

function M=cubeStat(C,cmdstr,P,verbose)

fcnName='cubeStat.m';
if ~exist('verbose'), verbose=1; end                  % if not passed
if verbose, fprintf(' ~ %s ~ ',fcnName); end          %
clear M;

  if ~exist('P'), P=0; end                            % if not given as input 
  if verbose, fprintf(' Calculating %s',cmdstr); end
  [rows,cols,depth]=size(C);
  for i=1:rows
    for j=1:cols
      vect=[];
      for k=1:depth
        if ~isnan(C(i,j,k)), 
          vect=[vect; C(i,j,k)]; 
        end % if ~isnan
      end % k
      if length(vect)<2, 
        %fprintf('\n [%d,%d]: %d values!',i,j,length(vect));
      end
      
      if P, eval(['X=' cmdstr '(vect,P);']);          % if P is given
      else  eval(['X=' cmdstr '(vect);']);
      end
      drawnow; pause(.001);                           % so things update
      
      if isempty(X), X=NaN; end
      M(i,j)=X;
    end % j
  end % i
  
if verbose, fprintf(' ~ END %s ~ ',fcnName); end      %
  
