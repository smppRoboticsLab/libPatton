%________________*** MATLAB "M" script (jim Patton) ***________________
% Sets up robot radial control bases (RCB):
% SYNTAX:     setupRCB(widths,centers,verbose);
% INPUTS:     widths      width (regions of effectivenes) of each basis
%             centers     rows are for each basis, cols are x, y
%             verbose     (OPTIONAL)  nonzero for messages
% VERSIONS:   initiated from a PART OF set_params.m 3/13/00
%_____________________________ BEGIN: ________________________________

function RCB=setupRCB(widths,centers,verbose);

%_________ SETUP ________
global RCB rc 
fcnName='setupRCB.m';
if ~exist('verbose'), verbose=1; end              % if not passed
if length(widths)~=size(centers,1),               % CHECK IF BAD INPUTS
  error(['"widths" must have the same '       ... %
         'dimension as "centers"'])
end
if verbose,
  fprintf(' ~ %s ~ (%d RCB bases) ',          ... %
    fcnName,length(widths)); 
end   %
gsf=4.2919;                                       % makes gaussian have width 1 
                                                  % at 1% of  total magnitude 
curl=1;

% clear RCB if there 
if exist('RCB'),
  for i=1:length(RCB), RCB(1)=[]; end               % clear it
end

b(:,:,1)=[  0   1
            0   0 ];
b(:,:,2)=[  0   0
           -1   0 ];
b(:,:,3)=[  0  -1
            0   0 ];
b(:,:,4)=[  0   0
            1   0 ];

% ___ SEUP Radial RCB FIELDS ___
method='two'
switch method
case 'one',
  for i=1:length(widths)
    k=(gsf/widths(i))^2;                            % region of effectiveness
    RCB(i).C=centers(i,:);                          % center of the basis
    RCB(i).B=[0 1; -1 0];                           % init
    RCB(i).K=k.*eye(2);                             % uniform gaussian width    
  end % END for i
case 'two'
  count=0;
  for i=1:length(widths)
    for j=1:4
      count=count+1;
      k=(gsf/widths(i))^2;                            % region of effectiveness
      RCB(count).C=centers(i,:);                          % center of the basis
      RCB(count).B=b(:,:,j);
      RCB(count).K=k.*eye(2);                             % uniform gaussian width    
    end % END for j
  end % END for i
case 'three'
  count=0;
  for i=1:length(widths)
    for j=1:2
      count=count+1;
      k=(gsf/widths(i))^2;                            % region of effectiveness
      RCB(count).C=centers(i,:);                          % center of the basis
      RCB(count).B=zeros(2,2);
      RCB(count).B(j)=1;
      RCB(count).K=k.*eye(2);                             % uniform gaussian width    
    end % END for j
  end % END for i
case 'four'
  count=0;
  for i=1:length(widths) 
    k=(gsf/widths(i))^2;                                 % region of effectiveness
    for j=1:4
      count=count+1;
      RCB(count).C=centers(i,:);                          % center of the basis
      RCB(count).B=b(:,:,j);
      RCB(count).K=k.*eye(2);                             % uniform gaussian width    
    end % END for j
  end % END for i
otherwise
  error('\nUnknown method.\n')
end % END switch

%fprintf('B values:\n')
%for i=1:length(RCB),  
%  fprintf('B%d= ',i), RCB(i).B
%end

if verbose,fprintf(' ~ END %s ~ ',fcnName); end   %
