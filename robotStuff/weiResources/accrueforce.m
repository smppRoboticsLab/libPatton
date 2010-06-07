
subjnumber=input('enter the subject number: ');

pwd = ['D:\Patton_Shared_Data\SFD\sfd' num2str(subjnumber)]
tofile = 'C:\users\ywei\experiment\sfd\AcruedForce.txd';
fidw = fopen(tofile,'w');
fprintf(fidw,'// ***** Machine Learning force from subject %i *****\n', subjnumber); 

for i=1:3
  filename = [pwd '\F' num2str(i) '.txd'];
  
   if exist(filename)
     [h,d] = hdrload(filename);
     fprintf(fidw,['static F' num2str(i) '[2][28] = {{']);
    
     for j=1:29
       fprintf(fidw,'%8.4f,',d(j,1)); 
     end
       fprintf(fidw,'%8.4f },{',d(length(d),1));
     
     for j=1:29 
       fprintf(fidw,'%8.4f,',d(j,2)); 
     end
       fprintf(fidw,'%8.4f }};\n',d(length(d),2));
   end
    
end

fclose(fidw);
