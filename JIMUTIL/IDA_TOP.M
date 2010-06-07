% ************** MATLAB "M" function (jim Patton) *************
% The following performs inverse dynamic analysis on a multilink system.  
% It uses the  "top down approach."  See /jim/lee/inv_dyn for bottom 
% up hybrid approach with force plate info.
% SYNTAX:  [COP,GRF,Fx,Fy,T]=ida_top(posvelacc,Fp,m,I,L,R,g,a,b,lf);
% INPUTS:  posvelacc  postions in columns, then velocities, then 
%                     accelerations.  Defined as positive counter 
%                     clockwise from horizontal to the right(matr)
%          Fp         pullforce vector of time record (vect)
%          THE FOLLOWING ARE ORDERED BOTTOM SEGMENT FIRST:
%          m          segment masses (bottom segment first)  (vect)
%          I          segment Inertias (vect)
%          L          segment lengths (interjoint)(vect)
%          R          distal joint to segment CM (vect)
%          g          accel due to gravity down 
%          a          horizontal ankle-to-heel (scalar)
%          b          vertical floor-to-ankle (scalar)
%          lf         foot length (scalar)
% OUTPUTS: COP        AP center of pressure measured from toe (vect)
%          GRF    ground reaction forces (rows=time; columns=Fx&Fy)
%          Fx    x force at joints (rows=time; columns=joint#)
%          Fy     y force at joints (rows=time; columns=joint#)
%          T    TORQUE at joints (rows=time; columns=joint#)
% CALLS:  
% VERSIONS:   10/2/96   INITIATED Patton from inv_dyn4.m -IDA proj&Hsin-I
%             12/11/96  Moved to matlab/devel directory; named ida_top.m
%             6/23-4/97 Patton. new comments; moved to 
%                       D:\Programs\mfiles\JIMUTIL\IDA_TOP.M 
%             1/25/99   Changed comments and tabs.
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function [COP,GRF,Fx,Fy,T]=ida_top(posvelacc,Fp,m,I,L,R,g,a,b,lf);

%______________ SETUP ______________
global DEBUGIT
if DEBUGIT, 
  fprintf('~ ida_top.m M function  ~');
  fprintf('\nm,I,L,R ='); 
  fprintf(' %f ',[m,I,L,R]); 
  fprintf('\ng,a,b,lf ='); 
  fprintf(' %f ',[g,a,b,lf]); 
  fprintf('  Calculating.. \n '); 
end
len=length(posvelacc(:,1));                          % number of time steps
num_seg=length(posvelacc(1,:))/3;                    % number of segs in anal
Fx(:,num_seg+1)=Fp;                                  % top (endpt if applicable) 
Fy(:,num_seg+1)= zeros(len,1);                       % top (endpt) force is zero
T(:,num_seg+1)= zeros(len,1);                        % top (endpt) force is zero
phi  = posvelacc(:,1:num_seg);                       %
Dphi = posvelacc(:,num_seg+1:num_seg*2);             %
DDphi = posvelacc(:,num_seg*2+1:num_seg*3);          %
if ~exist('g'),                                      %
  exit(' "g" not defined! Quitting. ');              %
end                                                  %

%______________IDA:______________
% joint kinetics from motion (this is set 
% up to be general for multilink chain
% of num_seg segments, where each link 
% is connected to the previous one.) 
if DEBUGIT, fprintf(' (i=)..'); end                  % message
for i = num_seg:-1:1,                                % each segment 
  if DEBUGIT, fprintf(' %d ',i); end                 % message

  %___SUM 1ST & LAST TERMS OF FORCE EQNS___
  Fx(:,i)=Fx(:,i+1)                                  %
         -m(i)*R(i).*( DDphi(:,i).*sin(phi(:,i)) ... %
         +Dphi(:,i).^2.*cos(phi(:,i)) );             %
  Fy(:,i)=Fy(:,i+1)                                  %
         +m(i)*R(i).*(DDphi(:,i).*cos(phi(:,i))  ... %
         -Dphi(:,i).^2.*sin(phi(:,i)) ) + m(i)*g;    %

  %__ SUM MIDDLE TERMS 'CEPT SEG 1___
  if i> 1,
    for j=1:i-1
      Fx(:,i)=Fx(:,i) 
             -m(i)*L(j).*(DDphi(:,j).*sin(phi(:,j)) ...
             +Dphi(:,j).^2.*cos(phi(:,j))  );
      Fy(:,i)=Fy(:,i) 
             +m(i)*L(j).*(DDphi(:,j).*cos(phi(:,j)) ...
             -Dphi(:,j).^2.*sin(phi(:,j))  );
    end %for j
  end %if

  %_______TORQUE:______
  T(:,i)= R(i)      .*( -Fx(:,i).*sin(phi(:,i))     ...
                       + Fy(:,i).*cos(phi(:,i))  )  ...
        +(L(i)-R(i)).*( -Fx(:,i+1).*sin(phi(:,i))   ...
                       + Fy(:,i+1).*cos(phi(:,i)) ) ...
        +T(:,i+1) + I(i).*DDphi(:,i);

end  % for i   

%_______ GROUND REACTIONS:_______
COP= lf - a - ( b.*Fx(:,1)-T(:,1) ) ./ Fy(:,1);
GRF= [Fx(:,1) Fy(:,1)];

if DEBUGIT, fprintf('~ END ida_top ~'); end

