% ************** MATLAB "M" function (jim Patton) *************
% search for the important trials for each phase of a target list (manipulandum)
% SYNTAX:     trialsStruct=probeTrialsStruct(fname,verbose)
% INPUTS:     part         experimental part number
%             verbose       (optional) nonzero for verbose display (default=1)
% OUTPUTS:    trialsStruct  list of names and critical trails 
% VERSIONS:   8/22/2 initiated
%             8/29/2 renamed version 2 and allowed for loading of existing file 
%                     if it is there, and determining it otherwise
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function trialsStruct=probeTrialsStruct2(part,verbose)
diary('protocolDescription.txt');

% __ SETUP __
fcnName='probeTrialsStruct2.m';
if ~exist('verbose')|isempty(verbose),verbose=1;end     % if not passed
fprintf('\n\n~ %s  ~ ', fcnName);                         % MSG
fprintf('\n~ Protocol for PART %d of %s ~ ',    ...
    part, cd);        % MSG
counter=0;                                              % setup
filename=['trialsStruct_p' num2str(part) '.mat'];
if(exist(filename))                                     % if trialsStruct already created
  load(filename);                                       % load it
  diary off                                              
  return;                                               % break out of while loop
end 
 
% load and get info from target file  
fname=['targ_p' num2str(part) '.txd']; 

fprintf('\nloading %s.. ',fname);                   % msg
[h,TRG]=HDRLOAD(fname);                                 % load targets
experimental_phases=textract(fname,'experimental_phase');
fieldTypes=textract(fname,'fieldType');
% phase=min(TRG(:,9));                                  % start phase is lowest
% phaseList=distill(TRG(:,9));                          % get list phases
phase=min(experimental_phases);                         % start phase is lowest
phaseList=distill(experimental_phases);                 % get list phases
nPhases=length(phaseList);                              % 
% phaseList

if verbose, fprintf(' Finding names:'); end
% find the names of each phase
for phase=phaseList                                     % loop to search for names
  trialsStruct(phase).name=deblank(findInTxt(fname, ... % find and put in trailsStruct
      ['Phase '  num2str(phase) ' name='],'s'));        %
  if isempty(trialsStruct(phase).name),                 % if not found
    trialsStruct(phase).name=['Phase ' num2str(phase)]; % default name if nothing there
  end                                                   % 
  if verbose, fprintf('\n Phase %d: %s. '           ... % 
      ,phase,trialsStruct(phase).name)                  %
  end                                                   %
end                                                     %

% find startTrial of ea experimental phase
if verbose, fprintf('\nFinding start trials for phases: '); end% 
phase=min(experimental_phases);                         % start phase is lowest
phaseStart(phase)=1;                                    % init phase start trial to 1
if verbose,                                             %
  fprintf('\n Phase %d (%s) begins @ trial %d'      ... % 
    ,phase,trialsStruct(phase).name,phaseStart(phase))  %
end                                                     %
i=0; 
while i<size(TRG,1),                                    %
  i=i+1;                                                %
  if experimental_phases(i) ~= phase,                                 % find the start of phase
    phase=phase+1;                                      % increase phase
    phaseStart(phase)=i;                                % mark as beginning of new phase
    if verbose,                                         %
    fprintf('\n Phase %d (%s) begins @ trial %d'  ... % 
      ,phase,trialsStruct(phase).name,phaseStart(phase))%
    end                                                 %
  end                                                   %
end                                                     %
phaseStart(phase+1)=size(TRG,1)+1;                      % one extra to mark the end

% Figure out information for trialsStruct 
if verbose, fprintf('\nKey trials for each phase:'); end% 
for i=1:nPhases                                         % loop each phase
  if verbose,   fprintf('\n  %d: ',i);   end            %
  chunkIndexes=phaseStart(i):(phaseStart(i+1)-1);
  chunk=TRG(chunkIndexes,:);       
  chunkFieldTypes=fieldTypes(chunkIndexes);             % 
  [fields,nEaField]=distill(chunkFieldTypes);           % get list of fields in this
  [nEaField,fOrder]=sort(nEaField);fields=fields(fOrder);% sort in ascend order o freq
  common=fields(length(fields));                        % most common one is at end
  if length(fields)==1                                  % if all same 
    trialsStruct(i).trials=chunk(:,1);                  % straight list of trials
  else
    trialsStruct(i).trials=[];                          % init to nothing
    for j=1:size(chunk,1)                               % loop this phase trials
      if chunkFieldTypes(j)~=common,
        trialsStruct(i).trials=                     ... % add trial to list 
         [trialsStruct(i).trials chunk(j,1)];           %
      end     
    end    
  end % END if length fields
  if verbose,fprintf(' %d',trialsStruct(i).trials);end  %
  drawnow
end
if verbose,fprintf('\nDone. Storing..'); end
save(filename,'trialsStruct')

if verbose, fprintf('\n~ END %s ~ ',fcnName); end           %
diary off