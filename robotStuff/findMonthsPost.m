%************** MATLAB "M" fcn ************
% read paramters.txt and find months post stroke
% SYNTAX:     MonthsPost=findMonthsPost()
%               OR
%             MonthsPost=findMonthsPost('day-MON-year')
% REVISIONS:  21-May-2001 (patton) INITIATED
%             04-Dec-2006 (patton) modified for date as input argument
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

function MonthsPost=findMonthsPost(dayMoYr)
fprintf('\n~ findMonthsPost.m function ~')

%__SETUP__
if ~exist('dayMoYr'),
  dayMoYr=findInTxt('parameters.txt','Pathology date=','s');
end
DV=datevec(now-datenum(dayMoYr));
MonthsPost=DV(1)*12+DV(2);