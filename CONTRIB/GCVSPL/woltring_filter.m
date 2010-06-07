%
% Woltring Filter 
% =============== 
%
% USAGE:     woltring_filter
%
%
% This MATLAB function selects EMG data from a raw data file,
% passes that data through Woltring's Generalized Cross-Variance
% (GCV) natural B-spline filter,  and writes the B-spline coefficients
% to an output ASCII file.
%
% Input data files are assumed to contain raw EMG data in the form:
%
% ANLi      num_emg_datapoints  junk junk junk junk
% emg_voltage_(1)    emg_voltage_(2)    emg_voltage_(3)   ...     ...   ...
% ...                   ...                 ...           ...     ...   ...
% ...                   ...                 ...           ...     ...   ...
% ...                   ...                 ...           ...     ...   ...
% ...                  emg_voltage_(num_emg_datapoints)
%
%     where i is the emg channel (e.g channel 0, 1, 2, 3, 4),
%           num_emg_datapoints is the total number of emg values 
%             (assumed to be sampled at regular frequency,  EMG_SAMPLING_RATE)
%           and emg_voltage_(j) is the emg_voltage value for the jth sampling time.
% 
% Tony Reina                                    Created: 4/1/1998
% The Neurosciences Institute,  San Diego,  CA
% Last Update: 4/7/1998 by GAR
%
% The documentation for the Woltring filter can be found in gcvspl.m (type: help gcvspl)

echo off;
clear all;

% GLOBAL VARIABLES
% ================
global  PI; PI = 3.141592654;
global  ORDER; ORDER = 5;               % Fifth-order (quintic) spline  
global  EMG_SAMPLING_RATE; EMG_SAMPLING_RATE = 100;     % 100 Hz = sampling frequency 
global  EMG_CUTOFF_FREQUENCY; EMG_CUTOFF_FREQUENCY = 10.0;      % EMG cutoff frequency for B-spline filter 
global  STARTING_TIME_EMG; STARTING_TIME_EMG = 0;               % Time in ms when EMG data was begun 

half_order = (ORDER + 1) / 2;           % Order of spline = 2*half_order - 1 
                                        % This is to ensure odd number for spline 
opt_mode = 1;                           % Mode for function GCVSPL (see gcvspl.m for explanation)
max_number_timepoints_allowed = 0;      %Initially set to zero. This will be updated based on how many
                                        %  datapoints are contained within the file.

% MAIN
% ====

        input_filename = '/usr/people/tony/c_programs/FRL031.001';
        output_filename = '/usr/people/tony/c_programs/junk.t';

        % Open files
        [in, msg] = fopen(input_filename, 'r');
        [out, msg] = fopen(output_filename, 'w');

        if (in == -1) | (out == -1)     %If in or out return -1 then file error has occurred
            error('Input and/or output files access error. Program terminated.');
        end
        
        % Parse raw file until EMG data is detected
        % EMG data begins with 'ANLi' where i indicates the analog channel (0-4) 
        word = fscanf(in, '%s', 1);
        while ((strncmp(word, 'ANL', 3) ~= 1) & (~feof(in)))
            word = fscanf(in, '%s', 1);
        end
        if feof(in)
            error_txt = sprintf('No EMG data found within file. Program terminated.\n');
            error_txt = strcat(error_txt, 'Type: help woltring_filter');
            error(error_txt);
        end
        
        i = 0;
        num_emg_channels = 0;

        while (strncmp(word, 'ANL', 3) == 1),
        % Do while word is ANL0, ANL1, ..., ANL4.
        % This will cycle through all of the EMG Analog data until
        % it reaches the next data set (SPK,  neuron spike data). 
  
                emg_channel = str2num(word(4));         % Last character of word is the emg channel 

                num_emg_points = fscanf(in, '%d', 1);
                if (num_emg_points > max_number_timepoints_allowed)
                    max_num_timepoints_allowed = num_emg_points;
                end
                line = fgets(in); clear line;                   % This just moves the file pointer down one line 
        
                timepoints(1:num_emg_points) = STARTING_TIME_EMG + 1000.0/EMG_SAMPLING_RATE * (0:(num_emg_points - 1)); 

                for j = 1:num_emg_points
                        emg(j,(emg_channel + 1)) = fscanf(in, '%lf', 1);
                end
        
                i = i + 1;
                num_emg_channels = num_emg_channels + 1;
                word = fscanf(in, '%s', 1);

        end

        weight_x(1:num_emg_points) = 1.0;
        weight_y(1:num_emg_channels) = 1.0;
        
        opt_val = (EMG_SAMPLING_RATE/1000.0)/(2.0*PI*EMG_CUTOFF_FREQUENCY / 1000.0 / ...
                ((sqrt(2.0) - 1)^(0.5 / half_order)))^  (2.0*half_order);

        [coefficients, work, error] = gcvspl(timepoints, ...
            emg, ...
            max_num_timepoints_allowed, ...
            weight_x,  ...
            weight_y, ...
            half_order, ...
            num_emg_points,  ... 
            num_emg_channels, ...
            opt_mode, ...
            opt_val, ...
            max_num_timepoints_allowed);
             
        if (error)

                disp(' '); disp(' ');
                disp(sprintf('Error #%1.0f occurred within GCVSPL.', double(error)));
                disp('Error parameters:');
                disp('=================');
                disp('Error = 0;  Normal exit.');
                disp('Error = 1;  Half-order <= 0   OR   Number of points < (2 * Half-order)');
                disp('Error = 2;  Knot sequence is not strictly increasing or some weight factor is not positive.');
                disp('Error = 3;  Wrong mode parameter or value.');
                disp(' '); disp(' ');           

        else

                for i = 1:num_emg_channels

                        fprintf(out, 'ANL%d\n',i-1);
                        k = 0;

                        for j = 1:num_emg_points

                                fprintf(out,'%f  ',coefficients(j,i));
                                k = k+1;
                                if k > 13
                                        fprintf(out, '\n');
                                        k = 0;
                                end
                        end
                        fprintf(out, '\n');
                end

