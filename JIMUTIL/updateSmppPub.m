% ************** MATLAB "M" script (jim Patton) *************
% Updates the index.htm on  \\Sulu\C\Inetpub\wwwroot\~smpp_pub webpage
% SYNTAX:    updateSmppPub(remote)
% INPUTS:    remote   nonzero for VPN access from outside firewall 
% OUTPUTS:   index.htm file 
% VERSIONS:  6/13/03 added  input arg 'remote'
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~

function updateSmppPub(remote)

% __ SETUP __
fcnName='updateSmppPub.m';
fprintf('\n\n\n~ %s SCRIPT ~\n',fcnName)             % title message
if ~exist('remote'), remote=0; end                   % if not passed

cd \\165.124.30.17\Public\smpp-internal\~smpp_pub
cd

doWebpage(['.htm ';'.html'],[],[],[],0)

cd
fclose all

outFile='\\165.124.30.17\Public\smpp-internal\~jim\pubs.htm';
matchList={'patton'}
IsolateWebPubs(matchList,outFile)

outFile='\\165.124.30.17\Public\smpp-internal\Robotics\pubs\index.htm';
matchList={'mussa-ivaldi'; 'patton'}
IsolateWebPubs(matchList,outFile)

return