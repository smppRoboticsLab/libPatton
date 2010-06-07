%______*** MATLAB "M" function (jim Patton) ***_______
% kinetic energy based on kinematics for planar link-segment chain.
% this is a utility for checking the validity of a model
% SYNTAX:    
% INPUTS :     q        matrix of ang postions, cols=segments, rows=time steps
%              qD       matrix of ang velocities, cols=segments, rows=time steps 
%                       For 2-link example:
%                       q(:,1) = q1
%                       q(:,2) = q2
%                       qD(:,1) = q1_dot
%                       qD(:,2) = q2_dot
%
%                                               o         
%                                                \                   
%                                                M(2)    q(2)
%                                                  \ 
%                                                   o ` ` ` ` `     
%                                                  /                
%                                                M(1)  q(1)
%                                                /
%                                             __o___` ` ` ` ` `     
%                                             \\\\\\\               
%
% OUTPUTS:      T       kinetic energy
%               rho     CM locationns, where 
%                         row = intants in time
%                         columns = x or y
%                         depth = segment
%               rhoD    CM velocity, where 
%                         row = intants in time
%                         columns = x or y
%                         depth = segment
% CALLS :    
% CALLED BY: 
% VERSIONS:     3/2/99  INITIATED (Patton).
%~~~~~~~~~~~~~~~~~~~~~~~~~~~ BEGIN: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [T,rho,rhoD]=kinetic_energy(q,qD);
fprintf(' ~ kinetic_energy.m  ~  Calculating...');

%_______________ SETUP ______________
global M L R       % where:
% M      =row=seg#; col1=mass col2=polar inertia@segCM (matrix)
% L      =segment length (interjoint)
% R      =distal joint to segment CM
x=1;
y=2;
Nseg=length(q(1,:));                                % number of segs in anal
Nsamples=length(q(:,1));                            % number of samples

rho=zeros(Nsamples,2,Nseg);                         % initialize, where 
rhoD=zeros(Nsamples,2,Nseg);                        %   rows = time_samples, 
                                                    %   columns = x (1) and y (2),
                                                    %   depth = segments  
%___ determine cartesian kinematics ___
rho(:,x,1)=R(1).*cos(q(:,1));                       % segment 1 CM positions
rho(:,y,1)=R(1).*sin(q(:,1));                       % 
rhoD(:,x,1)=-R(1).*(qD(:,1).*sin(q(:,1)));           % segment 1 CM velocities
rhoD(:,y,1)= R(1).*(qD(:,1).*cos(q(:,1)));           % 
for seg=2:Nseg,                                     % loop for all other segs 
  rho(:,:,seg)=zeros(Nsamples,2);                   % initialize with zeros
  rhoD(:,:,seg)=zeros(Nsamples,2);                  % initialize with zeros
  for s=1:seg-1,                                    % loop for connecting segs
    rho(:,x,seg)=rho(:,x,seg)+L(s)*cos(q(:,s));     % cartesian endpoint pos
    rho(:,y,seg)=rho(:,y,seg)+L(s)*sin(q(:,s));     % cartesian endpoint pos
    rhoD(:,x,seg)=rhoD(:,x,seg)-                ... % cartesian enpoint velocity
                  L(s)*qD(:,s).*sin(q(:,s));        %
    rhoD(:,y,seg)=rhoD(:,y,seg)+                ... % cartesian enpoint velocity
                  L(s)*qD(:,s).*cos(q(:,s));        % 
    %disp('inner loop')  
  end % end for s
  rho(:,x,seg)=rho(:,x,seg)+R(seg)*cos(q(:,seg));   % cartesian endpoint pos 
  rho(:,y,seg)=rho(:,y,seg)+R(seg)*sin(q(:,seg));   % 
  rhoD(:,x,seg)=rhoD(:,x,seg)-                 ...  % cartesian enpoint velocity
                R(seg)*qD(:,seg).*sin(q(:,seg));    % 
  rhoD(:,y,seg)=rhoD(:,y,seg)+                 ...  % 
                R(seg)*qD(:,seg).*cos(q(:,seg));    % 
  %disp('outer loop');
end % for seg

%___ kinetic energy ___
v_squared=rhoD.^2;                                  % square velocities
T=zeros(Nsamples,Nseg);                             % initialize kinetic energy
for seg=1:Nseg,                                     % loop for all other segs 
  sq_speed(:,seg)=sum(v_squared(:,:,seg)')';        % sum squared x&y @ea time
  T(:,seg) = T(:,seg)                           ... % sum on translational and 
            + 0.5.*M(seg,1).*sq_speed(:,seg)    ... %  rotational kinetic energy
            + 0.5.*M(seg,2).*qD(:,seg).^2;          %      
end % for seg

fprintf(' ~ END kinetic_energy.m  ~   ');
return


