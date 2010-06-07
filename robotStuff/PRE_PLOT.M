%______*** MATLAB "M" file (jim Patton) ***_______
% Sets and starts Plots for simulation
% CALLED BY: do_df2.m 
% VERSIONS:	  INITIATED 4/14/99 patton. spun from do_df2.m code
%__________________________ BEGIN: ____________________________

fprintf('\n~ pre_plot.m  m-script  ~');

fprintf(' Setting up plot windows.. ');


% __ SETUP PLOT WINDOW __  
fsz=8;                                      % font size for plot text
figure(1); clf

%____ plot anim environment & field ____
subplot(3,1,1); 
if strcmp(field_type,'rc'),
  plotFieldInfluence;                       % plot circle of influnece of RCB
end
set_anim(rhoI);                             % plot arm w/intended TRAJ
set(gca,'fontsize',fsz)
plot(rhoD(:,2),rhoD(:,3),'r:','markersize',2);             % desired tracing
%plotbox(startPoint(1),startPoint(2),.01,'g',0);
ellipse(-.2,0,.2,.2/3,0,20,[.8 .8 .9]);     % body
ellipse(-.2,0,.2/4,.2/3,0,20,'k');          % head 
plot(-.2,.2/3,'^');                         % nose triangle
plot(0,0,'o');                              % shoulder joint
ax=axis; 
text(ax(1),ax(4)                        ...
    ,[' trial ' num2str(trial)]         ...
    ,'VerticalAlignment','bottom'       ...
    ,'FontWeight','bold'    )               %
plot([.35 .45],[-.1 -.1],'k');
text(.4,-.1,'0.1 m',                    ...
  'VerticalAlignment','bottom',         ...
  'HorizontalAlignment','center')
axis off

%____ PLOT angle TIME HISTORIES _____
subplot(5,2,5);                             % angles
h_ang1=plot(                             ...%
 qI(:,1),qI(:,2)/torad,'r:'              ...% plot intended and actual 
,qI(:,1),qI(:,3)/torad,'b:'              ...%  states vs. time
 );
set(gca,'fontsize',fsz)                     %
set(gca,'XTickLabel',[]);
title('intended Angle time records',    ... %
  'fontsize',fsz); %
ylabel('degrees','fontsize',fsz);           %
ax=axis;
text(ax(1),ax(4)+ax(4)/3-ax(3)/3,         ...
      'Time Records:','fontweight','bold')

%____ PLOT torque TIME HISTORIES _____
subplot(5,2,7);                             % torques
h_torque1=plot(t1,Cff(:,2),'r:',        ... % plot template and actual 
               t1,Cff(:,3),'b:');           %  torqes vs. time
set(gca,'fontsize',fsz)
set(gca,'XTickLabel',[]);
title('Feedforward Torque time records',... %
  'fontsize',fsz);%
ylabel('N*m','fontsize',fsz);               %

%____ PLOT expected force TIME HISTORIES _____
subplot(5,2,9);                             % torques
h_force1=plot(t1,Fexpected(:,1),'r:',   ... % plot expected
              t1,Fexpected(:,2),'b:');      %  forces vs. time
set(gca,'fontsize',fsz)
title('Expected endpoint force',        ... %
  'fontsize',fsz);%
xlabel('sec','fontsize',fsz); 
ylabel('N','fontsize',fsz);                 %

%____ plot field ____
subplot(3,2,4); set(gca,'fontsize',fsz);    %
%title(sim_list{sim_type});   
field_plot(fsz);

%__ PLOT FIELD on intended trajectory: __
subplot(3,2,6); 
%figure(3); clf
qph=plot(rhoI(:,2),            ... % Initialize a plot handle
         rhoI(:,3),'b.');          %  to be used later in legend
hold on;
set(gca,'fontsize',fsz);
axis equal; 
title('Expected field forces on intended traj.'...
  ,'fontsize',fsz);
xlabel('x (meters)','fontsize',fsz);
ylabel('y (meters)','fontsize',fsz);
%switch sim_type
%case 1
%  fprintf(' (no forces) ')
%otherwise
  quiver([rhoI(:,2); 0],         ...% plot arrows 
       [rhoI(:,3); .31],              ...%  
       [Fexpected(:,1); 10],                 ...%  
       [Fexpected(:,2); 0],'b');    
     text(0,.31,'10 N',                    ...
    'VerticalAlignment','bottom')
%end
xlabel('x (meters)','fontsize',fsz);
ylabel('y (meters)','fontsize',fsz);
plot([-.05 .05],[.25 .25],'k');
text(0,.25,'0.1 m',                    ...
  'VerticalAlignment','bottom')
axis off

figure(1), subplot(3,1,1);


fprintf(' DONE. \n');

