% IsolateWebPubs: isolates links created by dowebpage.m to make a new webPage
% ************************ MATLAB M function ***************************
% SYNTAX:     IsolateWebPubs(matchList,outFile)
% This custom-designed program should take the current ~smpp_pub file on
% SULU sifts out only the links that have a person's name (or some text) 
% designated by matchList in them, and then makes a new webpage and places
% it in a new destination (designated by outFile)
% Example:  
%           outFile='\\Sulu\wwwroot\robotLab\pub\index.htm';
%           matchList={'mussa-ivaldi'; 'patton'}
%           IsolateWebPubs(matchList,outFile)
%
% INPUTS:     matchList     cell array of names to match (non-case-sensitive)
%             outFile       path and destination of output web file. This 
%                           should have a html-type file extension
% OUTPUTS:    outFile       file that has the sifted fversion of the html
% CALLS:      hdrload.m, str2mat.m
% REVISIONS: 	WingsPlotOfChanges.m Adapted by Patton 3/25/05 from: 
%               -- $Id: calc_blae.m 258 2005-02-21 22:00:55Z scharver $
%               -- $Id: fig_blae.m 257 2005-02-17 00:09:37Z scharver $
%             Patton 5-12-05 added statistical significance for each
%                            subject, indicated by dotted lines for not
%                            significant.
%
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ end of header ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function IsolateWebPubs(matchList,outFile)

%% load
inFileName='\\165.124.30.17\Public\smpp-internal\~smpp_pub\index.htm';
fprintf('Loading %s...',inFileName);
[h,junk]=hdrload(inFileName);
fprintf('Done. ');

%% search
fprintf('Searching for: ');
matchList
OUT=[];
hitCount=0;
for i=1:size(h,1)
  a=(h(i,:));
  if (strncmpi(a,'<tr><td><b>',11))                 % if one of the rows that has a link
    HIT=0;                                          % initialize to false
    for listIndex=1:size(matchList,1)               % 
      if (sum(regexpi(a,matchList{listIndex})))...  % if it contains name on list
          HIT=1;                                    % 
      end                                           %
    end                                             % END for listIndex
    if HIT
      a=strrep(a,'</b><td><a href="','</b><td><a href="http://www.smpp.northwestern.edu/~smpp_pub/'); % add the abolute address, because this will be in another area
      OUT=str2mat(OUT,a);                           % stack this on
      fprintf('.');                                 % indicate progress 
      hitCount=1+hitCount;                          % increment link count 
    end                                             % END if HIT
  else                                              % if one of the rows that does not have a link
    if sum(regexpi(a,'_vti'))...                    % remove stuff that is unwanted
      |sum(regexpi(a,'sorted by'))...
      |sum(regexpi(a,'how_to_post_on'))...
      |sum(regexpi(a,'Sub-Directories:')),
      a='<p>';                                      % new line
    end
     if (strncmpi(a,'<h1>',4)),                     % if major header
%       a=['<h1>Publications as of ' whenis(clock) '</h1>'];                    % replace major header
      a=['<h1>Publications </h1>'];                    % replace major header
    end
   OUT=str2mat(OUT,a); % stack this on
  end
end
fprintf('Done (%d links found).',hitCount);



%% save
fprintf('Saving (%s)...',outFile);
mat2txt(outFile,OUT,[]);
fprintf('Done. \n');
