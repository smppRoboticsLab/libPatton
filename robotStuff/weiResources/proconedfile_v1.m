% This code is to transform the output from xPC to the format
% of the DOS system. 
% Inputs : data_*.txd
% Outputs: P1*_.dat

% Created by Yejun Wei, Nov 20, 2003
 
exp_name = input('Input experiment name:  ','s'); 
if exp_name == 'aha'
    trialindex = 11; 
    xyindex = 3:4;
    forceindex = 8:9;
elseif exp_name == 'sfd'
    trialindex = 6; 
    xyindex = 4:5;
    forceindex = 8:9;
end
    
currentdir=pwd;
newdir = 'D:\Patton_Shared_Data\aha\aha1';
cd(newdir);
 ndatafile  = 'ahadata.dat';
 
 disp('loading data');
 [h,data]=hdrload(ndatafile);
 size(data)
 d=[];
 ci=1;
 counttrial=[];
 
 disp('completed load data');
 for i=3:length(data) 
    if rem(i,5000)==0
        i
    end
     if data(i,trialindex) - data(i-1,trialindex) == 1 && data(i-1,trialindex) - data(i-2,trialindex)==0
         counttrial(ci) = i; 
         ci = ci+1;        
     end
 end
 counttrial(ci) = length(data);
 
disp('completed mark data');
 for j=1:length(counttrial)-1
     vdat = [ ];
     vdata = add_vel(data, [counttrial(j) counttrial(j+1)],[trialindex xyindex forceindex]);
     
    fid = fopen(['P1_' num2str(j) '.DAT'],'w');
    fprintf(fid,'ManagedData \n');
    fprintf(fid,'RECORDS = %d \n',length(vdata));
    fprintf(fid,'{\n');
    fprintf(fid,'%8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f\n',vdata(1:length(vdata),1:6)');    
    fprintf(fid,'-7777 %d 200 100 0.403588 0.408582 \n',data(counttrial(j)+10,6));
    fprintf(fid,'-7777 0 1 0 %d 0\n',length(vdata));
    fprintf(fid,'}\n');
    fclose(fid);
 end
      
cd(currentdir);
disp('done');
 