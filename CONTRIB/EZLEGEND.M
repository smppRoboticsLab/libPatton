function ezlegend(command)
%
%   GUI input for legends and linetypes 
%   
%   typing 'ezlegend' from the command line opens an 
%   interactive dialogue box, allowing the user to specify
%   legend labels, linestyles, line colors, linewidths, and
%   markersizes using pulldown menus.  
%   
%   This routine requires Matlab's 'legend.m' ver 4.2
%                             
%   Richard G. Cobb    3/96
%   rcobb@afit.af.mil
%
if nargin < 1
siblines=[];
sibs=get(gca,'children');
for i=1:length(sibs)
 if strcmp('line',get(sibs(i),'type'))
  siblines=[siblines,sibs(i)];
 end
end
%
haold=gcf;
T1=['- ';'--';': ';'-.';'. ';'+ ';'* ';'o ';'x '];
T2=['cyan   ';'magenta';'green  ';'red    ';'yellow ';...
      'blue   ';'black  ';'white  '];
T3=['SMALL';'Small';'small';'large';'Large';'LARGE'];
T4=['THIN';'Thin';'thin';'fat ';'Fat ';'FAT '];

si=[0 0 0 0 0]';si2=si;
si(1:length(siblines))=siblines;
leginp=figure('Color','k','NumberTitle','off','Name',...
	'LEGEND INPUT',...
	'NextPlot','new',...
	'Units','Normalized',...
        'Menubar','none',...
	'Position',[.1 .1  .4 .1+.05*length(siblines)]);
sfactor=.25/(.1+.05*length(siblines));
axis off
axis([0,1,0,1])
if length(siblines) == 1
   Y = .5;
elseif length(siblines) == 2
   Y = [ 0 .5];
else
   Y = linspace(0,.75,length(siblines))';
end
X=[0 .05 .1 .15];
ui=[0 0 0 0 0]'; bi=[0 0 0 0 0]';
for i=1:length(siblines)
  line(X,[Y(i) Y(i) Y(i) Y(i)],'linestyle',get(siblines(i),'linestyle'),...
                     'color',get(siblines(i),'color')  )
  ui(i) = uicontrol('Parent',leginp,...
			'style','edit',...
                        'string',[],...
			'units','normalized',...
			'position',[.35 (Y(i)+.1)/1.2 .3 .1*sfactor]);
  bi(i) = uicontrol('Style','checkbox','Units','Normalized',...
			'Position',[.28 (Y(i)+.1)/1.2 .05 .1*sfactor],...
			'Visible','on');
end
 examps=[];
sibs=get(gca,'children');
for i=1:length(sibs)
 if strcmp('line',get(sibs(i),'type'))
  examps=[examps,sibs(i)];
 end
end

 si2(1:length(examps))=fliplr(examps);
 mi(1) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .7 .25 .1*sfactor],...
			'String',T1,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(1)');
 li(1) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .7 .25 .1*sfactor],...		
			'String','Linestyle',...
			'Visible','on',...
                        'CallBack','ezlegend(8)');
 mi(2) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .5 .25 .1*sfactor],...
			'String',T2,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(2)');
 li(2) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .5 .25 .1*sfactor],...		
			'String','Color',...
			'Visible','on',...
                        'CallBack','ezlegend(9)');

 mi(3) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .3 .25 .1*sfactor],...
			'String',T3,...
			'Visible','on',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(3)');
 li(3) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .3 .25 .1*sfactor],...		
			'String','Markersize',...
			'Visible','on',...
                        'CallBack','ezlegend(10)');

 mi(4) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .1 .25 .1*sfactor],...
			'String',T4,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(4)');
 li(4) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .1 .25 .1*sfactor],...		
			'String','Linewidth',...
			'Visible','on',...
                        'CallBack','ezlegend(7)');


 uicontrol('Parent',leginp,...
			'style','pushbutton',...
			'string','Add Legend',...
			'units','normalized',...
			'position',[.4 .92 .2 .07*sfactor],...
			'callback','ezlegend(5)');
 uicontrol('Parent',leginp,...
			'style','text',...
			'string','Labels',...
			'units','normalized',...
			'position',[.4 ((max(Y)+.1)/1.2)+.1*sfactor .2 .07*sfactor],...
			'BackgroundColor',[ 0 0 0 ],... 
			'ForegroundColor',[ 0 1 0 ]);

uicontrol('Parent',leginp,...
			'style','pushbutton',...
			'string','Remove Legend',...
			'units','normalized',...
			'position',[.7 .92 .25 .07*sfactor],...
			'callback','ezlegend(6)');

 uicontrol('Parent',leginp,...
			'style','pushbutton',...
			'string','Close',...
			'units','normalized',...
			'position',[.2 .92 .15 .07*sfactor],...
			'callback','delete(gcf)');
 

mh=zeros(size(ui));mh(1:4)=mi;mh(5)=haold;
lh=zeros(size(ui));lh(1:4)=li;
set(leginp,'UserData',[si ui bi mh si2 lh]);

elseif command==1
	T1=['- ';'--';': ';'-.';'. ';'+ ';'* ';'o ';'x '];
	handles = get(gcf,'UserData');
        nlines=length(find(handles(:,1)));
        checked=zeros(nlines,1);
        for i=1:nlines
         checked(i)=get(handles(i,3),'Value');
        end
        for i=find(checked)
         set(handles(i,1),'LineStyle',T1(get(handles(1,4),'Value'),:))
         set(handles(i,5),'LineStyle',T1(get(handles(1,4),'Value'),:)) 
 	end
	set(handles(1,4),'Visible', 'off')
        set(handles(1,6),'Visible', 'on')

elseif command==2
	T2=['cyan   ';'magenta';'green  ';'red    ';'yellow ';...
        'blue   ';'black  ';'white  '];
	handles = get(gcf,'UserData');
        nlines=length(find(handles(:,1)));
        checked=zeros(nlines,1);
        for i=1:nlines
         checked(i)=get(handles(i,3),'Value');
        end
        for i=find(checked)
         set(handles(i,1),'Color',T2(get(handles(2,4),'Value'),:))
         set(handles(i,5),'Color',T2(get(handles(2,4),'Value'),:)) 
 	end
	set(handles(2,4),'Visible', 'off')
        set(handles(2,6),'Visible', 'on')

elseif command==3
	T3=['2 ';'4 ';'6 ';'8 ';'10';'12'];
	handles = get(gcf,'UserData');
        nlines=length(find(handles(:,1)));
        checked=zeros(nlines,1);
        for i=1:nlines
         checked(i)=get(handles(i,3),'Value');
        end
        for i=find(checked)
         set(handles(i,1),'MarkerSize',eval(T3(get(handles(3,4),'Value'),:)))
         set(handles(i,5),'MarkerSize',eval(T3(get(handles(3,4),'Value'),:))) 
 	end
        refresh
	set(handles(3,4),'Visible', 'off')
        set(handles(3,6),'Visible', 'on')

elseif command==4
	T4=['1';'2';'3';'4';'5';'6'];
	handles = get(gcf,'UserData');
        nlines=length(find(handles(:,1)));
        checked=zeros(nlines,1);
        for i=1:nlines
         checked(i)=get(handles(i,3),'Value');
        end
        for i=find(checked)
         set(handles(i,1),'LineWidth',eval(T4(get(handles(4,4),'Value'),:)))
         set(handles(i,5),'LineWidth',eval(T4(get(handles(4,4),'Value'),:))) 
 	end
        refresh
        set(handles(4,4),'Visible', 'off')
        set(handles(4,6),'Visible', 'on')

elseif command==5
   	handles = get(gcf,'UserData');
        nlines=length(find(handles(:,1)));
        S = str2mat(get(handles(1,2),'string'));
        for i=2:nlines
       	 S = str2mat(S,get(handles(i,2),'string'));
        end 
        indx=[];
         for i=1:nlines
          if (abs(deblank(S(i,:)))~=[])
              indx=[indx i];
          end
         end
          if indx ~= []
            figure(handles(5,4));
            legend(flipud(handles(indx,1)),flipud(S(indx,:)))
          end
elseif command == 6
         handles = get(gcf,'UserData');
	figure(handles(5,4));
        legend off
        refresh
elseif command == 7
	handles = get(gcf,'UserData');
        set(handles(4,6),'Visible', 'off')
        set(handles(4,4),'Visible', 'on')
elseif command == 8
	handles = get(gcf,'UserData');
        set(handles(1,6),'Visible', 'off')
        set(handles(1,4),'Visible', 'on')
elseif command == 9
	handles = get(gcf,'UserData');
        set(handles(2,6),'Visible', 'off')
        set(handles(2,4),'Visible', 'on')
elseif command == 10
	handles = get(gcf,'UserData');
        set(handles(3,6),'Visible', 'off')
        set(handles(3,4),'Visible', 'on')

end
