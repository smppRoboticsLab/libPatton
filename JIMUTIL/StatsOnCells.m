% StatsOnCells  - do simple statistics on all the elements of a cell array
% ***************** MATLAB M function ***************
% SYNTAX:     
% INPUTS:     D
% OUTPUTS:    
% REVISIONS:  Initiated by Patton 3/25/05 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [Dmean,Dconf95,Dstdev]=StatsOnCells(D);

[Drows,Dcols]=size(D);                                              % get dimensions

for I=1:Drows;   % For each row
  for J=1:Dcols;     % For each col 
    Dmean{I,J}=mean(D{I,J});
    Dstd{I,J}=std(D{I,J});
    Dconf95{I,J}=confidence(D{I,J},0.95);
  end % END for I
end % END for J

return

