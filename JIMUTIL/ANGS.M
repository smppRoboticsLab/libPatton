%function [hdang,trang]=angs(xmark,Bon,Boff,dneck,efreq);
% Calculates joint angles from kinematic data. Currently calculates only head and trunk angle (with respect to space)
%CALLS: markers
%INPUTS: xmark (kinematic data), Bon and Boff (from dv.txt files), efreq (ELITE collection frequency)
%OUTPUTS: angmat:  first column is head angle; second column is trunk angle

function [hdang,trang]=angs(xmark,Bon,Boff,dneck,efreq)


%Identify the kinematic data
[temple,ear,neck,shlder,elbow,wrist,waist,hip,knee,ankle,toe,da,LCH]=MARKERS(xmark,efreq,dneck); 

%Hd ang defined by temple and jaw mrkrs
hdx = temple(:,1) - ear(:,1);
hdy = temple(:,2) - ear(:,2);
t_hdang=(atan2(hdx,hdy)*180/pi);
hdbase=mean(t_hdang(Bon:Boff));
hdang=t_hdang-hdbase;

%Trunk angle defined by neck and waist markers
trx = neck(:,1) - waist(:,1);
try = neck (:,2) - waist(:,2);
t_trang=(atan2(trx,try)*180/pi);
trbase=mean(t_trang(Bon:Boff));
trang=t_trang-trbase;


