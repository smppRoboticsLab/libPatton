% ************** MATLAB "M" function (jim Patton) *************
% shape a radial function to make desired after-effects
% SYNTAX:    
% INPUTS:    
% OUTPUTS:   
% VERSIONS: 11/11/99 INITATED from rcFIT5
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

%__ SETUP __
if verbose, fprintf(' ~ shape_field.m ~ \n'); end       %
A=[]; b=[]; 
cutoff=10;                                            % cutoff freq for filtering
miu=5;                                                %
kappa=[15 0; 0 15];                                   %
beta=[2.5 0; 0 2.5];                                  %
forceNoise=.05,   posNoise=.0005,

%__ load previous trial __ 
filename=['FD-' num2str(trial-1) '.dat'];
if verbose, fprintf('\nLoad "%s" ',filename); end
%[rho,force,Hz]=loadRobotData(filename,cutoff);        % load & transform to subj c.s.
[rho,force,Hz]=loadRobotData(filename,cutoff,     ... % load & transform to subj c.s.
  verbose,plotit,forceNoise,posNoise);                % 
speed=sqrt(rho(:,3).^2+rho(:,4).^2);
for St=4:length(rho(:,1))                             % Loop for each rho time sample
  if speed(St)>speedThresh,break; end;                % find where mvmt begins
end
if St+frames>length(rho(:,1))-2,                      % if amount to eval exceeds length
  frames=length(rho(:,1))-St-2;                       % reduce len (# frames to eval)
end
kinErr=rhoD(St_D:St_D+frames,2:7)                 ... %
      -rho(St:St+frames,:);                           %
overallErr(trial)=abs(sum(sum(kinErr.^2)));
figure(3),
plot(trial,overallErr(trial),'.'); hold on
title('Composite Error vs. Trial'); xlabel('trial#');
dErr=diff(overallErr);
if verbose,
  fprintf('\noverallErr=%f',overallErr(trial));
  if trial>1,fprintf(', dErr=%f',dErr(trial-1));end
end  % display

%__ alter perturbing force: ("b" vector) __
F=force(St:St+frames,:);                              % 
deltaF=miu*(kinErr(:,1:2)*kappa+kinErr(:,3:4)*beta);  % alter force to new desired force
F=F+deltaF;
stackedF=[F(:,x); F(:,y)];                            % stack x&y on topa ea other
b=[b; stackedF];                                      % trials on top of ea other
figure(2);clf;
legend(plot([F deltaF]),'Fx','Fy','dFx','dFy')

%__ evaluate RC model BASES ("A" MATRIX) __
if verbose,fprintf('\nEvlauating RC basis#: ');end    %
for i=1:length(RCB)                                   % LOOP FOR EACH rcBASIS
  if verbose,fprintf('%d ',i); end                    %
  Frc=rcEval3(rhoD(:,2:7),RCB(i),0);                  % rc force evaluations 
  stackedFrc(:,i)=[Frc(St_D:St_D+frames,x);         ... % stack x&y on topa ea other
                   Frc(St_D:St_D+frames,y)];            %
end                                                   % END for i
A=[A; stackedFrc];                                    % trials on top of ea other

%_________ LEAST SQUARES SOLUTION ________
if verbose,   
  fprintf('\nLeast square (A<%d,%d>, b<%d,%d>)'   ... %
    ,size(A),size(b));%
end   
alpha=A'*A; beta=A'*b;                                % construct alpha and beta
%fprintf('QR decomposition'); rc=alpha\beta;          
%fprintf('NonNegative LS sln:'); rc=nnls(alpha,beta); % find nonnegative linear sln
fprintf('(pseudoinverse)..'); rc=pinv(alpha)*beta;    
if verbose,  fprintf('Done.'); end

%_______ plot ______
if plotit, 
  LW=3;
  clf;
  time=(0:length(rho(:,1))-1)/Hz; time=time';
  
  sumFrc=0*rhoI(:,1:2);                               % init
  for i=1:length(RCB)                                 % LOOP FOR EACH rcBASIS
    Frc=rcEval3(rhoD(:,2:7),RCB(i),0);                       % rc force evaluations 
    subplot(3,1,1), 
    plot(time,rc(i).*Frc(:,x),'b:'); hold on
    subplot(3,1,2), 
    plot(time,rc(i).*Frc(:,y),'b:'); hold on
    sumFrc=sumFrc+rc(i).*Frc;
  end                                                 % END for i
  
  subplot(3,1,1), 
  plot(time,sumFrc(:,x),'b:','linewidth',LW);
  title('X forces (N)'); 

  subplot(3,1,2), 
  plot(time,sumFrc(:,y),'b:','linewidth',LW); 
  title('Y forces (N)'); 

  xlabel('seconds')
  
  subplot(3,1,3)
  plot(time,rho(:,3:4)); title('velocities');
  
end % END if plotit

%_________ model fit measures ________
corMTX=corrcoef(A*rc,b);  r=corMTX(1,2);
norm_ssq=sum((A*rc-b).^2)/length(A(:,1));

%_________ DISPLAY RESULTS ________
if verbose, 
  for i=1:length(rc),
    fprintf('\nrc(%d)=%.6f',i,rc(i)); 
  end;
  fprintf('\n rsquared (rc to cc)=%.4f',r^2);  
end       

if verbose, fprintf(' ~ END shape_field.m ~ '); end       %

return
