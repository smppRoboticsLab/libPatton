% ************** MATLAB "M" function  (jim Patton) *************
% Makes Plots for checking the time records in a DIO file (block of data)
% SYNTAX:	status=plot_DIO(fname,RECS,ps_or_not,print_or_not)
% INPUTS:	fname          filename to load data from
%              RECS           record N-by-2 CELL ARRAY, where N = #figs/trial, &
%                             1st column: list of records to plot in each fig
%                             2nd column: title associated with that fig 
%                             (see matlab manual on cell arrays)
%              ps_or_not      ='y' for generating an eps post script file
%              print_or_not   ='y' for directly printing
% OUTPUTS:	plot window, &
%		status		=0 if all went well
% CALLS:	dio2mat, dio_rec
% REVISONS:	Initiated 6/8/98 by patton
% NOTES:       * For information on DATAIO (DIO) FORMAT, see Datio_format.doc
%              * This only works for matlab 5 or better
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~

function status=plot_DIO(fname,RECS,ps_or_not,print_or_not)

% ___ SETUP ___
global DEBUGIT                                       % nonzero=debugging
if ~exist('ps_or_not'), ps_or_not='n'; end;          % set default if no entry
if ~exist('print_or_not'), print_or_not='n'; end;    % set default if no entry 
prog_name='plot_DIO.m';                              % this program's name
fprintf('\n~ %s ~ ', prog_name);                     % message
figure(1); clf; put_fig(1,.45,.35,.53,.55);          % fig left up width height 
orient landscape;
fprintf('\nProcessing "%s" ',fname);                 % message
status=0;                                            % start with OK status
verbose=0;                                           % nonzero for messages
if ~exist('RECS')|isempty(RECS),                       % if not there or empty
  fprintf(' Assuming printing protocol for SCD/BOS.')% message
  RECS={[101 102 103 104 105 106],    'forceplate';  % cell array of datacodes,
        [201],                        'load cell';   % each cell represents a 
        [1011:10:1131],               'markers x';   % plot window, & is a vect
        [1012:10:1132],               'markers y';   % of which datacodes to put
        [1013:10:1133],               'markers z';   % on the figure. This 
        [7 8],                        'axles'     }; % default is for .SCD files  
end %END if ~exist....
Nfigs=length(RECS);
C='brgcmkbrgcmkbrgcmkbrgcmkbrgcmkbrgcmk';            % colors

% ___ LOAD ___
fprintf(' Loading %s... ', fname);                   % message
[h,d,Ntrials]=dio2mat([fname],1);                    %
if h==-1,                                            % if cant read
  status=1;                                          % status to "error"
  fprintf('\n cant read %s. Aborting. \n',fname);    % message
  return;                                            % abort if cant read
end                                                  % end if cant read
fprintf(' DONE. ');                                  % message
[frames,cols]=size(d);                               %
freq=h(12,1);                                        % sampling freq
t=0:1/freq:frames/freq-.0001; t=t';                  % MAKE TIME VECTOR
t_end=t(length(t));                                  %
fprintf('%d trials (%d frames=%fsec)',           ... %
 Ntrials,frames,t(length(t)));                       %

% ___ LOOP FOR ALL THINGS ___
fprintf('\nPLOTTING...');                            % message
for trial=1:Ntrials                                  % loop for ea. trial
  [td,th]=dio_rec(d,h,3,trial,~verbose);             % extract trial data 
  for fig=1:Nfigs                                    % loop for ea. figure
    fprintf('.');                                    % message 
    recs=RECS{fig,1};                                % get list of figure's recs
    name=RECS{fig,2};                                % get figure's name
    Nrecs=length(recs);                              % number of recs on list
    subplot(Nfigs,Ntrials,(fig-1)*Ntrials+trial)     % subplot
    for rec=1:Nrecs                                  % loop for each rec
      [D,H]=dio_rec(td,th,2,recs(rec),~verbose);     % get data
      plot(t,D,C(rec)); hold on;                     % plot it
    end %END for rec
    title(name,'fontsize',5);
    if fig==1, 
      title(['trial ' num2str(trial) ' ' name],  ...
       'fontsize',5); 
    end
    set(gca,'fontsize',5);
  end %END for fig
  drawnow;
end %END for trial
fprintf(' DONE. ');                                  % message

suptitle(['Time record display for: ' fname])

% ___ PRINT/SAVE ___
if ps_or_not=='y',
  fprintf('\nMaking eps file...'); pause(.01);        % message
  eval(['print -depsc2 ' fname '.eps']);
  fprintf(' FIGURE STORED in %s.eps', fname);         % message
end
if print_or_not=='y',
  fprintf(' Printing...');pause(.01);                % message
  print -dwin
end
fprintf(' DONE. ');                                  % message

fprintf('\n~ END %s ~ \n\n', prog_name);             % message
return;

