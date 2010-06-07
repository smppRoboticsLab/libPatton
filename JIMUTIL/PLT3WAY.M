% ********************* MATLAB "M" function  (jim Patton) ********************
% The following plots mean and variances variables for 3 factors (X,Y, and Z)
%
% 	INPUTS:		m	 	mean matrix, stuctured as X=rows, Y=block
% 					of columns, and Z=columns, so that Z are 
%					columns that are repeated for each Y:
%					  X1Y1Z1 X1Y1Z2 X1Y1Z3 X1Y2Z1 X1Y2Z2 X1Y2Z3
%					  X2Y1Z1 X2Y1Z2 X2Y1Z3 X2Y2Z1 X2Y2Z2 X2Y2Z3
% 						(FOR EXAMPLE)
%			s 		variance (of some sort) matrix, with the 
%					same structure as m.
% 			nX,nY,nZ,	numver of levels for each variable
%			qY, qZ		#parcels(spaces) btwn. Y and Z variables plotted
%			Xnames,		text names for each level for each variable 
%			Ynames,		to appear on the graph 
%			Znames,
%			title_txt 	title of plot
% 	OUTPUTS:	
% 	CALLS TO:	
% 	CALLED FROM:	?
% 	SYNTAX:		dummy=plt3way(m,v,nX,nY,nZ,qY,qZ,Xnames,Ynames,Znames,title_txt);
% 	example:	plt3way(DPE,var,10,2,10,20,0,'',daynames,forcenames,'titletext!');
%
% initiatied 10/25/95 by jim patton from doanova8.m
%~~~~~~~~~~~~~~~~~~~~~~ Begin Program: ~~~~~~~~~~~~~~~~~~~~~~~~~~
function dummy=plt3way(m,v,nX,nY,nZ,qY,qZ,Xnames,Ynames,Znames,title_txt);
fprintf('~plt3way.m MATLAB m-function (Patton)~');

%__________________ render data___________________________
hold on;
TOTp = nX*nY*nZ + (nY+1)*nZ*qY + (nZ+1)*qZ;
for Z=1:nZ,
  for X=1:nX,
    Y_p=[]; Y_m=[];   
    for Y=1:nY,
      p=( nX*nY*(Z-1) + (Z-1)*(nY+1)*qY + Z*qZ + (Y-1)*nX + Y*qY + X ) / TOTp;
      mean = m(X,(Y-1)*nZ+Z); Y_p=[Y_p p]; Y_m=[Y_m mean]; 
    end %for Y
    handle = plot(Y_p, Y_m, 'k'); 
    set(handle,'LineWidth',3); set(handle,'color',[.6 .6 .6]);
  end %for X
end %for Z

for Z=1:nZ,
  for X=1:nX,
    for Y=1:nY,
      p=( nX*nY*(Z-1) + (Z-1)*(nY+1)*qY + Z*qZ + (Y-1)*nX + Y*qY + X ) / TOTp;
      mean = m(X,(Y-1)*nZ+Z); var  = v(X,(Y-1)*nZ+Z);
      handle = plot([p p],[mean+var mean-var],'k'); 
    end %for Y
  end %for X
end %for Z

%________________________labels_____________________
plot(0,0);  ax=axis; axis off; vrange=ax(4)-ax(3);
plot([.01 0 0 .01 0 0 .01],[ax(3) ax(3) 0 0 0 ax(4) ax(4)], 'b');
handle=text(-.005, ax(3), num2str(ax(3))); 	set(handle,'HorizontalAlignment','Right');
handle=text(-.005, 0,     '0'); 		set(handle,'HorizontalAlignment','Right');
handle=text(-.005, ax(4), num2str(ax(4))); 	set(handle,'HorizontalAlignment','Right');

title(title_txt);
X=1;
for Z=1:nZ,
  %Y=1; p=( *(Z-1) + (Z-1)*(nY+1)*qY + Z*qZ + (Y-1)*nX + Y*qY + X ) / TOTp;
  p=( nX*nY + (nY+1)*qY + qZ )/TOTp;
  handle=text(p*(Z-1)+p/2, ax(3)-.05*vrange, Znames(Z,:) );
  set(handle,'HorizontalAlignment','center');
  for Y=1:nY,
    p=( nX*nY*(Z-1) + (Z-1)*(nY+1)*qY + Z*qZ + (Y-1)*nX + Y*qY + X ) / TOTp;
    handle=text(p, ax(3), Ynames(Y,:) ); %set(handle,'HorizontalAlignment','center'); 
  end %for Y
end %for Z


disp('~(END plt3way.m)~');


