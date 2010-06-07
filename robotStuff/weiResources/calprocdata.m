% Transform data on the target pc computer to the normal format 

data1=[];
data2=[];
new_data2=[];
new_data1=[];
f=xpctarget.ftp;
f.dir

ywei;
fsys=xpctarget.fs;

disp('Choose Experimental Name:');
disp('   [1]. SFD ');
disp('   [2]. EA');
disp('   [3]. AHA');
disp('   [4]. SA');
disp('   [5]. CAL');
expn = input('Chose from 1 - 5\n');
if isempty(expn)
    expn = input('Chose from 1 - 5');
end
if expn ==1
    exp_name = 'sfd';
elseif expn ==2
    exp_name = 'ea';
elseif expn ==3
    exp_name = 'aha';
elseif expn ==4
    exp_name = 'sa';
elseif expn ==5
    exp_name = 'cal';
else
    disp('Your input is not accepted!!');
end

datafile = [exp_name 'data.dat'];

C=clock;
currentdir=pwd;
newdestidir = ['D:\Patton_Shared_Data\' num2str(exp_name) '\' num2str(C(4)) '-' num2str(C(5)) '-' date];
mkdir(newdestidir);
cd(newdestidir);
fput=xpctarget.ftp;
fput.get(datafile); 

outputdatafile = [exp_name '.dat'];
newdatafile = [newdestidir '\' outputdatafile];
fid=fopen(newdatafile,'w');

h=fsys.fopen(datafile);
data2=fsys.fread(h);
fsys.fclose(h);

 
new_data2=readxpcfile(data2);
ndata=new_data2.data;
 
fprintf(fid,'%8.4f \t %8.4f\t  %8.4f \t  %8.4f \t  %8.4f \t  %8.4f\n',ndata(2:length(ndata),1:6)');
fclose(fid);
dd=[];


if expn==1
    mtype = 'center out';
    strial = 55;
elseif expn == 2
    mtype = 'center out';
    strial = 1;    
elseif expn == 3
    mtype = 'center out';
    strial = 1;
elseif expn == 4
   mtype = 'random walk';
   strial = 1;
 elseif expn == 5
    mtype = 'center out';
    strial = 1;  
end
 
cd(currentdir);


