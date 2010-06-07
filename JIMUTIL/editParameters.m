% parameterEditor.m edit the data in the standard parameters file for patton
%% ************** MATLAB "M" script  (jim Patton) *************
% This program suite reads in data from a text paraeters file that has
% values defined in the following way:
%    data Name string=outputValue
%  SYNTAX:      elements=editParameters(inName)
%  INPUTS:      inName      optional input file name
%  OUTPUTS:     elements    structure representing the input file
%  INITIATIED:	2005 by patton. This replaces TestUI.m 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function elements=editParameters(inName)

%% setup
global elements outName inExtraDataBlock
elements=[];
if ~exist('inName','var'), inName='parameters.txt'; end         %
if ~exist(inName,'file'); 
  error('\n\nFile not found: %s\n',inName);  
end
outName=inName;

%% __ Get list of things: __
fprintf('\nLOAD LIST OF VARS ...');                       % MSG
[h,inExtraDataBlock]=hdrload(inName);                     % load file 
[rows,cols]=size(h);                                      % 
varCounter=0;                                             % init
for i=1:rows;                                             %
  if(h(i,1)~='_' & h(i,1)~='%' & h(i,1)~='-');            % if not a variable
    for j=1:cols,
      if (h(i,j)=='='),
        varCounter=varCounter+1;
        S=parse(h(i,:),'=');
        elements(varCounter).name=deblank(S(1,:));
        if size(S,1)>1,
          elements(varCounter).value=deblank(S(2,:));     % add value
        end
        break
      end 
    end  
  end
end
fprintf('%d variables loaded. ',varCounter);                    % MSG
parameterEditor(); % this function is below
clear elements
return



% parameterEditor: edit the data of a standard parameters file for patton
%% ************** MATLAB "M" script  (jim Patton) *************
%  SYNTAX:  
%  INPUTS:  
%  OUTPUTS:	
%  INITIATIED:	 
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function elements=parameterEditor()
global elements
fprintf('\n ~~Paramters Editor~~ \n')

textHeight=7;
gap=textHeight+9;

figure(1000); clf; set(gcf,'name','Paramter Editor'); 
put_fig(1000, .2, .03, .3, .95);

% Title
vPos=length(elements)*gap+gap*3;
uicontrol('style','text', ...
            'FontSize', 14, ...
            'string','Parameters',  ...
            'Position', [10 vPos 550 textHeight+gap*3], ...
            'HorizontalAlignment','Center');

% loop for each individual element
for i=1:length(elements)
  vPos=length(elements)*gap-i*gap+gap*3;
    
  % display variableName
  uicontrol('style','text', ...
            'string',[elements(i).name '  =  '],  ...
            'FontSize', textHeight, ...
            'Position', [10 vPos 250 textHeight+gap], ...
            'HorizontalAlignment','right');
          
  % display value
  elements(i).hdl=uicontrol( 'Style','edit',  ...a
                            'String',elements(i).value,  ...
                            'FontSize', textHeight, ...
                            'Position', [260 vPos 300 textHeight+gap],   ...
                            'HorizontalAlignment','left', ...
                            'Callback', '');
end

% pushbutton that shows the data by calling showelements
OK_h=uicontrol( 'Style','pushbutton',  ...
                'String', 'Display Data', ...
                'FontSize', textHeight, ...
                'Position', [10 10 140 textHeight+gap], ...  % [in-from-left, up-from-bottom, width, height
                'Callback', 'editParameters_showElements'); 
              
% pushbutton that saves the data by calling saveElements
OK_h=uicontrol( 'Style','pushbutton',  ...
                'String', 'Save Changes & close', ...
                'FontSize', textHeight, ...
                'Position', [160 10 140 textHeight+gap], ...  % [in-from-left, up-from-bottom, width, height
                'Callback', 'editParameters_saveElements; '); 
                
% pushbutton that aborts 
OK_h=uicontrol( 'Style','pushbutton',  ...
                'String', 'Cancel Changes & Close', ...
                'FontSize', textHeight, ...
                'Position', [310 10 140 textHeight+gap], ...  % [in-from-left, up-from-bottom, width, height
                'Callback', 'figure(gcf); close;'); 
                
return







