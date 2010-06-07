% Transform data on the target pc computer to the normal format 

data1=[];
data2=[];
new_data2=[];
new_data1=[];
f=xpctarget.ftp;
f.dir

fsys=xpctarget.fs;

exp_name = input('Input experiment name:  ','s');
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

[hh zeroforce1] = hdrload(['C:\users\ywei\experiment\' exp_name '\zeroforce.txd']);

new_data2=readxpcfile(data2);
ndata=new_data2.data;
for i=1:length(ndata)
    ndata(i,6) = ndata(i,6) - zeroforce1(1);
    ndata(i,7) = ndata(i,7) - zeroforce1(2);
end
fprintf(fid,'%8.4f \t %i \t %i \t %8.4f \t  %8.4f\t  %8.4f \t  %8.4f \t  %8.4f \t  %8.4f\n',ndata(2:length(ndata),1:9)');
fclose(fid);
dd=[];

if exp_name == 'aha' 
    mtype = 'center out';
    strial = 1;
elseif exp_name == 'sfd'
    mtype = 'center out';
    strial = 55;    
elseif exp_name == 'sa'
    mtype = 'random walk';
    strial = 1;
elseif exp_name == 'ea'
    mtype = 'center out';
    strial = 1;
end

 
%disp('Saving data...');
%datafilen2o(newdatafile,mtype, strial)


cd(currentdir);


