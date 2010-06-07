%************** MATLAB "M" function (jim Patton) *************
% velocity inner product error betweeen 2 traj.
% SYNTAX      [vip,vaf]=velocityInnerProd(a,b,spacing,verbose,plotIt)   
% INPUTS:     a & b     nx5 arrays: [time Xpos Ypos Xvel Yvel]
%             spacing   for resampling in uniform space: amount of 
%                       distance between points.
% CALLS:       
% CALLED BY:	?
% REVISIONS:	12/5/99 (patton) mod. from figural_error.m
%             2-8-2000 (Patton) added "spacing"
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function [vip,vaf]=velocityInnerProd(a,b,spacing,verbose,plotIt)

%____ SETUP ____
progname='velocityInnerProd.m';
if ~exist('verbose'), verbose=0; end
if ~exist('plotIt'),  plotIt=1; end
if verbose,fprintf('\n~ %s ~',progname);end %
if (size(a,2)~=5 | size(b,2)~=5)
  error('Inputs a & b must be nx5: [time xpos ypos]. ')
end
thresh=.08;                                  % velocity above noise
t=1; x=2; y=3; xv=4; yv=5;
deltaT=a(2,1)-a(1,1);
fsz=8;

%____ speed threshold ____
aSpeed=sqrt(a(:,xv).^2+a(:,yv).^2);
bSpeed=sqrt(b(:,xv).^2+b(:,yv).^2);

for i=1:length(a),if aSpeed(i)>thresh,aSt=i;break;end;end
for i=1:length(b),if bSpeed(i)>thresh,bSt=i;break;end;end

for i=length(a):-1:aSt,if aSpeed(i)>thresh,aEnd=i;break;end;end
for i=length(b):-1:bSt,if bSpeed(i)>thresh,bEnd=i;break;end;end

if aEnd-aSt>bEnd-bSt, len=bEnd-bSt+1;
else len=aEnd-aSt+1;
end

%____ trim out traj ____ 
time=(0:len-1)*deltaT; time=time';
A=[time a(aSt:aSt+len-1,2:5)];
B=[time b(bSt:bSt+len-1,2:5)];

%____ uniform ____ 
if spacing, 
  ar=uniformDistance(A,spacing,verbose);  
  Bi=interp1(B(:,1),B,ar(:,1));
  br=[ar(:,1) Bi(:,2:5)]; 
  len=size(ar,1);
else 
  ar=A;  
  br=B;  
end 

%aSt,bSt,aEnd,bEnd,len

%____ plot ____
if plotIt, 
  
  subplot(2,1,1) % X
  plot(a(:,t)-a(aSt,t),a(:,xv),'r'); hold on;
  plot(b(:,t)-b(bSt,t),b(:,xv),'b'); 
  for i=1:len,     
    plot([ar(i,t) br(i,t)],                   ...
         [ar(i,xv) br(i,xv)],'m:');    
  end 
  plot(ar(:,t),ar(:,xv),'ro','markersize',3); 
  plot(br(:,t),br(:,xv),'b^','markersize',3); 
  ylabel('X Velocity (m/s)','fontSize',fsz);  
  set(gca,'fontsize',fsz)
  
  subplot(2,1,2) % Y
  plot(a(:,t)-a(aSt,t),a(:,yv),'r'); hold on;
  plot(b(:,t)-b(bSt,t),b(:,yv),'b'); 
  for i=1:len,    
    plot([ar(i,t) br(i,t)],                   ...
         [ar(i,yv) br(i,yv)],'g:');    
  end 
  plot(ar(:,t),ar(:,yv),'ro','markersize',3); 
  plot(br(:,t),br(:,yv),'b^','markersize',3); 
  ylabel('Velocity (m/s)','fontSize',fsz);  
  xlabel('Time (s)','fontSize',fsz);
  set(gca,'fontsize',fsz)
end  

%___ stack vars ___
Apos=[ar(:,x); ar(:,y)];
Bpos=[br(:,x); br(:,y)];
Avel=[ar(:,xv); ar(:,yv)];
Bvel=[br(:,xv); br(:,yv)];

%____ error measures___ 
vip=dot(Avel,Bvel)/norm(Avel)/norm(Bvel);
corrMat=corrcoef(Apos,Bpos); r=corrMat(1,2); vaf=r*r;

if verbose,fprintf('~ END %s ~',progname);end %
