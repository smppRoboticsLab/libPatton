function filteredx=butterx(x,sfreq,n,cutoff)
% filters x with a nth order lowpass Butterworth filter
%fiteredx=BUTTERX(x,sfreq,n,cutoff)     
%cutoff frequency, cutoff

%[b,a]=butter(n,Wn) nth order lowpass digital Butterworth filter
%cutoff frequency, Wn (must be a number between 0 and 1, where 1
%corresponds to the Nyquist frequency)

%updated 22 February 1993 
			
			Wn=cutoff/(sfreq/2);
			[b,a]=butter(n,Wn);
            filteredx=filtfilt(b,a,x);
