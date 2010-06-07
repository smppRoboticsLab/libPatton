function [hd D] = HausdorffDist(P,Q)
% Calculates the Hausdorff Distance between P and Q
%
% hd = HausdorffDist(P,Q)
% [hd D] = HausdorffDist(P,Q)
%
% Calculates the Hausdorff Distance, hd, between two sets of points, P and Q
% (which could be two trajectories) in two dimensions. Sets P and Q must
% therefore be 2-dimensional matrices, though not necessarily of equal size.
%
% The Directional Hausdorff Distance (dhd) is defined as:
% dhd(P,Q) = max p c P [ min q c Q [ ||p-q|| ] ].
% Intuitively dhd finds the point p from the set P that is farthest from any
% point in Q and measures the distance from p to its nearest neighbor in Q.
% 
% The Hausdorff Distance is defined as max{dhd(P,Q),dhd(Q,P)}
%
% D is the matrix of distances where D(n,m) is the distance of the nth
% point in P from the mth point in Q.
%
%
% 
% %%% ZCD Oct 2009 %%%
% Edits ZCD: Added the matrix of distances as an output. Fixed bug that
%   would cause an error if one of the sets was a single point. Removed
%   excess calls to "size" and "length". - May 2010
%

sP = size(P); sQ = size(Q);

if ndims(P)>2 || ndims(Q)>2
    error('Inputs must be 2-D vectors')
elseif isempty(find(sP==2,1)) || isempty(find(sQ==2,1))
    error('Inputs must be 2-D vectors')
end
% reorient vectors
if sP(2)~=2, P=P'; sP = size(P); end
if sQ(2)~=2, Q=Q'; sQ = size(Q); end

% obtain all possible point comparisons
iP = repmat(1:sP(1),[1,sQ(1)])';
iQ = repmat(1:sQ(1),[sP(1),1]);
combos = [iP,iQ(:)];

% get distances for each point combination
cP=P(combos(:,1),:); cQ=Q(combos(:,2),:);
dists = sqrt( (cP(:,1)-cQ(:,1)).^2 + (cP(:,2)-cQ(:,2)).^2 );

% Now create a matrix of distances where D(n,m) is the distance of the nth
% point in P from the mth point in Q. The maximum distance from any point
% in Q from P will be max(D,[],1) and the maximum distance from any point
% in P from Q will be max(D,[],1);
D = reshape(dists,sP(1),[]);

% Obtain the value of the point, p, in P with the largest minimum distance
% to any point in Q.
vp = max(min(D,[],2));
% Obtain the value of the point, q, in Q with the largets minimum distance
% to any point in P.
vq = max(min(D,[],1));

hd = max(vp,vq);


