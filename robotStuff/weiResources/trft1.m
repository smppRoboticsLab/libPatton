% This code is to transform the output from xPC to the format
% of the DOS system. 
% Inputs : data_*.txd
% Outputs: P1*_.dat

% Created by Yejun Wei, Nov 20, 2003
clear all;

currentdir = pwd;
cd(currentdir);
 ci =1; 
 
 h=[];
 data=[];
 cd('sfd1');
 
 file = 'ahadata.txd';
 
 disp('loading data');
 [h,data]=hdrload(file);
 
 disp('completed load data');
 for i=2:length(data) 
    if rem(i,5000)==0
        i
    end
     if data(i,7)==1 && data(i-1,7)==2
         ci=1;
         d=[];
     end
     
     if data(i,7) == 1
        d(ci,1:2) = data(i,4:5);
        d(ci,3:4) = data(i,8:9);
        ci = ci+1;
     end
     
      if (data(i,7)==2 && data(i-1,7)==1 && data(i,6)>54 ) || i == length(data)
          fid = fopen(['P1_' num2str(data(i,6)-54) '.DAT'],'w');
          fprintf(fid,'ManagedData \n');
          fprintf(fid,'RECORDS = %d \n',ci+1);
          fprintf(fid,'{\n');
          fprintf(fid,'%8.4f \t %8.4f \t 0 \t 0 \t %8.4f \t %8.4f\n',d(5:length(d)-5,1:4)');    
          fprintf(fid,'-7777 %d 200 100 0.403588 0.408582 \n', data(i-5,6)-54);
          fprintf(fid,'-7777 0 1 0 %d 0\n',ci-1);
          fprintf(fid,'}\n');
          fclose(fid);
      end
     
 end
     
 disp('done');
 
%  
%          
%          pfilename = ['P1_' num2str(data(mlist(i,1)+50,6)) '.DAT'];
%    
%          fid = fopen(pfilename,'w');
%          fprintf(fid,'ManagedData \n');
%          fprintf(fid,'RECORDS = %d \n',mlist(i,2)-mlist(i,1)+1);
%          fprintf(fid,'{\n');
%          fprintf(fid,'%6.4f\t  %6.4f\t %6.4f\t  %6.4f\t 0\t 0\n',sdata');
%          fprintf(fid,'-7777 %d 200 100 0.403588 0.408582 \n',data(mlist(i,1),6));
%          fprintf(fid,'-7777 0 1 0 %d 0\n',mlist(i,2)-mlist(i,1));
%          fprintf(fid,'}\n');
%          fclose(fid);
%  
   
 