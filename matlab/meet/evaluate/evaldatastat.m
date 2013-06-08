function evaldatastat(varargin)
total = 0;
nseq = 0;
for i = 1 : length(varargin)
  data = varargin{i};
  nframe = cellfun(@(x) size(x, 2), data.Y);
  total = total + sum(nframe);
  nseq = nseq + length(nframe);
end
logdebug('evaldatastat', 'average nframe', total / nseq);
logdebug('evaldataset', 'total nframe', total);