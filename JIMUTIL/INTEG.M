function I=integ(fx,x,a,b);
% INTEG	Integrative function.  
%  If f(x) is a vector [fx(1) fx(2) ... fx(n)],
%	then integ(fx,x,a,b) returns a vector which is the integral of f(x)
%	between the limits a and b (indexes)
%	integral of f(x) from f(a) to f(b)
%	If X is a matrix, the integral is calculated for each column

%	A. Russo 23 September 1992
							
%Numerical Methods for Engineers; p.484
		%integrate from a to b
		%fprintf('a %f b %f\n',a,b)
		%sindex=find(x==a);
		%startindex=sindex(length(sindex));
		%fprintf('a %f  ',x(startindex))

		%eindex=find(x==b);
		%endindex=eindex(1);
		%fprintf('b %f\n',x(endindex))
		%cfx=fx(startindex:endindex,:);
		cfx=fx(a:b,:);
	
	n=length(cfx);        
	%w=(x(endindex)-x(startindex));
	w=(x(b)-x(a));
	I=w*((cfx(1,:)+2*sum(cfx(2:n-1,:))+cfx(n,:))/(2*n));

%	end function

%	test
%	numerically integrate 
%	f(x)= 0.2 + 25x - 200x^2 + 675x^3 - 900x^4 + 400x^5
%	from a=0 to b=0.8
%	the exact value of the integral can be determined analytically to be 1.64053334
%	f(0)=0.2; f(0.8)=0.232;

%	x=(0:0.0001:0.8);
%	x5c=[x
%	       x
%	       x
%	       x
%	       x];
%	x2=prod(x5c(1:2,:));
%	x3=prod(x5c(1:3,:));
%	x4=prod(x5c(1:4,:));
%	x5=prod(x5c);	
%	fx=0.2 + 25*x - 200*x2+ 675*x3 - 900*x4 + 400*x5;
%	a=0;
%	b=0.8;
%	I=integ(fx,x,a,b);
%	fx=fx';
%	x=x';
%	plot(x,fx); 
%	title(['area is',num2str(I)])
%	disp('exact value:  1.64053334')

	
