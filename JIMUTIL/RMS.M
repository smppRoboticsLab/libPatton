function R=RMS(y,ysim)
%R=RMS(y,ysim) computes RMS:
%sqrt( 1/N * sum (y-ysim)^2) )
%for output y and simulated output ysim

%updated 7 September 1993  A. Russo
			
	M=sum((y-ysim).^2);
	R=sqrt(M/size(y,1));
