% ************** MATLAB "M" function  (jim Patton) *************
% Separate out strings separated by tabs in a line of text
%  SYNTAX:	list=parse(S,delimiter)
%  INPUTS:	S		a string (row vector) of phrases 
%				separated by tabs. 
%		delimiter 	an ascii code for whichever character
%				separates the phrases.  Note:
%					TAB		=9
%					Comma		=44
%					Semicolon	=59
%  OUTPUTS:	list		string matrix of phrases with each line  
%				phrase from the original string S
%  CALLS:	-
%  INITIATIED:	6/4/97 		jim patton. 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Function: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function list=parse(S,delimiter)

%__ SETUP __
global DEBUGIT							% =1 for verbose
if DEBUGIT, fprintf(' ~ parse.m ~ '); end			% message
if ~exist('delimiter'), delimiter=9; end			% use tab as default
len=length(S);							% length
phrase=[];
list=[];

%__ ERROR CHECK __
if length(S(:,1))>1 						% if S is matrix
  error(' ABORTING Parse.m: input argument is a matrix');	% abort
end;								%

%__ PARSE __
for i=1:len; 							% loop char by char
  if S(i)~=setstr(delimiter),					% if not delimiter 
    phrase=[phrase S(i)];					% add to phrase
  else								% if delimiterORend 
    list=str2mat(list,phrase);				% add phrase to list
    phrase=[];							% reset phrase 
  end; 								% end IF S(i)~=
end;								% end for i 
list=str2mat(list,phrase);					% add phrase to list
list=list(2:length(list(:,1)),:);				% remove 1st line

if DEBUGIT, fprintf(' ~ END parse.m ~ '); end
