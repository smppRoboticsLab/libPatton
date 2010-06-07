% calculate baseline ensemble averages
function baseList=baseline(Dirs,trialsStruct,trialData) 

  % __ Ensemble Average some baseline trials __
  fprintf('\nBaseline Ensembles:');
  nDirs=length(Dirs);                           % number of Dirs
  startTrial=min(trialsStruct(1).trials);       % first for analysis
  baseList=[]; % init
  clf
  protocolNum=1;
  
  for D=1:nDirs
    fprintf(['\nFor the %d degree Dirsection '        ...
      'in robot coordinates:'],Dirs(D));
    outName=['baseline' num2str(Dirs(D)) '.dat']; 
    if ~exist('baseList.txd'),
      dirCount=0;
      for i=startTrial:max(trialsStruct(1).trials),   
        if trialData(i,7)==Dirs(D); 
          dirCount=dirCount+1;
          baseList(D,dirCount)=trialData(i,1); 
        end     % add trial to list
      end % for i
      baseList(D,:)
      ensembleTrials2(baseList(D,:),protocolNum,outName); 
    else
      fprintf('\n (Ensemble "%s" already done)',outName)
      load 'baseList.txd'
    end % END if ~exist
    %disp(' pausing ..');   pause
  end % END for D  
  hdr=str2mat('% list of baseline trials.',           ... %
              '% Each column is a direction');        ... %
  mat2txt('baseList.txd',hdr,baseList);
  fprintf(' Ensebles DONE (see "baseList.txd"). ') 
 
return
  