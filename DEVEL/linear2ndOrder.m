clf
snr=.2;

[y,t]=step(tf(1,[2 1 4])); 
SIGMA=std(y);
NOISE=snr*SIGMA*diag(rand(length(y)));
y=y+NOISE; 
subplot(2,1,1)
spectrum(NOISE);


subplot(2,1,2)
plot(t,y,'.'); 
xlabel('sec')
Hz=1/(t(2)-t(1));
[yDot,y2Dot]=dbl_diff(y,Hz);

A=[y2Dot yDot y];
b=ones(length(y),1);
[d,r,norm_ssq]=linear_least_squares(A,b);
%d=nnls(A,b);

[y1,t1]=step(tf(1,[d(1) d(2) d(3)])); 
hold on
plot(t1,y1,'r'); 