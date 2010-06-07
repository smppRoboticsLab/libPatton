% StatsOnCells  - do simple statistics on all the elements of a cell array
% ***************** MATLAB M function ***************
% this process is a bit trick in the general sense and we have to resort to
% an approach that must use the eval() command
% SYNTAX:     [Dmean,Dconf95,Dstdev]=StatsOnCells2(D);
% INPUTS:     D         cell array input
% OUTPUTS:    Dmean     cell array output of mean taken on
%             Dconf95   cell array output 
%             Dstdev    cell array output
% REVISIONS:  Initiated StatsOnCells by Patton 3/25/05 
%             1-1-2006 (Patton) revised by patton to accomodate any size 
%             or shaped cell array (not as easy as it seems). To keep things
%             most general, I changed outputs to cell arrays. 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function [Dmean,Dconf95,Dstdev]=StatsOnCells2(D);

Ddims=size(D);
cmdFors=[]; cmdEnds=[]; cmdIndexes=[];
spacer='     ';

for i=1:length(Ddims)
  cmdFors=[cmdFors 'for i' num2str(i) '=1:Ddims(' num2str(i) '); '];  % nested "for" commands     
  if i~=1, cmdIndexes=[cmdIndexes ',']; end                           % indexes into the cell array
  cmdIndexes=[cmdIndexes 'i' num2str(i)];                             % indexes into the cell array
  cmdEnds=([cmdEnds ' end;']);                                        % nested "end" commands
end
cmd1=[' Dmean{' cmdIndexes '}=mean(D{' cmdIndexes '}); '];  
cmd2=[' Dconf95{' cmdIndexes '}=confidence(D{' cmdIndexes '},0.95); '];  
cmd3=[' Dstdev{' cmdIndexes '}=std(D{' cmdIndexes '}); '];  

CMD=[cmdFors spacer       cmd1 cmd2 cmd3 spacer         cmdEnds]
eval(CMD);

return

%% original version of this program below: 
% [Drows,Dcols]=size(D);                                              % get dimensions
% 
% for I=1:Drows;   % For each row
%   for J=1:Dcols;     % For each col 
%     Dmean{I,J}=mean(D{I,J});
%     Dstd{I,J}=std(D{I,J});
%     Dconf95{I,J}=confidence(D{I,J},0.95);
%   end % END for I
% end % END for J