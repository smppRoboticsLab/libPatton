%************** MATLAB "M" function (jim Patton) *************
% RMS error betweeen 2 position traj.
% SYNTAX      [vip,vaf]=velocityInnerProd(a,b,spacing,verbose,plotIt)   
% INPUTS:     a & b     nx5 arrays: [time Xpos Ypos Xvel Yvel]
%             spacing   for resampling in uniform space: amount of 
%                       distance between points. 
% REVISIONS:	2-13-2000 (patton) INTIATED from velocityInnerProduct
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function [Erms,vip,vaf]=rmsError(a,b,spacing,verbose,plotIt)

%____ SETUP ____
progname='velocityInnerProd.m';
if ~exist('verbose'), verbose=0; end
if ~exist('plotIt'),  plotIt=1; end
if verbose,fprintf('\n~ %s ~',progname);end %
if (size(a,2)~=5 | size(b,2)~=5)
  error('Inputs a & b must be nx5: [time xpos ypos]. ')
end
thresh=.09;                                  % velocity above noise
t=1; x=2; y=3; xv=4; yv=5;
deltaT=a(2,1)-a(1,1);
fsz=8;
aSt=1;
bSt=1;

%____ speed threshold ____
aSpeed=sqrt(a(:,xv).^2+a(:,yv).^2); %max(aSpeed)
bSpeed=sqrt(b(:,xv).^2+b(:,yv).^2); %max(bSpeed)

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
  plot(a(:,t)-a(aSt,t),a(:,x),'r'); hold on;
  plot(b(:,t)-b(bSt,t),b(:,x),'b'); hold on;
  for i=1:len,    
    plot([ar(i,t) br(i,t)],       ...
         [ar(i,x) br(i,x)],'m:');    
  end 
  plot(ar(:,t),ar(:,x),'ro','markersize',3);
  plot(br(:,t),br(:,x),'b^','markersize',3); 
  ylabel('X Position (m)','fontSize',fsz);  
  set(gca,'fontsize',fsz)
  
  subplot(2,1,2) % Y
  plot(a(:,t)-a(aSt,t),a(:,y),'r'); hold on;
  plot(b(:,t)-b(bSt,t),b(:,y),'b'); hold on;
  for i=1:len,    
    plot([ar(i,t) br(i,t)],       ...
         [ar(i,y) br(i,y)],'g:');    
  end 
  plot(ar(:,t),ar(:,y),'ro','markersize',3); 
  plot(br(:,t),br(:,y),'b^','markersize',3); 
  ylabel('Y Position (m)','fontSize',fsz);  
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
Erms=norm(Apos-Bpos)/length(Apos);

if verbose,fprintf('~ END %s ~',progname);end %
