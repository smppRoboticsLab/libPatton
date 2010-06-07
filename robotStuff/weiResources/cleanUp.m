% This file is to clean files on the xpc target computer. 
% Before cleaning the file, a temporary copies of the file is saved in the
% directory D:\Patton_Shared_Data\temp_files
% created by Yejun Wei
% July 31, 2006

f=xpctarget.ftp; 
existFiles = f.dir;
 
expName = input('Enter name of the experiment to be cleaned [EA][SFD][AHA][SCRS]: ','s');
datafile = [expName 'data.dat'];

fsys=xpctarget.fs; 

f.get(datafile);
% copyfile(datafile,'D:\Patton_Shared_Data\temp_files');

fsys.removefile([expName 'data.dat']); 
    