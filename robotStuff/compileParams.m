%****************** MATLAB "M" function  ****************
% compile a list of stuff in a big table from paramter files.
% rules:      *  All lines have a variablename, then an equals sign then stuff
%             *  remark lines have an "_" or "%" as first char
% SYNTAX:     compileParams(?)
% REVISIONS:  17-May-2001 (patton) INITIATED
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~~~

function compileParams(prefix,subjNums)

% ____ SETUP ____
prog_name='compileParams.m';                              % name of this program
fprintf('\n~ %s ~ ', prog_name);                          % MSG
inName='parameters.txt';
outName='parameters.txd'
if ~exist('prefix'),                                      %
  prefix=input(                                       ... % 
   'File prefix (e.g., "IFD"): ');                        % 
end                                                       % if not passed
if ~exist('subjNums'),                                    %
  subjNums=input(                                     ... % 
   'subject Numbers (e.g., 1:20): ');                     % 
end                                                       % if not passed
sep=str2mat(' ',' ',' ','______________________',' ');    % separator strings

%__ Get list of things: __
fprintf('\nLOAD LIST OF VARS ... \n');                    % MSG
cmd=(['cd ' prefix num2str(max(subjNums))]);
disp(cmd);eval(cmd)                                       % change to directory
h=hdrload(inName);[rows,cols]=size(h);                    % load file 2 string array
varList=[]; % init
for i=1:rows;                                             %
  if(h(i,1)~='_' & h(i,1)~='%' & h(i,1)~='_');            % 
    for j=1:cols,
      if (h(i,j)=='='), 
        varList=str2mat(varList,deblank(h(i,1:j-1)));   
        break
      end 
    end  
  end
end
varList(1,:)=[] % clip 1st row
Nvars=size(varList,1);
cd ..

%__ setup output file __
fprintf('\n\nFINDING DATA FOR LIST ... ');                % MSG
outFid=fopen(outName,'w')                                 %
for i=1:Nvars                                             %
  fprintf(outFid,'%s\t',deblank(varList(i,:)));           %
end                                                       %
fprintf(outFid,'\n');                                     % add carriage return
  
%__ extract each value & output to file __
if outFid==-1, error(' Cant open output file.'); end      %
%subjCount=1;                                             %
for subj=subjNums,                                        % subj loop
  %subjCount=subjCount+1;                                 %
  cmd=(['cd ' prefix num2str(subj)]);                     % change to directory
%   disp(cmd);
  eval(cmd);                                              % change to directory
  cd
  fprintf('\nSubj %d Loading data..',subj)                % 
  for i=1:Nvars                                           %
    S=[];                                                 % init
    S=findInTxt(inName,[deblank(varList(i,:)) '='],'s');  % load item
    if isempty(S), S=' '; end
    fprintf(outFid,'%s\t',S);                             % save in new file
    fprintf('.');                                         % dot
  end                                                     % end for i
  fprintf(outFid,'\n');                                   % add carriage return
  h=hdrload(inName);[rows,cols]=size(h);                  % load file 2 string array
  cd ..
  textAppend(sep,'concatonatedParamters.txt',         ... % line separator
    ~('verbose'),'noTimeStamp');                          %
  textAppend(str2mat(['SUBJ # ' num2str(subj)],''),   ... %
  'concatonatedParamters.txt',~('verbose'),'noTimeStamp');% line separator
  textAppend(h,'concatonatedParamters.txt',           ... %
    ~('verbose'),'noTimeStamp');                          %
end                                                       % END for subj              

fclose(outFid); 
fprintf('\n\n Output file: %s', outName)

fprintf('\n~ END %s ~ ', prog_name); 

