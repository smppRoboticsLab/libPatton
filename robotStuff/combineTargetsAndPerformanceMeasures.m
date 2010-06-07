% ***************** MATLAB M function ***************
% takes all target files and performance measures resutls and combines them
% SYNTAX:   combineTargetsAndPerformanceMeasures()
% INPUTS:    
% OUTPUTS:  file
% REVISIONS: 	3-23-05 by Patton. Initiated from batch1.m
%             4-24-08 (patton) added the paramters file at the top
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function combineTargetsAndPerformanceMeasures()

%%____ SETUP ____
progName='combineTargetsAndPerformanceMeasures.m';
fprintf('\n~ %s ~     Combining...',progName);  
BIG_OUTh=str2mat(['This file was made by "' progName '"'],  ...
                 'It collects all the paramters file, targets & performance measures from an experiment into one big file', ' ');

%%____ parameters file ____
if exist('parameters.txd','file'),
  [params,junk]=hdrload('parameters.txd');
elseif exist('parameters.txt','file'),
  [params,junk]=hdrload('parameters.txt');
else
  params=' (no parameters file found) ';
  fprintf(' %s ', params)
end
BIG_OUTh=str2mat(BIG_OUTh,              ...
      ' ',  ' ',' ','******* paramters file: *******',' ', params);

%%____ targetfile(s) ____
TARGS=[]; 
PART=0;
while(1)
  PART=PART+1;
  filename=['targ_p' num2str(PART) '.txd'];
  if ~exist(filename)
    break
  end
  [th,d]=hdrload(filename); 
  BIG_OUTh=str2mat(BIG_OUTh, ...
       ' ',  ' ',' ',['******* header information for part ' ...
       num2str(PART) ' targets: *******'],' ', th);
  TARGS=[TARGS; d]; 
end;    

%%____ performance measures file ____
[h,d]=hdrload('performMeas.txd'); 


%%____ checking____
fprintf('%dx%d targets with %dx%d performance measures',size(TARGS),size(d))
if size(TARGS,1)~=size(d,1),
  fprintf('\n values do not jive! \n')
  TARGS,d
  fprintf('\n values do not jive! (%s) \n',cd)
  fprintf('%dx%d targets with %dx%d performance measures.      ',size(TARGS),size(d))
  error('values do not jive! ')
end

%%____ combination ____
BIG_OUT=[TARGS d]; 
BIG_OUTh=str2mat(BIG_OUTh,...
               ' ',  ' ',' ','******* performance measures header: *******',' ', h,         ...
                ' ',  ' ',' ','******* compiled column header row follows: *******',' ',    ...
                 [th(size(th,1),:) char(9) h(size(h,1),:)]); 
                
mat2txt('TargsPlusPerformMeas.txd',BIG_OUTh,BIG_OUT);
fprintf('Done. \n~ END %s ~ \n',progName);                           % message

