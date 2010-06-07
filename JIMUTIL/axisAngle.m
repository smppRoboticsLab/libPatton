%% function for a homogenous transform matrix that rotates about k axis
% Syntax:  T=axisAngle(k,theta) 

function T=axisAngle(k,theta) 

k=k./norm(k);                             % in case not norm
kx=k(1); ky=k(2); kz=k(3); th=theta;      % shorthand
sTh=sin(th); cTh=cos(th); vTh=1-cTh;      % shorthand

 T  =[kx^2*vTh+cTh      kx*ky*vTh-kz*sTh    kx*kz*vTh+ky*sTh    0 
      kx*ky*vTh+kz*sTh  ky^2*vTh+cTh        ky*kz*vTh-kx*sTh    0
      kx*kz*vTh-ky*sTh  ky*kz*vTh+kx*sTh    kz^2*vTh+cTh        0
      0                 0                   0                   1  ];  

end % end of function transform
