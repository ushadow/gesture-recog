%quick wrapper for min Euclidean distance for kmeans labeling

function vword = findvword(vocab, X)
%   tic
   center = vocab';
   X = X';
   [val,vword] = max(bsxfun(@minus,center'*X,0.5*sum(center.^2,1)')); ...
   % assign samples to the nearest centers   
   vword = vword';
%   toc
end
