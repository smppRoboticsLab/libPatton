

%cd D:\jim\ResearchProjects\field_design\experiments\RCB 
%groupAnalysis(1,[39 40 41 43],'pilot',[3 6])  

figure(3); clf
label=1;

phasesOfInterest=[2 5 7 8 11 12 13 14 15];
phasesOfInterest=[7 12];
phasesOfInterest=[2 12 13 14 15];

cd D:\jim\ResearchProjects\field_design\experiments\ifd\ifd_11-18
groupAnalysis(1,11:18,'ifd',phasesOfInterest,[],'o','-',2,.02,label)

cd D:\jim\ResearchProjects\field_design\experiments\ifd\ifd_21-26
groupAnalysis(1,23:26,'ifd',phasesOfInterest,[],'s')


