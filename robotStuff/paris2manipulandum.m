% 
%
% ___ begin:___

function paris2manipulandum(fileName);

if ~exist('fileName'),fileName='output.txt'; end

fprintf('\n\n\n\n\n\n Reading...');
[INh,INd]=hdrloadPlus(fileName);
fprintf('%d movements.\n',length(INd));

for trial=1:length(INd)
  fprintf('.');
  if (round(trial/80)==trial/80);  fprintf('\n'); end
  OUTname=['p1_' num2str(trial) '.dat'];
  D=INd{trial};
  OUTd=[D(:,2) D(:,4) 0*D(:,2) 0*D(:,2) D(:,8) D(:,10)];
  OUTh=(str2mat('ManagedData',                          ...
                [num2str(size(INd,1)) ' RECORDS'],      ...
                '{'));
  mat2txt(OUTname,OUTh,OUTd);

  textappend(['-7777' char(9)  '413' char(9) '100' char(9) '0' char(9) '0' char(9) '0'],OUTname,0,'noTimestamp');
  textappend(['-7777' char(9)  '0' char(9) '0' char(9) '0' char(9) '0' char(9) '0'],OUTname,0,'noTimestamp');
  textappend('}',OUTname,0,'noTimestamp')   ;
end

