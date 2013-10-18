function evalall(varargin)
% EVALL evaluate all data.
for i = 1 : 2 : length(varargin)
  Y = varargin{i}.Y;
  R = varargin{i + 1};
  for c = 1 : 6
    stat = evalbyclass(Y, R, c);
    aggregatecv(stat);
  end
end

end