function [X,map]=pcxread(filename);
%PCXREAD Read a PCX (ZSoft Paint Format) file from disk.
%	[X,MAP]=PCXREAD('filename') reads the file 'filename' and returns
%	the indexed image X and associated colormap MAP.  The image 
%	is not displayed. If no extension is given for the filename,
%	the extension '.pcx' is assumed.
%
%	Note: Currently, only 256 color PCX files are supported.
%
%	See also: PCXWRITE, BMPREAD, GIFREAD, HDFREAD, TIFFREAD,
%	          XWDREAD.

%	Mounil Patel 7/20/93
%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1995/02/22 19:24:19 $

if (nargin~=1)
	error('Requires a filename as an argument.');
end;

if (isstr(filename)~=1)
	error('Requires a string filename as an argument.');
end;

if (isempty(findstr(filename,'.'))==1)
	filename=[filename,'.pcx'];
end;

fid=fopen(filename,'rb','l');
if (fid==-1)
	error(['Error opening ',filename,' for input.']);
end;

nZflag=fread(fid,1,'uchar');
nVer=fread(fid,1,'uchar');
nEncoding=fread(fid,1,'uchar');
nBits=fread(fid,1,'uchar');
nXmin=fread(fid,1,'short');
nYmin=fread(fid,1,'short');
nXmax=fread(fid,1,'short');
nYmax=fread(fid,1,'short');
nHres=fread(fid,1,'short');
nVres=fread(fid,1,'short');
nHPalette=fread(fid,48,'uchar');
nReserved=fread(fid,1,'uchar');
nPlanes=fread(fid,1,'uchar');

if ((nPlanes~=1)|(nBits~=8))
	error('PCXREAD can only load 256 color PCX images.');
end;

nBytesPerLine=fread(fid,1,'short');
nHPaletteInf=fread(fid,1,'short');
nVidX=fread(fid,1,'short');
nVidY=fread(fid,1,'short');
nBlanks=fread(fid,54,'uchar');

if (nZflag~=10)
	error('Not a ZSOFT PCX file.');
end

if (nVer<5)
	error('Cannot load PCX files older than version 5.');
end

% nLine=1;
nByte=1;

imageWidth = nXmax - nXmin + 1;
imageHeight = nYmax - nYmin + 1;
linePaddingSize = ((nBytesPerLine * nPlanes) * floor(8/nBits)) - ...
    ((nXmax - nXmin) + 1);

rawdata=fread(fid);

nEnd=length(rawdata)-768;

X=unrle(rawdata(1:nEnd),imageHeight,imageWidth+linePaddingSize,192);
X=(X+1)';
if (linePaddingSize > 0)
  X = X(:,1:imageWidth);
end

[m,n]=size(rawdata);
map=rawdata((nEnd+1):(m*n));
map=reshape(map,3,256);
map=(map')./255;

cmax=max(max(X));
map=map(1:cmax,:);

fclose(fid);
