figure(2); clf; figure(1); clf; drawnow;   N=200; z=rand(N)*10; p=ceil(rand(N,2)*N); for i=1:N; z(p(i,1),p(i,2))=rand(1,1)*5000; end; mesh(z); drawnow;  zs=zeros(N-2*W); W=N/20; for i=W+1:N-W; i;,  for j=W+1:N-W; j;, zs(i-W,j-W)=mean(mean(z(i-W:i+W,j-W:j+W))); end; end; figure(2); h=mesh(zs); axis equal
cockpit(zs)