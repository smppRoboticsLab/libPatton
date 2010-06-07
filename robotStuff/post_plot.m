%______*** MATLAB "M" file (jim Patton) ***_______
% Plots results of simulation
% CALLED BY: do_df2.m 
% VERSIONS:	  INITIATED 4/14/99 patton. spun from do_df2.m code
%__________________________ BEGIN: ____________________________

fprintf('\n~ post_plot ~');
fprintf('  Plotting.. ');

%____ PLOT angle TIME HISTORIES _____
subplot(5,2,5);                             % angles
hold on
h_ang2=plot(                             ...%
 time,posvelacc(:,1)/torad,'r'           ...%
,time,posvelacc(:,2)/torad,'b');            %
ax=axis; axis([0 tf ax(3) ax(4)]);          % zoom/scale x axis
set(gca,'fontsize',fsz)                     %
legend([h_ang1;h_ang2],                 ... %
  'q1 intended','q2 intended',          ... % put legend, etc.on plot
  'q1 actual','q2 actual',0);              %
title('Angle time records','fontsize',fsz); %
ylabel('degrees','fontsize',fsz);           %

%____ PLOT torque TIME HISTORIES _____
subplot(5,2,7);                             % torques
hold on
h_torque2=plot(                         ... % plot feedforward,
 time,Cfb(:,1),'m',                     ... %  feedback
 time,Cfb(:,2),'c',                     ... %  and total torqes
 time,C(:,1),'r',                       ... %  vs. time
 time,C(:,2),'b'   );                       % 
ax=axis; axis([0 tf ax(3) ax(4)]) ;         % zoom/scale x axis
set(gca,'fontsize',fsz)
legend([h_torque1;h_torque2],           ... %
       'Cff_1',                ... % put legend, etc.on plot
       'Cff_2',                ... %
       'Cfb_1',                   ... %
       'Cfb_2',                   ... % 
       'C_1',                      ... % 
       'C_2', 0);                  ... % put in best place in window      
title('Torque time records','fontsize',fsz);%
ylabel('N*m','fontsize',fsz);               %

%____ PLOT force TIME HISTORIES _____
subplot(5,2,9);                             % torques
hold on
h_force2=plot(time,force(:,1),'r',     ... % plot expected
              time,force(:,2),'b');        %  forces vs. time
ax=axis; axis([0 tf ax(3) ax(4)]) ;         % zoom/scale x axis
set(gca,'fontsize',fsz)
title('Endpoint force time records',    ... %
  'fontsize',fsz);%
xlabel('secs','fontsize',fsz); 
ylabel('N*m','fontsize',fsz);               %
legend([h_force1;h_force2],             ... %
       'Expected_x',                    ... % put legend, etc.on plot
       'Expected_y',                    ... %
       'Actual_x',                      ... %
       'Actual_y',                      ... % 
       0);                              ... %       

%__ PLOT FORCES on actual trajectory: __
subplot(3,2,6);                             % angles
%figure(3);
hold on
qph(2)=plot(rho(:,1),rho(:,2),'ko'    ...
  ,'markersize',5);
qph(3)=plot(rhoD(:,2),            ...
  rhoD(:,3),'r^'        ...
  ,'markersize',5);
k=0;                                        % init couter
quiver([rho(:,1); 0],[rho(:,2); .28],  ... % plot arrows 
       [force(:,1); 10],[force(:,2); 0],'k');
text(0,.28,'10 N',                    ...
    'VerticalAlignment','bottom')
axis equal; 
title('Trajectory & Forces','fontsize',fsz);
set(gca,'fontsize',fsz)
legend(qph, 'expected',                 ... % put legend, etc.on plot
            'actual',                   ... %
            'desired',0);  
figure(1);

%___ PLOT ANIMATION ___
subplot(3,1,1); post_anim;                  % ANIMATion

suptitle(['Trial ' num2str(trial)        ... % Big title on top
         ' simulation ' whenis(clock)]);

fprintf('DONE plotting. \n: ');
return

