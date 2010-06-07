% survey:    asking questions
%************** MATLAB "M" SCRIPT ************
% a list of questions in a text file questions.txt results in answers.txt 
% INPUTS:     
% SYNTAX:     
% REVISIONS:  INITIATED by  by J. Patton 24-Jul-2008
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

function survey()

%% setup parameters
clc                                                   % Clear CommandWindow
barWidth=24;                                          % clickBar thinkness 
fontSize=16;
instruction='Click below where it best represents how much you agree:';
figure(1); clf; put_fig(1,.06,.25,.9,.6)

SurvDlg.ExpProtocolName='EnterExperimentProtocolName';%
SurvDlg.SubjectNum = { 0 'Subject number' [1 1000]};  %
% SurvDlg.Compile    = { {'0','{1}'} , ...            %
%                      'Recompile mex and rtw files'};%
disp(' Opening GUI Window for Paramaters...')         % 
dlgAns=StructDlg(SurvDlg,'Questionaire');             % dialogWindow-params
q=1;                                                  % initial question #
[Qs,data]=hdrload('questions.txt');
answers=['Answers for ' dlgAns.ExpProtocolName ...    % init
 num2str(dlgAns.SubjectNum) ' on ' whenis(clock)];    % 
fprintf(' Done. %d questions.',size(Qs,1));           %  



%% shuffle order of questions
fprintf('\n(shuffling the order)')
N=size(Qs,1);
[y,i]=sort(rand(N,1));
Qs=Qs(i,:)

%% big loop for questions answered
while (q<=N),
   ok=0;
  
%    while(~ok)
    figure(1); clf; 
    plot([0 1],[0 0],'linewidth',barWidth) % line for rating
    hold on
    axis off
    axis([0 1 -1 1])
    title({[],deblank(Qs(q,:))},'fontsize',fontSize+4,'fontweight','bold');
    h=textOnPlot(instruction,.5,.8); 
    set(h,'HorizontalAlignment','center','fontsize',fontSize);
    
    % back bar:
    plot([.699 1],-.797*[1 1],'k','linewidth',barWidth); % border
    plot([.7 1],-.8*[1 1],'g','linewidth',barWidth);
    h=text(.85,-.8,'go back 1 question'); 
    set(h,'HorizontalAlignment','center','VerticalAlignment','middle');
    
    % lablels for extremes:
    h=textOnPlot('strongly disagree',.05,.6); 
    set(h,'HorizontalAlignment','center','fontsize',fontSize);
    h=textOnPlot('strongly agree',.95,.6); 
    set(h,'HorizontalAlignment','center','fontsize',fontSize);
    
    % input and check for what was clicked
    [x,y] = ginput(1);
    if (y>-.1&&y<.1&&x>0&&x<1)
      plot([x+.005 x-.005],[0 0],'r','linewidth',barWidth)
      pause(2); clf, drawnow; pause(1); 
      currentAnswer=[deblank(Qs(q,:)) '= ' num2str(x)] %#ok<NOPTS>
      answers=str2mat(answers,currentAnswer);
      q=q+1;
    elseif (y>-.85&&y<-.75&&x>.7&&x<1)&&q>1
      clf
      axis off
      title({[],'Going Back 1 question... '},                ...
       'fontsize',fontSize,'fontweight','bold');
      q=q-1; 
      answers(q+1,:)=[]; % erase last time's selection 
    else
      clf
      axis off
      title({[],'Please click on the line. Try again. '},   ...
        'fontsize',fontSize,'fontweight','bold');
      pause(2); clf, drawnow; pause(1); 
    end
%    end

end

clf; axis off
title({[],' Done getting questions. Thanks! '},...
    'fontsize',fontSize,'fontweight','bold');

fprintf(' Done getting questions.')      % 
answers
AnswersFilename=['answers' dlgAns.ExpProtocolName ...    % 
         num2str(dlgAns.SubjectNum) '.txt'];
fprintf('\n... saving to %s ...',AnswersFilename);
mat2txt(AnswersFilename,answers,-9999);
fprintf('Done. \n');

pause(3)
close all

end % END function survey