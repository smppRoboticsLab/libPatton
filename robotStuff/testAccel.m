% function to test the effects of different smoothing and differentiation techniques
function testAccel()

cutoff=0;
[X,F,Hz]=loadRobotData('FD-22.dat',cutoff,0);       % load & transform to subj c.s. 
len=size(X,1);
x=X(:,1:2);
xo=x; 
dt=1/100; 

dx=zeros(len,2,4); ddx=dx;

% === differentiation methods: ===
for i=4:len;                                        % loop for each instant
  
  dx(i,:,1)=(xo(i,:)-xo(i-1,:))./dt;
  dx(i,:,2)=(x(i,:)-x(i-2,:))./(2*dt);
  dx(i,:,3)=(3*x(i,:)-2*x(i-1,:)-x(i-2,:))./dt; 
  dx(i,:,4)=(11*x(i,:)-6*x(i-1,:)-3*x(i-2,:)-2*x(i-3,:))./(6*dt); 

  ddx(i,:,1)=(dx(i,:,1)-dx(i-1,:,1))./dt;
  ddx(i,:,2)=(dx(i,:,2)-dx(i-2,:,2))./(2*dt);
  ddx(i,:,3)=(3*dx(i,:,3)-2*dx(i-1,:,3)-dx(i-2,:,3))./dt;
  ddx(i,:,4)=(11*dx(i,:,3)-6*dx(i-1,:,3)-3*dx(i-2,:,3)-2*dx(i-3,:,3))./(6*dt);
  
end

figure(1); clf 
for i=1:4
  subplot(2,2,i); plot(ddx(:,:,i),'.'); hold on; plot(ddx(:,:,i)); 
end

%disp('  hit a key...'); pause



% init
for j=2:4
  x(:,:,j)=x(:,:,1); 
end
dx=zeros(len,2,4); ddx=dx;


% === Smoothing methods: ===
for i=4:len, x(i,:,4)=(xo(i,:)+xo(i-1,:)+xo(i-2,:)+xo(i-3,:))/4; end % filter
for i=3:len, x(i,:,3)=(xo(i,:)+xo(i-1,:)+xo(i-2,:))/3; end % filter
for i=2:len, x(i,:,2)=(xo(i,:)+xo(i-1,:))/2; end % filter

cutoff=7; order=11; [b,a]=fir1(order,cutoff*2/Hz)
b

% ____ recursive smoothing: ____
if 1
  for i=4:len, x(i,:,4)=(x(i,:,4)+x(i-1,:,4)+x(i-2,:,4)+x(i-3,:,4))/4; end  % smooth
  for i=3:len, x(i,:,3)=(x(i,:,3)+x(i-1,:,3)+x(i-2,:,3))/3; end             % smooth
  for i=2:len, x(i,:,2)=(x(i,:,2)+x(i-1,:,2))/2; end                        % smooth
  for i=length(b):len, 
    x(i,:,1)=0;
    for j=1:length(b)
      x(i,:,1)=x(i,:,1)+b(j)*xo(i-j+1,:);
    end    
  end     % filter
  %for i=3:len, x(i,:,1)=b(1)*xo(i,:)+b(2)*xo(i-1,:)+b(3)*xo(i-2,:); end
end

% ___differentiate these: ___
for i=4:len;                                        % loop for each instant
  for j=1:4,
    dx(i,:,j)=(x(i,:,j)-x(i-2,:,j))./(2*dt);        % 2-point central
    ddx(i,:,j)=(dx(i,:,j)-dx(i-2,:,j))./(2*dt);        % 2-point central
  end

end

figure(2); clf
for i=1:4
  subplot(2,2,i); plot(ddx(:,:,i),'.'); hold on; plot(ddx(:,:,i)); 
end

