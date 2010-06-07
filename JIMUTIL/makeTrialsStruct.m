function trialsStruct=makeTrialsStruct(fname,trialsStruct,outNum)

%==========================================================
%=================   Create trialStruct  ==================
%==========================================================

counter=0; 

[h,TRG]=hdrload(fname); % load targets
phase=min(TRG(:,9)); 

% _find startTrial of each experimental phase_
phaseStart(phase)=1;                                    % 
fprintf('\n Phase %d begins @ trial %d'             ... % estimate time 4 sec/trial  
      ,phase,phaseStart(phase));                
i=0; 
while i<size(TRG,1),                            
  i=i+1;                                       
  if TRG(i,9)==(phase+1),                               % find the start of phase
    phase=phase+1;                             
    phaseStart(phase)=i;                       
    fprintf('\n Phase %d begins @ trial %d'         ... % estimate time 4 sec/trial 
      ,phase,phaseStart(phase));                        %
  end                                                   %
end                                                     %
phaseStart(phase+1)=size(TRG,1)+1;                      % one extra to mark the end

%_ Figure out information for trialsStruct _
fprintf('\nGenerating information for phase: ');        % 
for i=1:length(trialsStruct)                            % loop each phase
  fprintf(' %d',i);                           %
  chunk=TRG(phaseStart(i):(phaseStart(i+1)-1),:);       % 
  [fields,nEaField]=distill(chunk(:,6));                % get list of fields in this
  [nEaField,fOrder]=sort(nEaField);fields=fields(fOrder);% sort in ascend order o freq
  common=fields(length(fields));                        % most common one is at end
  if length(fields)==1                                  % if all same 
    trialsStruct(i).trials=chunk(:,1);                  % straight list of trials
  else
    trialsStruct(i).trials=[];                          % init to nothing
    for j=1:size(chunk,1)                               % loop this phase trials
      if chunk(j,6)~=common,
        trialsStruct(i).trials=                     ... % add trial to list 
         [trialsStruct(i).trials chunk(j,1)];           %
      end     
    end    
  end % END if length fields
end
trialsStruct(i).trials;
fprintf('\nDone.')

%__ STORE IN FILE ___
cmd=['save trialsStruct_p'   ...
    num2str(outNum) ' trialsStruct' ];
disp(cmd); eval(cmd); 

% __ display info about trials __
for i=1:length(trialsStruct),                           % loop to display
  fprintf('\n%d) %s:   ',                           ... %
          i,trialsStruct(i).name);
  fprintf(' %d',  trialsStruct(i).trials');
end


%*******************
