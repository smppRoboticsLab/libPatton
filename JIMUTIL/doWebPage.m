% ************** MATLAB "M" function (jim Patton) *************
% Create a webpage from the current directory. 
%   This program is desined to quickly make a webpage from a directory 
%   of pictures using a simple command: "dowebpage," but still be 
%   flexible enough to other things, such as creeate a list of links
% SYNTAX:     doWebPage(doList,filename,picWidth,sortBy,recurseDirs,verbose)
% INPUTS:     doList      (optional) nonzero for list of links instead of pics
%                          if doList is a matrix of strings, then links will 
%                          only be made to those files with matching file 
%                          extensions, for example, '.html'
%             filename    (optional) output file name with exstension
%             picWidth    (optional) width of each picture
%             sortBy      (optional) default='name'; you can also 
%                          enter 'date', 'bytes', or 'isdir'
%             recurseDirs (optional) default=TRUE. also do subdirectories
%             verbose     (optional) default=FALSE comments- what's happening
% OUTPUTS:    
% VERSIONS:   5-11-0      (Patton) init
%             2-23-02     (patton) Add recognition of <!BIBLIO=...>
%             2-23-04     (patton) add  capability for listing links to movies 
%                         & remove 'index.htm' & 'thumbs.db' from being listed 
%             9-17-06     (patton) add  capability for listing links to PDF 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function doWebPage(doList,filename,picWidth,sortBy,recurseDirs,verbose)

% ============ SETUP ============
prog_name='doWebPage.m';                                % this program's name
fprintf('\n~ %s ~  ',prog_name)                         % orient user

if ~exist('doList','var')||isempty(doList),doList=0;end % if not passed or zero
if ~exist('filename')||isempty(filename), ...
    filename='index.htm'; 
end                                                     % if not passed
fprintf('search for %s (clear before starting)..'   ... % 
  ,filename)
%eval(['! erase ' filename]);                           % erase if exists
if ~exist('picWidth'), picWidth=[]; end                 % if not passed
if ~exist('sortBy')||isempty(sortBy), sortBy='name'; end % if not passed
if ~exist('recurseDirs')||isempty(recurseDirs),      ... % if not passed
    recurseDirs=1;                                      % DO this on subdirs
end                                                     %
if ~exist('verbose'), verbose=0; end                    % if not passed
CD=parse(cd,'\'); dirName=CD(size(CD,1),:)
s=dir; s(1:2)=[];                                       % getLising&clip1st2
H=str2mat('<html>',                                 ... % 
  '<! created using doWebPage.m by Jim Patton>',    ... %
  ['<body bgcolor="#FDFFE6" '                       ... %
  'background="background.jpg">'],                  ... %
  '<font face="Arial">' ,                           ... % 
  ['<h1>' dirName '</h1>'],                         ... % 
  ['<b><a href="..">Go up one directory</a></b>'],  ... %
  ['<p>'],                                          ... %
  ['<small><i>Sorted by ' sortBy ':</i></small>'] );    %
D='<p><hr><large> <b>Sub-directories:</b></large><br>';
S=' ';
MOV=' ';
DOC=' ';
AUD=' ';
Bflag=0;                                                % init biblio info
Dflag=0;                                                % init subdirect.
if ~isempty(picWidth), 
      picWidthStr=['width=' num2str(picWidth)];
else, picWidthStr=[];
end
len=length(s);
fprintf('\n %d items in this directory. \n', len)

% construct matrixes/vectors for sorting 
date=NaN*zeros(len,1);                                    % init size&shape
bytes=NaN*zeros(len,1);
isdir=NaN*zeros(len,1);
name=s(1).name;  
date=datenum(s(1).date); 
bytes=s(1).bytes; 
isdir=s(1).isdir;
for i=2:length(s)                                         % loop ea element 
  name=str2mat(name,s(i).name);                           % stack this on
  date(i,1)=datenum(s(i).date);                           % stack this on
  bytes(i,1)=s(i).bytes; 
  isdir(i,1)=s(i).isdir;                                  % stack
end
%date=flipud(date)                                        % most recent 1st

% re-order using matrixes/vectors for sorting 
eval(['[junk,I]=sortrows(' sortBy ');']);                 % indexes4reorder
s=s(I);                                                   % reorder

% __ generate list ___
fprintf('\nMaking list..'); pause(0.01);                  % message
for i=1:length(s)                                         % loop ea element 
  fprintf('.')
  if verbose, fprintf('    "%s" \n   ',s(i).name); end    % show the names 
  
  if ~(strncmp(s(i).name,'thumb_',6))                     % if not thumbnail 
  
    if s(i).isdir                                         % if element is subdirectory
      Dflag=1;                                            % set to true
      if ~strcmp(s(i).name,'_vti_cnf')                    % skip if utility
        D=str2mat(D,['  <a href="' s(i).name       ...    % make  boldfaced
          '/' filename '">Click here for <b>' s(i).name...%
          '</a> </b><br>']);                              %
        if recurseDirs,                                   % if recursing subdirectories
          fprintf('\nrecursing subdirectory: ');          % message
          pause(0.01); cd(s(i).name); cd
          doWebPage(doList,filename,picWidth,         ... % make page4subdr
            sortBy,recurseDirs,verbose);
          fprintf('\nDone recursing subdirectory. ');     % message
          cd ..
          cd
        end
      end

      
    else                                                  % if not a subdirectory:
 
      if doList,   %____ list ____                        % ===== if make a list =====
        if isstr(doList(1,:))                             % if there is list of filetypes
          for j=1:size(doList,1)                          % loop for ea element in doList
            listElement=deblank(doList(j,:));             %
            if strncmp(fliplr(s(i).name),             ... % if end of name matches list
                fliplr(listElement),                  ... % 
                length(listElement))                      %
              fprintf('x');                               %
              %fprintf(' Scanning %s..\n',s(i).name); 
              listName=deblank(findInTxt(s(i).name,   ... % search for strig starting with bibio
                '<!BIBLIO=','string'));
              year=deblank(findInTxt(s(i).name,       ... % search for year designation
                '<!YEAR=','string'));              
              if(isempty(listName))              
                listName=s(i).name(1:(length(s(i).name)...% clip off the extension
                  -length(listElement))); 
              else
                fprintf('B');
                Bflag=1;
                listName(length(listName))=[];            % clip training '>'
              end
              if ~isempty(year),
                fprintf('Y');
                year(length(year))=[];                  % clip training '>'
                listname=[...%'<b>[', year, ']</b>'     ... % add year to the list item
                    , ' ', listName]; 
                listName;
              else
                year=' ';
              end
              pause(.01)       
%               S=str2mat(S,['<li> <b>[' year ']:</b>'   ...
%                 ' <a href="' s(i).name                 ... % add link
%                   '">'  listName '</a>']);                 %
              if(~strcmp(lower(s(i).name),'index.htm'))
                S=str2mat(S,['<tr><td><b>' year '</b>'...
                 '<td><a href="' s(i).name            ... % add link
                  '">'  listName '</a>']);
              end
              break                                       % quit the loop
            end                                           % END if strncomp..
          end                                             % END for j
        else                                              % otherwise, no list of filetypes
          if(~strcmp(lower(s(i).name),'index.htm'))
            S=str2mat(S,[' <li> <a href="' s(i).name  ... % link to file
              '">' s(i).name '</a>']);                    %
          end
        end                                               % END if s(i)
        S=sortrows(S); S=flipud(S); 
 
        
        
        
      else                                                  % ===== else images =====
        if    ( strcmp(s(i).name,'index.htm')           ... % not to be included
              ||strcmp(s(i).name,'Thumbs.db') )
          fprintf('(Skipping %s)',s(i).name)
        elseif(strncmpi((fliplr(s(i).name)),fliplr('mov'),3)...% if a kind of movie
             ||strncmpi((fliplr(s(i).name)),fliplr('mpg'),3)...
             ||strncmpi((fliplr(s(i).name)),fliplr('avi'),3)...
             ||strncmpi((fliplr(s(i).name)),fliplr('3g2'),3)...
             ||strncmpi((fliplr(s(i).name)),fliplr('wmv'),3)),
          MOV=str2mat(MOV,['<BR> Movie: <a href="' s(i).name... % add link
                  '">'  s(i).name '</a> <BR>']);
        elseif(strncmpi((fliplr(s(i).name)),fliplr('doc'),3)...% if a kind of movie
             ||strncmpi((fliplr(s(i).name)),fliplr('pdf'),3)...
             ||strncmpi((fliplr(s(i).name)),fliplr('rtf'),3)...
             ||strncmpi((fliplr(s(i).name)),fliplr('txt'),3)),
          DOC=str2mat(DOC,['<BR> Document: <a href="' s(i).name... % add link
                  '">'  s(i).name '</a> <BR> ']);
        elseif(strncmp((fliplr(s(i).name)),fliplr('wav'),3)...% if a kind of movie
             ||strncmp((fliplr(s(i).name)),fliplr('mp3'),3)...
             ||strncmp((fliplr(s(i).name)),fliplr('m4a'),3)...
             ||strncmp((fliplr(s(i).name)),fliplr('wmf'),3)),
          AUD=str2mat(AUD,['<BR> Sound: <a href="' s(i).name... % add link
                  '">'  s(i).name '</a> <BR> ']);
        else
          if isempty(picWidth)                              % if no picture width given
            S=str2mat(S,['<hr> <p> ' s(i).name               ... % add link
                ':  ']);
            S=str2mat(S,['<img SRC="' s(i).name         ... % show full image
                '" ' picWidthStr ' TITLE="'             ... % 
                s(i).name '">']);                           %
          else                                              % otherwise,
            [junk,junk,thumbName]=makeThumb(s(i).name   ... % create a thumbnail
              ,picWidth);                
            S=str2mat(S,['<a href="' s(i).name          ... % show resized pic with link
                '"> <img SRC="' thumbName '" '          ... % put up the thumbnail
                picWidthStr ' TITLE="' s(i).name        ... %
              ' - CLICK to see larger image"></a><!br>']);  %
          end                                               % END if isempty(...    
        end                                               % END if  ( strcmp(s(i).name,...
      end                                                 % END if dolist
    end                                                   % END  if s(i)....
    
  end                                                     % END if ~(strncmp...(not thumb)

end                                                       % END for i 
fprintf('DONE.') 
fprintf('\n%d items found. ',size(S,1)-1);

if ~Dflag, D=[]; end                                    % no header if there no subdirectories
if Bflag,
  S=str2mat('<table>', ...
    '<tr bgcolor="#0000B0"><td><h1><font color="#FFFFFF">YEAR<td><h1><font color="#FFFFFF">TITLE:' ...
    ,S,'</table>');
else
  xtra=[];
end

S=str2mat(H,D,'<hr>',MOV,'<hr>',AUD,'<hr>',DOC,'<hr>',S,['<hr><small> <i>(Last updated '... %
    whenis(clock) '</small> </i>)']);

disp(' saving... ')
mat2txt(filename,S,[]);
pause(.5)
%eval(['!' filename]);