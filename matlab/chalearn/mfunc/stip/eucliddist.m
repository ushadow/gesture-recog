function dmat=eucliddist(p1,p2)

%
% dmat=eucliddist(p1,p2)
%
%   Euclidean distance between sets of points p1 and p2
%   p1 is m1*n array; p2 is m2*n array where m1 and m2 are
%   the number of points in each set and n is the dimensionality
%   of the Euclidean space. The result 'dmat' is an m1*m2 matrix
%   with distances between all pairs of points.
%   If m1=m2=1 eucliddist returns the distance between two points.
%   If p2 is omitted, 'dmat' is m1*m1 and contains distances
%   between points in p1, hence diag(dmat)=0.
%

if nargin<2
  p2=p1;
end

dmat=sqrt(sum(p1.^2,2)*ones(1,size(p2,1)) + ones(size(p1,1),1)*sum(p2.^2,2)' - 2*p1*p2');
