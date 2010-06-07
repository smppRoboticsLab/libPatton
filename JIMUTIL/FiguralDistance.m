function [FE infNorm hd] = FiguralDistance(T1,T2,doPlot)
% The figural distance between to trajectories.
%
% [FE infNorm hd] = FiguralDistance(T1,T2,doPlot)
%
% T1 and T2 are nx2 matricies that represent 2-D trajectories, where n is
% the number of sampled points along the trajectory and the two colomn are
% the two distinct dimensions.
%
% The figural distance between two trajectories is the sum of the minimum
% distances from each point in T1 to each point in T2 and the sum of the
% minimum distances from each point in T2 to each point in T1, normalized 
% by the number of total points in T1 plus T2. This positive scalar value
% is returned in FE.
% FE = [sum(min(d(T1,T2))) + sum(min(d(T2,T1)))] / points([T1 T2])
%
% The infNorm is the smaller of the of the maximum minimum distances.
% infNorm = min{ max[min(d(T1,T2))], max[min(d(T2,T1))] }
%
% hd is the Hausdorff Distance between the two sets of points, T1 and T2.
% See help on HausdorffDist for more information.
%
% If the input doPlots is included and is true, the trajectories will be
% plotted.
%
% EXAMPLE
% T1 = [linspace(1,5,20); linspace(1,2,20)]' + 0.1*randn(20,2);
% T2 = [sin(-pi:pi/32:pi)+2; cos(-pi:pi/32:pi)+1]';
% T3 = [0.85:0.05:5; 1+1.5*cos(2.*(0.85:0.05:5))]';
% th = -1.5*pi:pi/64:1.5*pi;
%
% figure;
% [FE infNorm hd] = FiguralDistance(T1,T2,true);
% figure;
% [FE infNorm hd] = FiguralDistance(T1,T3,true);
% figure;
% [FE infNorm hd] = FiguralDistance([th; cos(th)]',[th; sin(th)]',true);
% 
%
%
% REVISIONS:    2/22/99   (patton) took de.m (conditt) & enhanced comments
% EDITS: (ZCD May 2010) Improved efficiency by using outputs from the
%   vectorized HausdorffDist function (danziger), eliminated resampling
%   option, added Hausdorff Distance as an output, increased plotting
%   visibility and increased comments.
%

% reorient vectors if necessary
if size(T1,2)~=2, T1=T1'; end
if size(T2,2)~=2, T2=T2'; end

% Implement the Hausdorff Distance, which is the heart of the code. See
% HausdorffDist for a detailed description.
[hd D] = HausdorffDist(T1,T2);

% obtain min(d(T1,T2)) and min(d(T2,T1))
T1toT2 = min(D,[],1);
T2toT1 = min(D,[],2)';

FE = sum([T1toT2 T2toT1]) / (size(T1,1)+size(T2,1));
infNorm = min( [max(T1toT2) max(T2toT1)] );


% PLOTTING
if nargin==3 && doPlot
    
    % recalc only when plotting, and we know we are not optimizing for
    % speed
    resp = sort([max(T1toT2) max(T2toT1)]);
    [infNormProw infNormPcol] = ind2sub( size(D), find(resp(1)==D,1,'first') );
    [hdProw hdPcol] = ind2sub( size(D), find(resp(2)==D,1,'first') );
    
    hold on
    plot(T1(:,1),T1(:,2),'-or',T2(:,1),T2(:,2),'-ob',...
        'linewidth',2,'markersize',2)
    % get all shortest distances T1toT2 for plotting
    [I J] = ind2sub( size(D), find(repmat(T1toT2,[size(D,1) 1])==D) );
    T1p = T1(I,:); T2p = T2(J,:);
    for k = 1:length(I)
        plot([T1p(k,1) T2p(k,1)],[T1p(k,2) T2p(k,2)],'--g')
    end
    % get all shortest distances T2toT1 for plotting
    [I J] = ind2sub( size(D), find(repmat(T2toT1,[size(D,2) 1])'==D) );
    T1p = T1(I,:); T2p = T2(J,:);
    for k = 1:length(I)
        plot([T1p(k,1) T2p(k,1)],[T1p(k,2) T2p(k,2)],'-.m')
    end
    
    % add results
    plot([T1(infNormProw,1) T2(infNormPcol,1)],...
        [T1(infNormProw,2) T2(infNormPcol,2)],'-ks','markersize',12,'linewidth',2)
    plot([T1(hdProw,1) T2(hdPcol,1)],...
        [T1(hdProw,2) T2(hdPcol,2)],'-k*','markersize',12,'linewidth',2)
    
    % extras
    axis equal
    h = findobj(gca,'Type','line');
    legend(h([end end-1 1 2]),'T1','T2','Hausdorff','Inf Norm','location','best')
    title({'Figural Distance';...
        sprintf('Figural Distance: %g   Infinity Norm: %g    Hausdorff Distance: %g',[FE infNorm hd])})
end
