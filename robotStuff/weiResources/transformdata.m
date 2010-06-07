% Transform data on the target pc computer to the normal format 

data1=[];
data2=[];
new_data2=[];
new_data1=[];
 
disp('Choose Experimental Name:');
disp('   [1]. SFD ');
disp('   [2]. EA');
disp('   [3]. AHA');
disp('   [4]. SA');
disp('   [5]. BOTOX');
disp('   [6]. scrs');
expn = input('Chose from 1 - 6\n');
if isempty(expn)
    expn = input('Chose from 1 - 6');
end
if expn ==1
    exp_name = 'sfd';
    mtype = 'center out';
    strial = 55*0+1; 
elseif expn ==2
    exp_name = 'ea';
    mtype = 'center out';
    strial = 1;
elseif expn ==3
    exp_name = 'aha';
    mtype = 'center out';
    strial = 1;
elseif expn ==4
    exp_name = 'sa';
     mtype = 'random walk';
    strial = 1;
elseif expn ==5
    exp_name = 'BOTOX';
     mtype = 'center out';
    strial = 1;
elseif expn ==6
    exp_name = 'scrs';
     mtype = 'center out';
    strial = 1;
else
    disp('Your input is not accepted!!');
end

strial = 1;
datafile = [exp_name '.dat'];
%subj_num = input('Input subject number:  ','s');


 currentdir=pwd;
% newdestidir = ['C:\Patton_Shared_Data\' num2str(exp_name) '\' num2str(exp_name) num2str(subj_num)];
% if ~exist(newdestidir)
%    mkdir(newdestidir);
%    cd(newdestidir);
% else
%    datarep = input('Subject data exist. Do you want to replace the old data? [y/n] ','s');
%    if isempty(datarep) 
%        datarep = 'n'
%    end
%    if datarep == 'y'
%      cd(newdestidir);
%    else
%        break;
%    end
% end



%datafile = [expname '.dat'];
fid=fopen(datafile,'r');
 
disp('Saving data...');
datafilen2o(datafile,mtype, strial)

cd(currentdir);


