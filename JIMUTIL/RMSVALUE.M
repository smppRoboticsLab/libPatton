function R=rmsval(x)
% RMSVAL	root mean square value for vectors or matrices
%	for vectors, RMS(X) is the rms of the elements of x
%	For matrices, RMS(X) is a row vector containing the
%	rms value of each column

%updated 14 February 1993,  Aileen M. Russo

%Muscles Alive, p.97
%RMS=sqrt(1/N * (m(t)*m(t)))

R=sqrt(mean(x.^2));
