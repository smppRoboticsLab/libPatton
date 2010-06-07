% ************** MATLAB "M" function (jim Patton) *************
% Make a thumbnail image at a fraction (scalar) or pixel dimension (2d)
% SYNTAX:     makeThumb(filename,d,show);
% INPUTS:     
% OUTPUTS:    
% VERSIONS:   3-2-0
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function [imgr,map,thumbName]=makeThumb(filename,d,show,thumbName)

if ~exist('show'), show=0; end                    % if not passed
imgr=0; map=0; OK=0;                              % init
exts={'gif','jpg','jpeg','tif','tiff','gif','bmp','png','hdf','pcx','xwd','cur','ico'};
if ~exist('thumbName'),    
  thumbName=['thumb_' filename];                  % add thumb_ as prefix
end   

% check for legal filetypes
for i=1:length(exts),
  if strncmp(fliplr(lower(filename)),fliplr(exts{i}) ... % if on list
      ,length(exts{i})),
    OK=1;
  end
end  


if OK,
  
  [img,map]=imread(filename);
  imageInfo=imfinfo(filename);

  if d>10;                                          % if big, presume width
    h=d*imageInfo.Height/imageInfo.Width; 
    d=[h d]; 
  end 

  imgr=imresize(img,d); 
  if show, imshow(imgr,map); end 

  tnl=length(thumbName);
  thumbName(1,tnl-3:tnl)='.jpg';                    % insert jpg at end of name
  imwrite(imgr,thumbName,'jpg');                    % force a conversion to jpeg          
  
else thumbName='nofile.jpg';
  
end
  
return