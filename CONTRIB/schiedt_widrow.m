% Adaptive Noise Canceller
%
%Date: Thu, 18 Mar 1999 01:15:36 -0600 
%X-Phforward: V1.0@casbah 
%To: "sandro@nwu.edu" <sandro@nwu.edu> 
%From: "Robert A. Scheidt" <scheidt@ieee.org> 
%Cc: j-patton@nwu.edu, c-mah@nwu.edu, w-rymer@nwu.edu 
%Mime-Version: 1.0 
%Content-Type: multipart/mixed; boundary="=====================_921762936==_" 
%X-UIDL: 77450f45293ddfb29d830ba1a2044d5b 
%Status: RO 
%
%
%Hi,
%
%
%As promised, here is a matlab simulation of my proposed adaptive canceller
%for the resonance problem with the robot.  I propose we give it a try after
%everyone has played with the code a bit.  While the number of lines of code
%is small, the algorithm it implements is quite rich and mathematically
%beautiful. I'd be happy to present the math behind this "filter" at an
%up-coming sandro-lab meeting. (It should only take ~15 minutes to explain).
%
%
%Bob Scheidt
%
% adaptive canceller example (Widrow and Stearn, pg 316)
% preprocess data (originally sampled at 250 Hz) and resample
% at  6000 Hz (allowing 100 samples per cycle in noise template).
% if noise is 60 cycle noise. Our resonance is ~100 Hz, but the
% algorithmic difference is trivial.
%
% RA Scheidt
% 3/17/99
%
data = load170b('','cu01_1.250',0,inf);  % use whatever data set you like...
d = INTERP(data,24);
noise_profile = cos((1/6000:1/6000:30)*2*pi*60);
a=d+200*noise_profile;


template = noise_profile(1:100);
%
% setup adaptive filter
%
cos_index = 1;
sin_index = length(template)/4;
cos_weight = 0;
sin_weight = 0;
mu = 0.005;   % try 0.01 for a faster convergence (but added
              % residual artifact).

max_index = length(template);
output = zeros(length(a),1);

for rasi=1:(length(a))
   x1 = template(cos_index);
   x2 = template(sin_index);
   cos_index = (cos_index+1);
   if (cos_index > max_index)
      cos_index = 1;
   end
   sin_index = (sin_index+1);
   if (sin_index > max_index)
      sin_index = 1;
   end
   y_k = (cos_weight*x1) + (sin_weight*x2);
   error = d(rasi)-y_k;
%   error = a(rasi)-y_k;
   output(rasi) = error;
   cos_weight = cos_weight + (2*mu*error*x1);
   sin_weight = sin_weight + (2*mu*error*x2);
end

% Now compare output to the original input 'd' and to
%    the noise-corrupted signal 'a'. Convergence occurs
%    within a few cycles!
%
% Also important, look at d-output for un-canceled noise.
%
% Also try running the algorithm on d (not 'a') to see the
%    artifact injected by the canceller (assuming no 60 cycle noise
%    in the reference signal 'd').
%
