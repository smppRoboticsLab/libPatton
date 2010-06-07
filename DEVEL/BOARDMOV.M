% ************** MATLAB "M" function  (jim Patton) *************
% analyze the COP data for the pilot.
%  SYNTAX:	DATA=boardmov(ID,Nblocks,Ntrials)
%  INPUTS:	ID  		rootfilename (subject ID)
%		Nblocks 	number of blocks
%		Ntrials 	number of trials per block
%  OUTPUTS:	plot		trial vs time vs vert position
%  CALLS:	lrn_wing.m 
%  NOTES: 	if subject is JG: 
%  INITIATIED:	6/9/97	jim patton 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function fignum=boardmov(ID,Nblocks,Ntrials)
fprintf(' ~ boardmov.m for %s ~ ',ID); pause(.05);		% display info

% _____SETUP & GET INFO_____
global DEBUGIT;						%

% _____ PLOT _____
clg; 
for B=1:Nblocks, 
  [H,D]=dio2mat([ID num2str(B) '.e99']); 
  time=0:H(9,1)/1000:3.99; 
  colones=ones(length(time),1);
  for T=1:Ntrials, 
    col=(T-1)*42+35;
    plot3(T*colones+(B-1)*15,  time,  D(:,col));
    hold on;
    %plot(time,D(:,col), time,D(:,col+3));
    fprintf('\nblock %d trial %d   pause.. ', B,T);% pause; 
  end; 
end; 
xlabel('trial'); ylabel('time'); zlabel('vert position');

fignum=gcf;

