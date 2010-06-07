%___________________*** MATLAB "M" script (jim Patton) ***____________________
% Sets up parameters for the copycat basis functions for 2-joint link & controller:
% VERSIONS:   INITIATED 11/17/99 by patton, split off from set_params.m
%             5/16/0 made it a function
%             5/30/0 setupCopycat3: add input of CCB
%__________________________________ BEGIN: ____________________________________

function CCB=setupCopycat3(CCB,M,L,R,K,B,X,Y,CCwings,spreadScale)

% ___ SETUP ___
fprintf(' ~ setupCopycat3.m  ~ ')
if isempty(CCB); start=1; else start=length(CCB)+1; end

% ___ INIT COPYCAT BASIS (CCB) with Best guess ___
for i=start:start+36                                              % init. best guess into all CCB's  
    CCB(i).M=M;    CCB(i).L=L;   CCB(i).R=R;   
    CCB(i).K=K;    CCB(i).B=B; 
    CCB(i).X=X;    CCB(i).Y=Y;
    CCB(i).cc=0;
end

%__ Now vary each param in 1 direction __
CCB(start+1).M(1,1)=M(1,1)*(1+CCwings.massSpread*spreadScale);            
CCB(start+2).M(1,1)=M(1,1)*(1-CCwings.massSpread*spreadScale);     
CCB(start+3).M(1,2)=M(1,2)*(1+CCwings.massSpread*spreadScale);
CCB(start+4).M(1,2)=M(1,2)*(1-CCwings.massSpread*spreadScale);
CCB(start+5).M(2,1)=M(2,1)*(1+CCwings.massSpread*spreadScale);
CCB(start+6).M(2,1)=M(2,1)*(1-CCwings.massSpread*spreadScale);
CCB(start+7).M(2,2)=M(2,2)*(1+CCwings.massSpread*spreadScale);
CCB(start+8).M(2,2)=M(2,2)*(1-CCwings.massSpread*spreadScale);
CCB(start+9).R(1) =R(1)*(1+CCwings.geometrySpread/2*spreadScale);
CCB(start+10).R(1)=R(1)*(1-CCwings.geometrySpread/2*spreadScale);
CCB(start+11).R(2)=R(2)*(1+CCwings.geometrySpread/2*spreadScale);
CCB(start+12).R(2)=R(2)*(1-CCwings.geometrySpread/2*spreadScale);
CCB(start+13).L(1)=L(1)*(1+CCwings.geometrySpread*spreadScale);
CCB(start+14).L(1)=L(1)*(1-CCwings.geometrySpread*spreadScale);
CCB(start+15).L(2)=L(2)*(1+CCwings.geometrySpread*spreadScale);
CCB(start+16).L(2)=L(2)*(1-CCwings.geometrySpread*spreadScale);
CCB(start+17).B(1,1)=B(1,1)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+18).B(1,1)=B(1,1)*(1-CCwings.impedanceSpread*spreadScale);
CCB(start+19).B(2,2)=B(2,2)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+20).B(2,2)=B(2,2)*(1-CCwings.impedanceSpread*spreadScale);
CCB(start+21).B(2,1)=B(2,1)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+21).B(1,2)=B(1,2)*(1+CCwings.impedanceSpread*spreadScale); % SYMMETRIC; KEEP SAME
CCB(start+22).B(2,1)=B(2,1)*(1-CCwings.impedanceSpread*spreadScale);        
CCB(start+22).B(1,2)=B(1,2)*(1-CCwings.impedanceSpread*spreadScale); % SYMMETRIC; KEEP SAME
CCB(start+23).K(1,1)=K(1,1)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+24).K(1,1)=K(1,1)*(1-CCwings.impedanceSpread*spreadScale);
CCB(start+25).K(2,2)=K(2,2)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+26).K(2,2)=K(2,2)*(1-CCwings.impedanceSpread*spreadScale);
CCB(start+27).K(2,1)=K(2,1)*(1+CCwings.impedanceSpread*spreadScale);
CCB(start+27).K(1,2)=K(1,2)*(1+CCwings.impedanceSpread*spreadScale); % SYMMETRIC; KEEP SAME
CCB(start+28).K(2,1)=K(2,1)*(1-CCwings.impedanceSpread*spreadScale);
CCB(start+28).K(1,2)=K(1,2)*(1-CCwings.impedanceSpread*spreadScale); % SYMMETRIC; KEEP SAME
CCB(start+29).X=X-CCwings.shoulderSpread*spreadScale;            
CCB(start+30).X=X+CCwings.shoulderSpread*spreadScale;            
CCB(start+31).Y=Y-CCwings.shoulderSpread*spreadScale;            
CCB(start+32).Y=Y+CCwings.shoulderSpread*spreadScale;    

CCB(start+33).X=X-CCwings.shoulderSpread;            
CCB(start+33).Y=Y-CCwings.shoulderSpread;            

CCB(start+34).X=X+CCwings.shoulderSpread;           
CCB(start+34).Y=Y-CCwings.shoulderSpread;            

CCB(start+35).X=X+CCwings.shoulderSpread;            
CCB(start+35).Y=Y+CCwings.shoulderSpread;        

CCB(start+36).X=X-CCwings.shoulderSpread;         
CCB(start+36).Y=Y+CCwings.shoulderSpread;                             
% Note: inital CCB is "best guess"

%CCB                                           
fprintf(' ~ END setupCopycat.m ~')
return