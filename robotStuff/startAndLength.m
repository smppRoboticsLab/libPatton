%************** MATLAB "M" function  *************
% find the starting frame based on velocity threshold; adjust length if v is too short
% SYNTAX:     [St,len,speed]=startAndLength(v,maxLen,speedThresh);
% INPUTS:     v             n-by2 velocity vector
%             maxLen        maximum allowable, shortened if the v vector is shorter
%             speedThresh   threshold of v for detecting movement onset
% OUTPUTS:    St            index of row in v that start of movement is detected
%             len           trimmed length of v if v isshorter than maxLen
%             speed
% REVISIONS:  10-25-0 renamed performMeas.m
%             
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~~~~~~~~~~


function [St,len,speed]=startAndLength(v,maxLen,speedThresh);

if ~exist('speedThresh'), speedThresh=.1; end     % if not passed
if ~exist('maxLen'), maxLen=size(v,1); end        % if not passed

speed=sqrt(v(:,1).^2+v(:,2).^2);                  % speed calc
for St=4:length(v(:,1))                           % Loop for each v time sample
  if speed(St)>speedThresh, break; end;           % find where mvmt begins
end
if St+maxLen>length(v(:,1))-2,                    % if amount to eval exceeds maxLength
  len=length(v(:,1))-St-2;                        % reduce len (# frames to eval)
else
  len=maxLen;
end



