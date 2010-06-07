% *********************  MATLAB "M" function (jim Patton) *******************************
% takes (2) x-y (columns) by time (rows) matrices and calculates a dist vs time vector, and averages it.
% updated 23 June 1994

function l=distance(dist,prox)

xd=[dist(:,1) prox(:,1)];
yd=[dist(:,2) prox(:,2)];
d=sqrt((xd(:,2)-xd(:,1)).^2+(yd(:,2)-yd(:,1)).^2);
%plot(d);
%title('marker distance vs time');
l = mean(d);

