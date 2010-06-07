% run a set of scripts to update the smpp publications webpage
% ************** MATLAB "M" script  (jim Patton) *************
% this must be run from behind the smpp network, and the user must have
% acess to the smpp webserver sulu:
%  \\165.124.30.8\wwwroot
% SYNTAX:	updateSMPPpub2
% INITIATIED:	11-15-05 by patton 
% ~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

fprintf(' ~ updateSMPPpub2.m (patton) ~ '); 

cd \\165.124.30.8\wwwroot\updatePubs
setpath
updateSmppPubWebpage

fprintf(' ~ END updateSMPPpub2.m (patton) ~ '); 

