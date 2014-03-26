function [X, model, param] = motion(~, X, frame, param)
%% MOTION computes motion features velocity and acceleration from position
%   features.

model = [];

posNdxRange = 1 : param.startDescriptorNdx - 1;
  
if isstruct(X)
  fn = fieldnames(X);
  for i = 1 : length(fn)
    D = X.(fn{i});
    frame1 = frame.(fn{i});
    X.(fn{i}) = computemotion(D, frame1, posNdxRange);
  end
else
  X = computemotion(X, frame, posNdxRange);
end
end

function data = computemotion(data, frame, posNdxRange)
% ARGS
% data  - cell array

nseq = length(data);
for i = 1 : nseq
  seq = data{i};
  pos = seq(posNdxRange, :);
  pos = smoothts(pos, 'b', 15);
  vel = zeros(size(pos));
  accel = zeros(size(pos));
  vel(:, 2 : end) = pos(:, 2 : end) - pos(:, 1 : end - 1);
  accel(:, 2 : end) = vel(:, 2 : end) - vel(:, 1 : end - 1);
  
  frame1 = frame{i};
  time = ones(1, size(frame1, 2));
  time(2 : end) = frame1(2 : end) - frame1(1 : end - 1);
  time = repmat(time, [size(vel, 1) 1]);
  data{i} = [pos; vel ./ time; accel ./ time; ...
             seq(posNdxRange(end) + 1 : end, :)];
end
end