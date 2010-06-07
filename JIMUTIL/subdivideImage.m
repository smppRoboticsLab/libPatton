% ************** MATLAB "M" function (jim Patton) *************
% load and create a evenly sliced subdivided mess of images 
% SYNTAX:     subdivideImage(filename,d,show);
% INPUTS:     
% OUTPUTS:    
% VERSIONS:   3-2-0
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function subdivideImage(filename,n,outRoot,show,m,b)

if ~exist('show'), show=1; end                    % if not passed
if ~exist('m'), m=1; end                          % if not passed (for output filename)
if ~exist('b'), b=1; end                          % if not passed (for output filename)
imgr=0; map=0; OK=0; k=0;                         % init
filename=deblank(filename);                       % clip
fnl=length(filename);                             % length

imageInfo=imfinfo(filename);                      % get a bunch o info
[img,map]=imread(filename);                       % read file

width=round(imageInfo.Width)/n
height=round(imageInfo.Height)/n

for j=0:n-1
  for i=0:n-1
    fprintf('.');
    c=m*k+b;
    xmin=i*width+1;
    ymin=j*height+1;
    
    rect=[xmin ymin width height];
    imgr=imcrop(img,rect);
    
    if show, imshow(imgr,map); end 
    
    outName=[outRoot num2str(c) '.jpg'];  % insert jpg at end of name
    imwrite(imgr,outName,'jpg');                    % force a conversion to jpeg
    k=k+1;
    %pause
  end
end

return