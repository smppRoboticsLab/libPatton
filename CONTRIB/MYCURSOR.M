function mycursor(style, size);
% MYCURSOR places a user-defined cursor in the current axes.
% 
% MYCURSOR(STYLE) uses the cursor define by style.  Valid
% styles are:
%
%     +
%     x
%     *
%     o
%     .
%
% MYCURSOR(STYLE,SIZE) allows you to specify the size of the 
% cursor.
%
%
% NOTE: This code can be modified to use any symbol as the marker. 
%       To do this, simply replace the plot command with the 
%       following:
%
%          h = text(X,Y,style,'FontSize',size,'Tag','MYCURSOR');
%
%       You will have to change the default size to 12, and the
%       call to findobj to:
%
%          h = findobj(gcf,'Type','text','Tag','MYCURSOR');
%
%
% DISCLAIMER:  This M-file was developed for my own personal use.
%              It has not been tested, nor is it supported by The
%              MathWorks, Inc.  Please feel free to use and modify
%              this program to suit your needs.

% Written by John L. Galenski III - Aug. 31, 1995
% Copyright(c) By The MathWorks, Inc, 1995
% All Rights reserved
% LDM083195jlg

% Parse the input
if nargin == 0
  style = '+';
end

if nargin == 0 | ~strcmp(style,'CALL') % Initialize
  if nargin == 0
    style = '+';
  end
  if nargin < 2
    size = 6;
  end

  % Add the cursor in the center of the plot
  ax = axis;  % Axis limits
  X = (ax(2)-ax(1))/2 + ax(1);
  Y = (ax(4)-ax(3))/2 + ax(3);
  hflag = ishold;
  if ~hflag
    hold on
  end
  h = plot(X,Y,'LineStyle',style,'MarkerSize',size, ...
           'EraseMode','xor','Color',~get(gcf,'Color'), ...
           'Tag','MYCURSOR');
      % This portion can be enhanced so that the color is based on
      % the color of the axes.  Right now, the assumption is that 
      % the axes color is none (transparent).

  % Set the WindowButtonDownFcn
  set(gcf,'WindowButtonDownFcn','mycursor CALL DOWN')
  
  % Reset the hold state
  if ~hflag
    hold off
  end
  
elseif strcmp(style,'CALL')  % WindowButton<...>Fcn used

  % Get the handle to the cursor
  h = findobj(gcf,'Type','line','Tag','MYCURSOR');
  ax = axis;  % Axis limits
  
  if strcmp(size,'DOWN')

    % Determine if the mouse was clicked in the axes
    FUnits = get(gcf,'Units');
	set(gcf,'Units','normal');
    APos = get(gca,'Position');
    cp = get(gcf,'CurrentPoint');  % Current Point (Figure)
	AFlag = (cp(1)>=APos(1) & cp(1)<=(APos(1)+APos(3))) & ...
            (cp(2)>=APos(2) & cp(2)<=(APos(2)+APos(4)));

	if AFlag  % Mouse click in axes
  
      % Set other WindowButton<...>Fcns
	  set(gcf,'WindowButtonMotionFcn','mycursor CALL MOVE', ...
              'WindowButtonUpFcn','mycursor CALL UP')
    end

    % Reset figure units
	set(gcf,'Units',FUnits)

  elseif strcmp(size,'MOVE')   % WindowButtonMotionFcn
  
    AFlag = 1;
	
  else  % WindowButtonUpFcn

    set(gcf,'WindowButtonMotionFcn',' ', ...
            'WindowButtonUpFcn', ' ')

  end
  
  if AFlag  % Update Cursor
  
    % Update location of the cursor
	cp = get(gca,'CurrentPoint');  % Current Point (Axes)
	X = cp(2,1);
	Y = cp(2,2);
	% Make sure that the cursor stays within axes
	if X <= ax(1), X = ax(1); 
    elseif X >= ax(2), X = ax(2); end
	if Y <= ax(3), Y = ax(3); 
    elseif Y >= ax(4), Y = ax(4); end
	
	set(h,'XData',X,'YData',Y)
  end
end