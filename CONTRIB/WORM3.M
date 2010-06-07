function [XX,YY,ZZ]=worm3(xc,yc,zc,r,ntet)
%function [X,Y,Z]=worm3(Xc,Yc,Zc,R,N)
%
%         --- Plot a 3D curved cylinder (a worm) ---
%  along the  curve [Xc Yc Zc] with transversal radius R.
%  The curve must have at least 2 points, if it is closed 
%                 then periodicity is taken into account.
%  R can be a scalar or a vector 
%         (same size of Xc, or only first value is used).
%  N is the resolution, number of  points to draw circles 
%                                           [default 12].
%
%  Then SURF(X,Y,Z) plots the cylinder;
%  with no output argument the cylinder is drawn directly.

%preparation
if nargin<4, disp(' Worm3 error: not enough input arguments'); return, end
if nargin<5, ntet=12; end
if ntet<2, disp(' Worm3 error: N must be larger than 1'), return, end
n=length(xc);
if length(yc)~=n | length(zc)~=n,
  disp(' Worm3 error: mismatched lengths of curve coordinates')
  return
end
radius=r; if length(r)<n, radius=r(1)*ones(size(xc));end
X=zeros(n,ntet+1);Y=X;Z=X;
tet=(0:2*pi/ntet:2*pi)';ct=cos(tet);st=sin(tet);
%build n-1 circles normal to each segment
for i=1:(n-1),
  v=[xc(i+1)-xc(i),yc(i+1)-yc(i),zc(i+1)-zc(i)];
  V=norm(v);
  salpha=v(3)/V;calpha=sqrt(v(1)*v(1)+v(2)*v(2))/V;
  sbeta=0;cbeta=1;
  if calpha~=0,sbeta=v(2)/V/calpha;cbeta=v(1)/V/calpha;end
  x=+ct*salpha*cbeta+st*sbeta;
  y=+ct*salpha*sbeta-st*cbeta;
  z=-ct*calpha;
  X(i,:)=x';Y(i,:)=y';Z(i,:)=z';
end
%move and scale circles properly
X(n,:)=X(n-1,:)*radius(n)+xc(n);
Y(n,:)=Y(n-1,:)*radius(n)+yc(n);
Z(n,:)=Z(n-1,:)*radius(n)+zc(n);
X1=X(1,:);Y1=Y(1,:);Z1=Z(1,:);
for i=2:(n-1),
  %rotate to mach with previous
  dx=X1(1)-X(i,:);dy=Y1(1)-Y(i,:);dz=Z1(1)-Z(i,:);
  [a k]=min(dx.*dx+dy.*dy+dz.*dz);kk=[k:ntet 1:k];
  X2=X(i,kk);Y2=Y(i,kk);Z2=Z(i,kk);
  X(i,:)=0.5*(X2+X1)*radius(i)+xc(i);
  Y(i,:)=0.5*(Y2+Y1)*radius(i)+yc(i);
  Z(i,:)=0.5*(Z2+Z1)*radius(i)+zc(i);
  X1=X2;Y1=Y2;Z1=Z2;
end
X(n,:)=X(n,kk);
Y(n,:)=Y(n,kk);
Z(n,:)=Z(n,kk);
X(1,:)=X(1,:)*radius(1)+xc(1);
Y(1,:)=Y(1,:)*radius(1)+yc(1);
Z(1,:)=Z(1,:)*radius(1)+zc(1);
% check for expected periodicity
d=(xc(1)-xc(n))^2+(yc(1)-yc(n))^2+(zc(1)-zc(n))^2;
if d<1e-16,
  X(n,:)=0.5*(X(1,:)+X(n,:));
  Y(n,:)=0.5*(Y(1,:)+Y(n,:));
  Z(n,:)=0.5*(Z(1,:)+Z(n,:));
  X(1,:)=X(n,:);
  Y(1,:)=Y(n,:);
  Z(1,:)=Z(n,:);
end
% draw if requested
if nargout==0,
 if n<3,
  surf(X,Y,Z);
 else, 
   surfl(X,Y,Z); 
%  plot3(X(:,1:2:ntet),Y(:,1:2:ntet),Z(:,1:2:ntet),'w-',X',Y',Z','w-'); 
 end
else
 XX=X;YY=Y;ZZ=Z;
end

