% ************** MATLAB "M" function (jim Patton) *************
% change file names so they start w/ last 2 digits of directoryname
% EXAMPLE OF HOW TO DO MULTIPLE DIRECTORIES: 
% for i=12:12; 
%   cd([ num2str(i)]); cd; fprintf('__\n\n'); 
%   changenames; eval('!move *.* ..'); cd ..; 
% end
% %__or: __
% for qq=1:6; cd(['Disc ' num2str(qq)]); changenames; eval('! copy *.* ..'); cd('..'); end
%
% SYNTAX:     changeNames(changeType)
% INPUTS:     changeType    = 'keepName'
%                           = 'removeName'
%                           = 'remove first 6 Char'
%                           = 'remove all but last 6 Char'
% OUTPUTS:    
% VERSIONS:   2-14-05 (patton) modified to allow input arguments
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function changeNames(changeType)

% ============ SETUP ============
prog_name='changeNames.m';                                              % this program's name
fprintf('\n~ %s ~  ',prog_name)                                         % orient user

if ~exist('changeType')|isempty(changeType), changeType='keepName', end % if not passed or zero

CD=parse(cd,'\'); dirName=CD(size(CD,1),:)
s=dir; s(1:2)=[];                                                       % get lising; clip 1st 2
if(size(deblank(dirName),2)>1)
  diskNum=dirName(length(deblank(dirName))-1:length(deblank(dirName))); % get the last 2 chars of the directory name
else
  diskNum=deblank(dirName);
end
if diskNum(1)==' ', diskNum(1)='0'; end                                 % if first of these is whitepace, replace with zero
diskNum

for i=1:size(s,1)
  if ~strcmp('desktop.ini',s(i).name)
    if strcmp(changeType,'removeName')
      newName=[num2str(diskNum) '.' s(i).name(1:2) '.mp3'];             % create simpler new name starting with 'x.' where x is the directory (disk) number
    elseif strcmp(changeType,'remove first 6 Char')
      fileName=s(i).name; fileName(1:9)=[];                             % clip out first 6 characters
      newName=[num2str(diskNum) '.' fileName];                          % create new name starting with 'x.'  
    elseif strcmp(changeType,'remove all but last 6 Char')
      fileName=s(i).name; fileName(1:length(fileName)-6)=[];            % clip out first 6 characters
      newName=[num2str(diskNum) '.' fileName];                          % create new name starting with 'x.'  
    else
      newName=[num2str(diskNum) '.' s(i).name];                         % create new name starting with 'x.'  
    end
    cmd=(['!rename "' s(i).name '" "' newName '"']),                    % create the command
    eval(cmd)                                                           % execute command
  end

end

fprintf('\n~ END %s ~  \n',prog_name)                         % orient user

