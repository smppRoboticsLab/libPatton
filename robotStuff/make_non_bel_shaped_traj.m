% creates a non_bel_shaped velocity profile trajectory using a beta function
% Patton

t=0:.01:.7;                                               % time domain
v=betapdf(t,2,10);                                        % 

clf; plot(t,v,'.'); hold on                               % 

%integrate:
x(1)=0; for i=2:length(v),x(i)=x(i-1)+v(i)*deltat; end    % 

plot(t,x,'.');                                            % 


