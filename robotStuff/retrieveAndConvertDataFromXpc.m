% PROCDATA: Transform data on the target pc computer to the normal format 
%************** MATLAB "M" fcn ************
% SYNTAX:     procdata(exp_name) 
% REVISIONS:  INITIATED by wei
%             12-2006+ revised by patton
%~~~~~~~~~~~~~~~~~~~~~ Begin : ~~~~~~~~~~~~~~~

function retrieveAndConvertDataFromXpc(exp_name)

%% SETUP
fcnName='retrieveAndConvertDataFromXpc.m';
fprintf('\n~ %s ~',fcnName)
global ExpParams;                                   % experiment paramters
data1=[];
data2=[];
new_data2=[];
new_data1=[];
ProgramDir=cd;

%% connetc to XPC target
fprintf('\nCurrent Stuff on XPC HardDrive:\n')
f=xpctarget.ftp;
f.dir;
fsys=xpctarget.fs;
strial=1; % start trial for transformdata2oldFormat

%% get protocol information if not there
if ~exist('exp_name','var'), exp_name=getExpName(); end % this fcn is below
if strcmp(lower(exp_name),'sa'),  mtype='random walk';
else                              mtype='center out';
end
datafile=[exp_name 'data.dat'];

%% setup a directory for data on host & transfer data to:
C=clock;
f=pwd;
if exist('ExpDlg','var'),
  dirName=[ num2str(C(4)) '-' num2str(C(5)) '_' date '_' exp_name ExpDlg.SubjectNum];
else
  dirName=[ num2str(C(4)) '-' num2str(C(5)) '_' date];
end
DataDirectory=['D:\Patton_Shared_Data\' num2str(exp_name) '\' dirName];
mkdir(DataDirectory); 
cd(DataDirectory);
fput=xpctarget.ftp; 
fprintf('\nRetrieving %s on XPC target to %s..',datafile,DataDirectory);
fput.get(datafile); 
fprintf(' Done Retrieving XPC data.');

%% setup new output file
outputdatafile=[exp_name '.dat'];
newdatafile=[DataDirectory '\' outputdatafile];
fid=fopen(newdatafile,'w');  % open txd output file for writing

%% convert XPC binary to a new text file
fprintf('\nConverting XPC binary data to text file in %s..',newdatafile);
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
fprintf(' Done Converting to text. ');

XPC2DatamanFormat(exp_name); % XPC output text file to old DOS DatamanFormat

eval(['!copy ' ProgramDir '\desired.txd ' DataDirectory]);
eval(['!copy ' ProgramDir '\listtarget.m ' DataDirectory]);
cd(DataDirectory); cd

!copy *.* \\lobot1385\Patton_Shared_Data\SFD\latest

disp('Data is in:  '); cd
closefigs

fprintf('\n~ END of %s ~  \n',fcnName)

return



%% ========================== this fcn used above
function exp_name=getExpName();
 D.expName = { { 'scrs' '{SFD}' 'EA' 'AHA' 'SA' 'CAL' } };  %
 P=StructDlg(D,'Choose Experiment Name');                   % dialogWindow
 exp_name=P.expName;
return


% END OF DOCUMENT
