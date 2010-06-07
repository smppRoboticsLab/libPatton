% This code is to transform the output from xPC to the old DOS format
% Inputs : data_*.txd
% Outputs: P1*_.dat
% Created by Yejun Wei, Nov 20, 2003
 
function procdata(exp_name)

ndatafile = [exp_name '.dat'];
% ndatafile = [pwd '\scrs.dat'];
 
 movementtype = 'center out';
 starttrial = 1;

 disp('loading data');
 [h,data]=hdrload(ndatafile);
 size(data)
 d=[];
 ctn=1;
 cdn=1;
 ict=2;
 icd=2;
 counttrial=[];
 cctrial=[];
  
 disp('completed load data');
 
 if movementtype == 'center out'
    while ict <= length(data) 
      if rem(ict,5000)==0
        ict
      end
    
      if data(ict,2) - data(ict-1,2) == 1
        counttrial(ctn,1) = ict;
        ctn = ctn+1;    
        ict = ict+30;
      else
        ict = ict +1;
      end
    end %end while loop
 
    for j=1:ctn-2
        k=counttrial(j,1)+30;
        while k<=counttrial(j+1,1)-1
          if data(k,3) - data(k-1,3) == 1
            counttrial(j,2) = k;
            k=counttrial(j+1,1);
          end
          k=k+1;
        end
    end
  elseif movementtype == 'random walk'
     
      while ict <= length(data) 
      if rem(ict,5000)==0
        ict
      end
    
      if data(ict,2) - data(ict-1,2) == 1
        counttrial(ctn,1) = ict; 
        if ctn>1
            counttrial(ctn-1,2) = ict-10;
        end
        ctn = ctn+1;    
        ict = ict+30;
      else
        ict = ict +1;
      end
    end %end while loop  
 end %end big if loop
 counttrial(length(counttrial),2) = length(data);
  
 for j=starttrial:length(counttrial) 
         
     vdata = [ ];
     if j<length(counttrial)
       vdata = add_vel(data, [counttrial(j,1) counttrial(j,2)]);
     else
       vdata = add_vel(data, [counttrial(j,1) length(data)-20]);
     end
    fid = fopen(['P1_' num2str(j-starttrial+1) '.DAT'],'w');
    fprintf(fid,'ManagedData \n');
    fprintf(fid,'RECORDS = %d \n',length(vdata));
    fprintf(fid,'{\n');
    fprintf(fid,'%8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f \t %8.4f\n',vdata(1:length(vdata),1:6)');    
    fprintf(fid,'-7777 %d 100 100 0.403588 0.408582 \n',data(counttrial(j,1)+10,2)-starttrial+1);
    fprintf(fid,'-7777 0 1 0 %d 0\n',length(vdata));
    fprintf(fid,'}\n');
    fclose(fid);
    
    if 1
    fid1 = fopen(['F_' num2str(j-starttrial+1) '.DAT'],'w');
    fprintf(fid1, 'X & Y forces for direction\n');
     fprintf(fid1,'0 \t 0\n');
    for kk = counttrial(j,1):counttrial(j,2)
        if abs(data(kk,8)) + abs(data(kk,9)) > 0.0005
         fprintf(fid1,'%8.4f \t %8.4f\n',data(kk,8), data(kk,9));
        end
    end
     fprintf(fid1,'0 \t 0\n');
    fclose(fid1);
    end
    
 end

 copyfile('F_360.DAT','F1.txd');
 copyfile('F_359.DAT','F2.txd');
 copyfile('F_358.DAT','F3.txd');
 
disp('done');
 
