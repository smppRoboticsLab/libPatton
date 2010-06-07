% ******** MATLAB "M" functionn (jim Patton) **********
% add a good trial column to the targ_p?.txd
%~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~


function addGoodTrialColumn2targ()

fcnName='addGoodTrialColumn2targ.m';
fprintf('\n\n~ %s ~ ',fcnName); 

% setup
i=0;
fprintf('\nPart: ')

% loop
while(1)
  i=i+1;
  fprintf(' %d',i)

  filename=['targ_p' num2str(i) '.txd'];
  if exist(filename)
    [h,d]=hdrload(filename);
    colHdrs=parse(h(size(h,1),:));          % get list of column headers
    lastHdr=deTabBlank(colHdrs(size(colHdrs,1),:));
    if strcmpi(lastHdr,'')
      lastHdr=deblank(colHdrs(size(colHdrs,1)-1,:));
    end
    if strcmpi(lastHdr,'Good trial');
      fprintf('-- "Good trial" column already there.\n      ')
    else
      lastrow=deblank(h(size(h,1),:));
      if lastrow(length(lastrow))==char(9), 
        lastrow(length(lastrow))=[]; 
      end
      h=str2mat(h(1:size(h,1)-1,:),         ...
         [lastrow char(9) 'Good trial']);
      d=[d ones(size(d,1),1)];
      mat2txt(filename,h,d);
      fprintf('-- added column.\n      ')
    end
  else
    fprintf('   NOT THERE. NO MORE PARTS. ')
    break
  end
end % while

fprintf('\n~ END %s. ~\n\n',fcnName);

return