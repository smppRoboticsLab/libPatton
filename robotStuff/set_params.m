%______*** MATLAB "M" script (jim Patton) ***_______
% Sets up parameters for the simulation of a 2-joint link:
%
%                                                     phi2  `
%            o==>F                                 o==>F   `
%             \                                     \     `                
%             (m2)                                  (m2) `                      
%               \  q2                                 \ `               
%                o ` ` ` ` `                          o     
%               /                                    /           
%             (m1)                                 (m1)    phi1        
%             / q1                                 / 
%          __o___` ` ` ` ` `                    __o___` ` ` ` ` `  
%          \\\\\\\                              \\\\\\\                 
%
% VERSIONS:	  INITIATED 4/20/99 jim patton, spaned frm do_df2
%__________________________ BEGIN: ____________________________

fprintf(' ~ set_params.m script ~ ')

%__ MISC___
fclose all;                                 % close files that might be open
x=1;y=2;                                    % index to 1st & 2nd dimentions
torad=pi/180;                               % convert to radians
Gcounter=0;                                 % counts sim iterations sim_anim.m
verbose=1;                                  % true for questions
sep='-------------------------';
field_gain=zeros(2,2);                      % set basic field  to zero
forceNoise=0.01;                            % estimate ~ .1;
posNoise=0.001;                             % estimate ~ .001;
velNoise=0;                                 % ?
movmtDistance=.1;                           % nominal mvmt dist
speedThresh=.1;                             % min speed
cutoff=10;                                  % position filter cutoff
g = 0;                                      % gravity m/s/s. =0 for horiz. movement 
Hz=100;                                     % init to default

%___________________________________________
%-- GEOMETTRY & MASS DISTRIBUTION PARAMS: --
%___________________________________________

%__  parameters from the parameters file: __
% load values; if not tere, use defaults.
fprintf('Load from "parameters.txt"...\n')  %
body_mass=findInTxt(                    ... %
 'parameters.txt','body_mass=',0);          %
if isempty(body_mass)                       %
  fprintf(' param not found! Use default: ')%
  body_mass     = 77.2727 %=170/2.2;        % kg typical
end                                         %
body_height=findInTxt(                  ... %
 'parameters.txt','body_height=',0);        %
if isempty(body_height)                     %
  fprintf(' param not found! Use default: ')%
  body_height   = 1.78                      % m typical
end                                         %
uprArm_length=findInTxt(                ... %
 'parameters.txt','uprArm_length=',0);      %
if isempty(uprArm_length)                   %
  fprintf(' param not found! Use default: ')%
  uprArm_length = 0.186*body_height         % Winter, 1990 page 52
end                                         %
forArm_len=findInTxt(                   ... %
 'parameters.txt','forArm_len=',0);         %
if isempty(forArm_len)                      %
  fprintf(' param not found! Use default: ')%
  forArm_len    = 0.146*body_height         % Winter, 1990 page 52
end                                         %
half_hand_len=findInTxt(                ... %
 'parameters.txt','half_hand_len=',0);      %
if isempty(half_hand_len)                   %
  fprintf(' param not found! Use default: ')%
  half_hand_len =.108/2*body_height         % Winter, 1990 page 52
end                                         %
shoulderWidth=findInTxt(                ... %
 'parameters.txt','shoulderWidth=',0);      %
if isempty(shoulderWidth)                   %
   fprintf(' param not found! Use default:')%
   shoulderWidth=.258*body_height           %
end                                         %

Xshoulder2motor=findInTxt(              ... %
 'parameters.txt','Xshoulder2motor=',0);    %
if isempty(Xshoulder2motor)                 %
  fprintf(' param not found! Use default: ')%
  Xshoulder2motor=0                         %
end                                         %
Yshoulder2motor=findInTxt(              ... %
 'parameters.txt','Yshoulder2motor=',0);    %
if isempty(Yshoulder2motor)                 %
  fprintf(' param not found! Use default: ')%
  Yshoulder2motor=.85                       %
end                                         %

%__ parameters calulated from paramters: __
forArm_length = forArm_len+half_hand_len;   % add half of hand length
uprArm_mass   =.028*body_mass ;             % Winter, 1990 page 57
forArm_mass   =.022*body_mass ;             % Winter, 1990 page 57
uprArm_I=uprArm_mass*(uprArm_length*.322)^2;% Winter, 1990 page 57
forArm_I=forArm_mass*(forArm_length*.303)^2;% Winter, 1990 page 57
M = [uprArm_mass  uprArm_I;                 % mass matrix row=segment, 
     forArm_mass  forArm_I];                % col1=masses col2=inertias
L = [uprArm_length;                     ... % segment lengths (interjoint)
    forArm_length];                         % index to 1st dimention
R = [0.436*uprArm_length; ...               % distal joint to segment CM
     0.682*forArm_len];                     % (Winter, 1990 page 57)

%____ PASSIVE JOINT PROPERTIES ____
EPpas= [15 85]*pi/180;                      % passive stationary eq point (rad)
Kpas = 0*[1 1];                             % passive spring const (N*m/rad)
Bpas = 0*[1 1];                             % passive damping const (N*m/rad)

%___ ACTIVE FEEDBACK CONTROL PROPERTIES ___
%playwav('KB.wav'); pause(.5)               % play sound      
%fprintf(' \n NOTE: altered K abnd B..\n')
Kact =  [   15    6                         % control spring const. (N*m/rad)
            6   16  ];                      %
Bact =  [  2.3     0.9                      % control damp const. (N*m*sec/rad)
           0.9   2.4 ];                     %

%____ INTEGRATOR ____
tol       = 1e-6;                           % integrator tol for convergence
minstep   = 1e-5;                           % min integration step (sec)
maxstep   = 1e-2;                           % max integration step (sec) 

% setup of list of sim classes was here...
% setup of PERTURBING was here...
% setup of directions was here...
% setup of desired traj was here...    
% setup of intended traj was here...   

% ___ PLOTTING STUFF  ___
figure(1); clf; orient tall;                 % clear 
put_fig(1,.55,.03,.44,.9);                   % size window
set(gcf,'color',[1 1 .9]), 
figure(2); clf; orient tall;                 %  
put_fig(2,.08,.28,.35,.65); drawnow;         % 
set(gcf,'color',[1 1 .9]), 
%figure(3); clf; orient tall;                %  
%put_fig(3,.05,.41,.25,.53); drawnow;        % 
set(gcf,'color',[1 1 .9]), 
plotit=1;                                    % turn on plotting
graphicsParams=[NaN NaN .01];                % initialize params used for graphics

%__ Center of the workspace __
startRobot=[0 .45];                           % in robot coords
startPt=[-Xshoulder2motor Yshoulder2motor]... % convert to subject coords
       -startRobot;
     
wd=parse(cd,'\'); wd=wd(size(wd,1),:);        % working directory

fprintf(' ~ END set_params.m~ \n')