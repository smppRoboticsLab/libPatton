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
if siblines == []
 disp('No valid data for current figure.')
 disp('Plot data first.')
 return
end

%
axold=gca;
haold=gcf;
T1=[' - ';' --';' : ';' -.';' . ';' + ';' * ';' o ';' x '];
T2=['cyan   ';'magenta';'green  ';'red    ';'yellow ';...
      'blue   ';'black  ';'white  '];
T3=['SMALL';'Small';'small';'large';'Large';'LARGE'];
T4=['THIN';'Thin';'thin';'fat ';'Fat ';'FAT '];
T5=['Avant Garde           ';...
    'Bookman               ';...
    'Courier               ';...
    'Helvetica             ';...
    'Helvetica Narrow      ';...
    'New Century Schoolbook';...
    'Palatino              ';...
    'Symbol                ';...
    'Times                 ';...
    'Zapf Chancery         ';...
    'Zapf Dingbats         '];
T6=['10';'12';'16';'20';'24';'30'];

si=zeros(8,1);si2=si;
si(1:length(siblines))=siblines;
leginp=figure('Color','k','NumberTitle','off','Name',...
	'EZ LEGEND',...
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
ui=zeros(8,1); bi=zeros(8,1);
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
			'Position',[.7 .8 .25 .1*sfactor],...
			'String',T1,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(1)');
 li(1) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .8 .25 .1*sfactor],...		
			'String','Linestyle',...
			'Visible','on',...
                        'CallBack','ezlegend(8)');
 mi(2) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .65 .25 .1*sfactor],...
			'String',T2,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(2)');
 li(2) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .65 .25 .1*sfactor],...		
			'String','Color',...
			'Visible','on',...
                        'CallBack','ezlegend(9)');

 mi(3) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .5 .25 .1*sfactor],...
			'String',T3,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(3)');
 li(3) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .5 .25 .1*sfactor],...		
			'String','Markersize',...
			'Visible','on',...
                        'CallBack','ezlegend(10)');

 mi(4) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .35 .25 .1*sfactor],...
			'String',T4,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(4)');
 li(4) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .35 .25 .1*sfactor],...		
			'String','Linewidth',...
			'Visible','on',...
                        'CallBack','ezlegend(7)');
 % find current fontname
   for i = 1:size(T5,1)
    if findstr(T5(i,:),get(axold,'FontName'))
     strrow = i;
    end
   end
   if strrow == 5 & strcmp(deblank(get(axold,'FontName')),deblank(T5(4,:)))
      strrow = 4;
   elseif strrow == 10 & strcmp(deblank(get(axold,'FontName')),deblank(T5(9,:)))
      strrow = 9;
   end
    
 mi(5) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .2 .25 .1*sfactor],...
			'String',T5,...
			'Value',strrow,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(15)');
 li(5) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .2 .25 .1*sfactor],...		
			'String','FontName',...
			'Visible','on',...
                        'CallBack','ezlegend(25)');
 mi(6) = uicontrol('Style','Popup','Units','Normalized',...
			'Position',[.7 .05 .25 .1*sfactor],...
			'String',T6,...
			'Value',2,...
			'Visible','off',...
                        'HorizontalAlignment', 'left',...
			'CallBack','ezlegend(16)');
 li(6) = uicontrol('Style','pushbutton','Units','Normalized',...
			'Position',[.7 .05 .25 .1*sfactor],...		
			'String','FontSize',...
			'Visible','on',...
                        'CallBack','ezlegend(26)');


 uicontrol('Parent',leginp,...
			'style','pushbutton',...
			'string','Add Legend',...
			'units','normalized',...
			'position',[.22 .88 .2 .1*sfactor],...
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
			'position',[.44 .88 .25 .1*sfactor],...
			'callback','ezlegend(6)');

 uicontrol('Parent',leginp,...
			'style','pushbutton',...
			'string','Close',...
			'units','normalized',...
			'position',[.05 .88 .15 .1*sfactor],...
			'callback','delete(gcf)');
 

mh=zeros(size(ui));mh(1:6)=mi;mh(7)=haold;mh(8)=axold;
lh=zeros(size(ui));lh(1:6)=li;
set(leginp,'UserData',[si ui bi mh si2 lh]);
elseif command==1
	T1=[' - ';' --';' : ';' -.';' . ';' + ';' * ';' o ';' x '];
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
         T5=['Avant Garde           ';...
    'Bookman               ';...
    'Courier               ';...
    'Helvetica             ';...
    'Helvetica Narrow      ';...
    'New Century Schoolbook';...
    'Palatino              ';...
    'Symbol                ';...
    'Times                 ';...
    'Zapf Chancery         ';...
    'Zapf Dingbats         '];
	T6=['10';'12';'16';'20';'24';'30'];
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
            figure(handles(7,4));
            oldfont=get(handles(8,4),'Fontname');
            oldsize=get(handles(8,4),'FontSize');
            set(handles(8,4),'FontName',deblank(T5(get(handles(5,4),'Value'),:)))
            set(handles(8,4),'FontSize',eval(T6(get(handles(6,4),'Value'),:)))
            legend(flipud(handles(indx,1)),flipud(S(indx,:)))
	    set(handles(8,4),'FontName',oldfont);
            set(handles(8,4),'FontSize',oldsize);
          end
elseif command == 6
         handles = get(gcf,'UserData');
	figure(handles(7,4));
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
elseif command == 15
 	handles = get(gcf,'UserData');
        set(handles(5,4),'Visible', 'off')
        set(handles(5,6),'Visible', 'on')
elseif command == 16
 	handles = get(gcf,'UserData');
        set(handles(6,4),'Visible', 'off')
        set(handles(6,6),'Visible', 'on')

elseif command == 25
	handles = get(gcf,'UserData');
        set(handles(5,6),'Visible', 'off')
        set(handles(5,4),'Visible', 'on')
elseif command == 26
	handles = get(gcf,'UserData');
        set(handles(6,6),'Visible', 'off')
        set(handles(6,4),'Visible', 'on')



end
