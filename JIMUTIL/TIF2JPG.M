% ************** MATLAB "M" function (jim Patton) *************
% Make a thumbnail image at a fraction (scalar) or pixel dimension (2d)
% SYNTAX:     makeThumb(filename,d,show);
% INPUTS:     
% OUTPUTS:    
% VERSIONS:   3-2-0
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~


function tif2jpg

fprintf('\n~ tif2jpg.m ~ : ...') 

s=dir('*.tif');
for i=1:length(s)
 fprintf('.%s',s(i).name) 
 [img,map]=imread(s(i).name);
 imshow(img,map);
 imwrite(img,[s(i).name '.jpg'],'jpg');
end

fprintf('~ END tif2jpg.m ~') 