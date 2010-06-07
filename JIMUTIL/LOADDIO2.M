% ***************** MATLAB "M" function  (jim Patton) ****************
% The following reads a DIO file & returns it as a matrix x
%
% INPUTS : 		name		(input magnitude time series vector)
%			Hz		(frequency of sampling for x, in Hertz)
%			plot_or_not	(text variable, ='y' for plotting)
%			max_freq 	(max frequency to be viewed in the plot)
% OUTPUTS : 		freq		(frequency domain for fft plot)
%			mag 		(corresponding manitudes for fft plot)
% CALLS : 		readdio		()
%			inopen 		()
%
% SYNTAX:		function x=loaddio2(name,trial);
% initiatied 10/18/95 by jim patton from 'load_dio.m'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function x=loaddio2(name,trial);

fprintf('\n~ loaddio2.m M-FUNCION (jim patton) ~');

% __ load the data into 'x' variable & header info into 'header' variable __
[info,Ntrials,freq,time]=inopen(name);			% get info
fprintf('Loading data: %s,  trial %2.0f of %2.0f\n',name, trial, Ntrials);
[x,header]=readdio(info,trial);				% load data into x
fclose(info(1));						% close file

fprintf('~ END loaddio2.m M-FUNCION (jim patton) ~');

