% ************** MATLAB "M" function (jim Patton) *************
% Evaluate a single copycat basis force field model
% SYNTAX:    
% INPUTS:    rho,rhoI,M,L,R,K,B,g,verbose
% OUTPUTS:   Mforce     N by 2 matrix rows=time_steps, cols=joint_torqes
% VERSIONS:  5/13/99    INITIATED by Patton 
%            9/14/99    renamed ccEval from basisModel2
%            9/21/99    renamed ccEval3 
%            9/22/99    renamed ccEval4; detected onset times: "St"
%            10/6/99    added ouputs StI and len
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [Mforce,St,StI,len]=ccEval4(rho,rhoI,CCB,len,g,verbose);

%_________ SETUP ________
fcnName='ccEval4.m';
global DEBUGIT 
%global PSTR CCC                                    % for debugging
if ~exist('verbose'), verbose=1; end                % if not passed
if verbose,fprintf('\n ~ %s ~ \n',fcnName); end     %
%Ntimes=length(rho(:,1));                           % find timesteps
M=CCB.M; L=CCB.L; R=CCB.R; K=CCB.K; B=CCB.B;        % extract arams from struct
X=CCB.X; Y=CCB.Y;                                   % 
% fprintf('\n');L, R, X, Y, fprintf('\n'); 

%___ Inverse kinematics ___
rho(:,1)=rho(:,1)+X;  rho(:,2)=rho(:,2)+Y;          % shoulder repositioning
if length(rho(:,1))<3,                              % if single time step
  [phi,q]=inverse_kinematics2(rho,L);               % do it the slow way
  [phiI,qI]=inverse_kinematics2(rhoI,L);            %
  St=1; StI=1; len=0;
else
  Hz=100;
  
  q=inverse_kinematics3(rho(:,1:2),1,L);            % desired joint (relative) ang 
  if ~isreal(q), 
    fprintf(' q not real!\n'),  
    figure(4); clf; plot(q); title('q'); q 
    disp('  HIT A KEY..'); pause
  end
  
  qI=inverse_kinematics3(rhoI(:,1:2),1,L);          % desired joint (relative) ang 
  if ~isreal(qI), 
    fprintf(' qI not real!\n'),  
    figure(4); clf; plot(qI); title('qI'); qI 
    disp('  HIT A KEY..'); pause
  end 
  
  phiI=inverse_kinematics3(rhoI(:,1:2),0,L);           % desired joint (relative) ang 
  if ~isreal(phiI), 
    fprintf(' phiI not real!\n'), 
    figure(4); clf; plot(phiI); title('phiI'); phiI 
    disp('  HIT A KEY..'); pause
  end
  
  [q(:,3:4),q(:,5:6)]=dbl_diff(q,Hz,0);               % calc higher derivatives 
  [qI(:,3:4),qI(:,5:6)]=dbl_diff(qI,Hz,0);            % calc higher derivatives 
  [phiI(:,3:4),phiI(:,5:6)]=dbl_diff(phiI,Hz,0);      % calc higher derivatives 
  [St,len]=startAndLength(rho(:,3:4),len);            % speed threshold start
  [StI,len]=startAndLength(rhoI(:,3:4),len);
  Z=zeros(len+1,3);
end

%clf;plot(q(St:St+len,1:2),'.');hold;plot(q(:,1:2),'.');

%__ torque traject: tauPass (passive dynamics) __
tauPass=inverse_dynamics2(q(St:St+len,:),Z,M,L,R,g,0); % Calc D: Passive dynamics
tauPass(:,3)=[];                                       % clip off endpoint torque

%__ torque traject: tauCff (control feedforward) __
tauCff=inverse_dynamics2(qI(StI:StI+len,:),Z,M,L,R,g,0);  % Cff: feedforward torqes
tauCff(:,3)=[];                                     % clip off endpoint torque

%__ torque traject: tauCfb (control feedback) __
for i=1:len+1
  tauCfb(i,:)=control2([q(St+i,1:6)             ... % Cfb: feedback PD control 
                        phiI(StI+i,1:4)         ... %  referenced to intended.
                        K(1,1)                  ... %  stiffness matrix vectorized
                        K(1,2)                  ... %
                        K(2,1)                  ... %
                        K(2,2)                  ... %
                        B(1,1)                  ... %  damping matrix vectorized
                        B(1,2)                  ... %
                        B(2,1)                  ... %
                        B(2,2)]);                   % 
end

%__ torque traject: resultant model (D-C) __
Mtau=(tauPass-tauCff-tauCfb);                          % evaluate model result: D-C

%__ convert to force __
for i=1:len+1
  J=jacobian([q(i,1);                           ... % find jacobian
      q(i,2)-q(i,1)],L);                            %
  Mforce(i,:)=(inv(J')*Mtau(i,:)')';                % use it to convert to force
end

drawnow;
if verbose,fprintf(' ~ END %s ~ \n',fcnName); end   %
return

%clf
%subplot(3,2,1); plot(tauPass,'.'); title('D'); hold on
%subplot(3,2,3); plot(tauCff,'.'); title('Cff'); hold on
%subplot(3,2,5); plot(tauCfb,'.'); title('Cfb'); hold on

%subplot(3,2,2); plot(q(:,1:2),'.'); title('q pos'); hold on
%subplot(3,2,4); plot(q(:,3:4),'.'); title('q vel'); hold on
%subplot(3,2,6); plot(q(:,5:6),'.'); title('q acc'); hold on

