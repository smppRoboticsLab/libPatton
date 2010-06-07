% PROCDATA: Transform data on the target pc computer to the normal format 
%% Matlab m function

function procdata(exp_name)

%% SETUP
data1=[];
data2=[];
new_data2=[];
new_data1=[];
f=xpctarget.ftp;
f.dir;
fsys=xpctarget.fs;
strial=1; % start trial for transformdata2oldFormat

%% get protocol information if not there
if ~exist('exp_name','var')
  disp('Choose Experimental Name:');
  disp('   [0]. scrs ');
  disp('   [1]. SFD ');
  disp('   [2]. EA');
  disp('   [3]. AHA');
  disp('   [4]. SA');
  disp('   [5]. CAL');
  expn = input('Chose from 0 - 5\n');
  if isempty(expn)
    expn = input('Chose from 0 - 5');
  end
  if     expn==0,  exp_name = 'scrs';
  elseif expn==1,  exp_name = 'sfd';  
  elseif expn==2,  exp_name = 'ea';   
  elseif expn==3,  exp_name = 'aha';
  elseif expn==4,  exp_name = 'sa';  
  elseif expn==5,  exp_name = 'cal';
  else   disp('Your input is not accepted!!'); end
end
if strcmp(lower(exp_name),'sa'), 
  mtype='random walk';
else
  mtype='center out';
end
datafile = [exp_name 'data.dat'];

%% setup a directory for data on host & transfer data to:
C=clock;
currentdir=pwd;
newdestidir=['D:\Patton_Shared_Data\' num2str(exp_name) '\' ...
  num2str(C(4)) '-' num2str(C(5)) '_' date];
mkdir(newdestidir); 
cd(newdestidir);
fput=xpctarget.ftp; 
fput.get(datafile); 

%% setup new output file
outputdatafile=[exp_name '.dat'];
newdatafile=[newdestidir '\' outputdatafile];
fid=fopen(newdatafile,'w');  % open txd output file for writing

%% read XPC file and output it to new text file
h=fsys.fopen(datafile);
data2=fsys.fread(h);
fsys.fclose(h);
new_data2=readxpcfile(data2); %% read XPC file
ndata=new_data2.data;           
fprintf(fid,...
  '%8.4f \t %i \t %i \t %8.4f \t  %8.4f\t  %8.4f \t  %8.4f \t  %8.4f \t  %8.4f\n'...
  ,ndata(2:length(ndata),1:9)');
fclose(fid);
dd=[];
transformdata2oldformat(exp_name);
cd(currentdir);


